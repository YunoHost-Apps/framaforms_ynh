#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="postgresql curl libzip-dev"

YNH_PHP_VERSION="7.3"

extra_php_dependencies="php${YNH_PHP_VERSION}-fpm php${YNH_PHP_VERSION}-cli php${YNH_PHP_VERSION}-gd php${YNH_PHP_VERSION}-xml php${YNH_PHP_VERSION}-ldap php${YNH_PHP_VERSION}-mbstring php${YNH_PHP_VERSION}-pgsql"

YNH_COMPOSER_VERSION="1.10.17"

#=================================================
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
