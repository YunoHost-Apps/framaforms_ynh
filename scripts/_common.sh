#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="postgresql curl libzip-dev"
extra_pkg_dependencies="php7.2-fpm php7.2-cli php7.2-gd php7.2-mysql php7.2-xml php7.2-ldap php7.2-mbstring php7.2-uploadprogress php7.2-pgsql"

#=================================================
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

ynh_export () {
    local ynh_arg=""
    for var in $@;
    do
        ynh_arg=$(echo $var | awk '{print toupper($0)}')
        if [ "$var" == "path_url" ]; then
            ynh_arg="PATH"
        fi
        ynh_arg="YNH_APP_ARG_$ynh_arg"
        export $var=${!ynh_arg}
    done
}

# Save listed var in YunoHost app settings 
# usage: ynh_save_args VARNAME1 [VARNAME2 [...]]
ynh_save_args () {
    local var
    for var in $@;
    do
        local setting_var="$var"
        if [ "$var" == "path_url" ]; then
            setting_var="path"
        fi
        ynh_app_setting_set --app=$app --key=$setting_var --value="${!var}"
    done
}

source ynh_add_extra_apt_repos__3
source ynh_install_php__3
source ynh_composer__2
