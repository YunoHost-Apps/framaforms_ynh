#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

_ynh_exec_with_drush_php() {
    ynh_hide_warnings ynh_exec_as_app \
        env PATH="$install_dir/.composer/vendor/bin:$PATH" \
        DRUSH_PHP="/usr/bin/php$php_version" \
        "$@"
}
