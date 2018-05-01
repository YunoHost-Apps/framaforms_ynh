#!/bin/bash

# LOCAL ADDITION:
# save file locally if not in the cache
#
# Download, check integrity, uncompress and patch the source from app.src
#
# The file conf/app.src need to contains:
#
# SOURCE_URL=Address to download the app archive
# SOURCE_SUM=Control sum
# # (Optional) Program to check the integrity (sha256sum, md5sum...)
# # default: sha256
# SOURCE_SUM_PRG=sha256
# # (Optional) Archive format
# # default: tar.gz
# SOURCE_FORMAT=tar.gz
# # (Optional) Put false if sources are directly in the archive root
# # default: true
# SOURCE_IN_SUBDIR=false
# # (Optionnal) Name of the local archive (offline setup support)
# # default: ${src_id}.${src_format}
# SOURCE_FILENAME=example.tar.gz
#
# Details:
# This helper downloads sources from SOURCE_URL if there is no local source
# archive in /opt/yunohost-apps-src/APP_ID/SOURCE_FILENAME
#
# Next, it checks the integrity with "SOURCE_SUM_PRG -c --status" command.
#
# If it's ok, the source archive will be uncompressed in $dest_dir. If the
# SOURCE_IN_SUBDIR is true, the first level directory of the archive will be
# removed.
#
# Finally, patches named sources/patches/${src_id}-*.patch and extra files in
# sources/extra_files/$src_id will be applied to dest_dir
#
#
# usage: ynh_setup_source dest_dir [source_id]
# | arg: dest_dir  - Directory where to setup sources
# | arg: source_id - Name of the app, if the package contains more than one app
ynh_setup_source_local () {
    local dest_dir=$1
    local src_id=${2:-app} # If the argument is not given, source_id equals "app"

    # Load value from configuration file (see above for a small doc about this file
    # format)
    local src_url=$(grep 'SOURCE_URL=' "$YNH_CWD/../conf/${src_id}.src" | cut -d= -f2-)
    local src_sum=$(grep 'SOURCE_SUM=' "$YNH_CWD/../conf/${src_id}.src" | cut -d= -f2-)
    local src_sumprg=$(grep 'SOURCE_SUM_PRG=' "$YNH_CWD/../conf/${src_id}.src" | cut -d= -f2-)
    local src_format=$(grep 'SOURCE_FORMAT=' "$YNH_CWD/../conf/${src_id}.src" | cut -d= -f2-)
    local src_in_subdir=$(grep 'SOURCE_IN_SUBDIR=' "$YNH_CWD/../conf/${src_id}.src" | cut -d= -f2-)
    local src_filename=$(grep 'SOURCE_FILENAME=' "$YNH_CWD/../conf/${src_id}.src" | cut -d= -f2-)

    # Default value
    src_sumprg=${src_sumprg:-sha256sum}
    src_in_subdir=${src_in_subdir:-true}
    src_format=${src_format:-tar.gz}
    src_format=$(echo "$src_format" | tr '[:upper:]' '[:lower:]')
    if [ "$src_filename" = "" ] ; then
        src_filename="${src_id}.${src_format}"
    fi
    local local_src="/var/cache/yunohost/ynh_setup_source/${YNH_APP_ID}/${src_filename}"

    # if cache file exists and the checksum isn't good, download it again
    # if not, just download the file

    if test -e "$local_src"
    then
    	echo "${src_sum} ${local_src}" | ${src_sumprg} -c --status \
        	|| wget -nv -O $local_src $src_url
    else
    	mkdir -p "/var/cache/yunohost/ynh_setup_source/${YNH_APP_ID}"
    	wget -nv -O $local_src $src_url
    fi
    cp $local_src $src_filename

    # Check the control sum
    echo "${src_sum} ${src_filename}" | ${src_sumprg} -c --status \
        || ynh_die "Corrupt source"

    # Extract source into the app dir
    mkdir -p "$dest_dir"
    if [ "$src_format" = "zip" ]
    then
        # Zip format
        # Using of a temp directory, because unzip doesn't manage --strip-components
        if $src_in_subdir ; then
            local tmp_dir=$(mktemp -d)
            unzip -quo $src_filename -d "$tmp_dir"
            cp -a $tmp_dir/*/. "$dest_dir"
            ynh_secure_remove "$tmp_dir"
        else
            unzip -quo $src_filename -d "$dest_dir"
        fi
    else
        local strip=""
        if $src_in_subdir ; then
            strip="--strip-components 1"
        fi
        if [[ "$src_format" =~ ^tar.gz|tar.bz2|tar.xz$ ]] ; then
            tar -xf $src_filename -C "$dest_dir" $strip
        else
            ynh_die "Archive format unrecognized."
        fi
    fi

    # Apply patches
    if (( $(find $YNH_CWD/../sources/patches/ -type f -name "${src_id}-*.patch" 2> /dev/null | wc -l) > "0" )); then
        local old_dir=$(pwd)
        (cd "$dest_dir" \
            && for p in $YNH_CWD/../sources/patches/${src_id}-*.patch; do \
                patch -p1 < $p; done) \
            || ynh_die "Unable to apply patches"
        cd $old_dir
    fi

    # Add supplementary files
    if test -e "$YNH_CWD/../sources/extra_files/${src_id}"; then
        cp -a $YNH_CWD/../sources/extra_files/$src_id/. "$dest_dir"
    fi
}

#=================================================
#
# POSTGRES HELPERS
#
# Point of contact : Jean-Baptiste Holcroft <jean-baptiste@holcroft.fr>
#=================================================

# Create a master password and set up global settings
# Please always call this script in install and restore scripts
#
# usage: ynh_psql_test_if_first_run

ynh_psql_test_if_first_run() {
	if [ -f /etc/yunohost/psql ];
	then
		echo "PostgreSQL is already installed, no need to create master password"
	else
		pgsql=$(ynh_string_random)
		pg_hba=""
		echo "$pgsql" >> /etc/yunohost/psql

		if [ -e /etc/postgresql/9.4/ ]
		then
			pg_hba=/etc/postgresql/9.4/main/pg_hba.conf
		elif [ -e /etc/postgresql/9.6/ ]
		then
			pg_hba=/etc/postgresql/9.6/main/pg_hba.conf
		else
			ynh_die "postgresql shoud be 9.4 or 9.6"
		fi

		systemctl start postgresql
		sudo --login --user=postgres psql -c"ALTER user postgres WITH PASSWORD '$pgsql'" postgres

		# force all user to connect to local database using passwords
		# https://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html#EXAMPLE-PG-HBA.CONF
		# Note: we can't use peer since YunoHost create users with nologin
		#  See: https://github.com/YunoHost/yunohost/blob/unstable/data/helpers.d/user
		sed -i '/local\s*all\s*all\s*peer/i \
		local all all password' "$pg_hba"
		systemctl enable postgresql
		systemctl reload postgresql
	fi
}

# Open a connection as a user
#
# example: ynh_psql_connect_as 'user' 'pass' <<< "UPDATE ...;"
# example: ynh_psql_connect_as 'user' 'pass' < /path/to/file.sql
#
# usage: ynh_psql_connect_as user pwd [db]
# | arg: user - the user name to connect as
# | arg: pwd - the user password
# | arg: db - the database to connect to
ynh_psql_connect_as() {
	user="$1"
	pwd="$2"
	db="$3"
	sudo --login --user=postgres PGUSER="$user" PGPASSWORD="$pwd" psql "$db"
}

# # Execute a command as root user
#
# usage: ynh_psql_execute_as_root sql [db]
# | arg: sql - the SQL command to execute
# | arg: db - the database to connect to
ynh_psql_execute_as_root () {
	sql="$1"
	sudo --login --user=postgres psql <<< "$sql"
}

# Execute a command from a file as root user
#
# usage: ynh_psql_execute_file_as_root file [db]
# | arg: file - the file containing SQL commands
# | arg: db - the database to connect to
ynh_psql_execute_file_as_root() {
	file="$1"
	db="$2"
	sudo --login --user=postgres psql "$db" < "$file"
}

# Create a database, an user and its password. Then store the password in the app's config
#
# After executing this helper, the password of the created database will be available in $db_pwd
# It will also be stored as "psqlpwd" into the app settings.
#
# usage: ynh_psql_setup_db user name [pwd]
# | arg: user - Owner of the database
# | arg: name - Name of the database
# | arg: pwd - Password of the database. If not given, a password will be generated
ynh_psql_setup_db () {
	db_user="$1"
	app="$1"
	db_name="$2"
	new_db_pwd=$(ynh_string_random)	# Generate a random password
	# If $3 is not given, use new_db_pwd instead for db_pwd.
	db_pwd="${3:-$new_db_pwd}"
	ynh_psql_create_db "$db_name" "$db_user" "$db_pwd"	# Create the database
	ynh_app_setting_set "$app" psqlpwd "$db_pwd"	# Store the password in the app's config
}

# Create a database and grant privilegies to a user
#
# usage: ynh_psql_create_db db [user [pwd]]
# | arg: db - the database name to create
# | arg: user - the user to grant privilegies
# | arg: pwd  - the user password
ynh_psql_create_db() {
	db="$1"
	user="$2"
	pwd="$3"
	ynh_psql_create_user "$user" "$pwd"
	sudo --login --user=postgres createdb --owner="$user" "$db"
}

# Drop a database
#
# usage: ynh_psql_drop_db db
# | arg: db - the database name to drop
# | arg: user - the user to drop
ynh_psql_remove_db() {
	db="$1"
	user="$2"
	sudo --login --user=postgres dropdb "$db"
	ynh_psql_drop_user "$user"
}

# Dump a database
#
# example: ynh_psql_dump_db 'roundcube' > ./dump.sql
#
# usage: ynh_psql_dump_db db
# | arg: db - the database name to dump
# | ret: the psqldump output
ynh_psql_dump_db() {
	db="$1"
	sudo --login --user=postgres pg_dump "$db"
}


# Create a user
#
# usage: ynh_psql_create_user user pwd [host]
# | arg: user - the user name to create
ynh_psql_create_user() {
	user="$1"
	pwd="$2"
        sudo --login --user=postgres psql -c"CREATE USER $user WITH PASSWORD '$pwd'" postgres
}

# Drop a user
#
# usage: ynh_psql_drop_user user
# | arg: user - the user name to drop
ynh_psql_drop_user() {
	user="$1"
	sudo --login --user=postgres dropuser "$user"
}
