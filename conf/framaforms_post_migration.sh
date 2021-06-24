#!/bin/bash

# Ending the migration process from Framaforms to Yakforms

set -u

#=================================================
# IMPORT GENERIC HELPERS
#=================================================

source /usr/share/yunohost/helpers

#=================================================
# SET VARIABLES
#=================================================

old_app="__OLD_APP__"
new_app="__NEW_APP__"
script_name="$0"

#=================================================
# REMOVE OLD FAKE PACKAGE
#=================================================
# This step was in the helper originally

# Then remove the old one
app=$old_app
ynh_remove_app_dependencies

app=$new_app

#=================================================
# DELETE OLD APP'S SETTINGS
#=================================================

ynh_secure_remove --file="/etc/yunohost/apps/$old_app"
yunohost app ssowatconf

#=================================================
# REMOVE THE OLD USER
#=================================================

ynh_system_user_delete --username="$old_app"

#=================================================
# DELETE THIS SCRIPT
#=================================================

echo "rm $script_name" | at now + 1 minutes 