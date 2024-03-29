#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

YNH_COMPOSER_VERSION="1.10.17"

#=================================================
# PERSONAL HELPERS
#=================================================

_ynh_exec_with_drush_php() {
    ynh_exec_warn_less ynh_exec_as "$app" \
        env PATH="$install_dir/.composer/vendor/bin:$PATH" \
        DRUSH_PHP="/usr/bin/php$phpversion" \
        "$@"
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
