# Framaforms for YunoHost

[![Integration level](https://dash.yunohost.org/integration/framaforms.svg)](https://dash.yunohost.org/appci/app/framaforms) ![](https://ci-apps.yunohost.org/ci/badges/framaforms.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/framaforms.maintain.svg)  
[![Install Framaforms with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=framaforms)

> *This package allows you to install Framaforms quickly and simply on a YunoHost server.  
If you don't have YunoHost, please consult [the guide](https://yunohost.org/#/install) to learn how to install it.*

## Overview
Framaforms is an online forms and surveys service. Registered users are allowed to create forms, share them, collect and visualize results through a simple interface.
See this [article](https://framablog.org/2016/10/05/framaforms-noffrez-plus-les-reponses-que-vous-collectez-a-google/) and this [interview](https://framablog.org/2016/10/05/en-savoir-un-peu-plus-sur-le-projet-framaforms/) (in French) for further informations.

**Shipped version:** 1.0.1

## Screenshot

![Animation that present how to build a form with Framaforms](https://framaforms.org/profiles/framaforms_org/files/imgforms/anim_creation.gif)

## Demo

* [Official demo](https://framaforms.org/)

## Configuration

You can modify some configurations using the Framaforms administration panel. You can log in with the admin user and the password you gave during installation.

## Documentation

 * Official documentation: https://docs.framasoft.org/fr/framaforms/
 * YunoHost documentation: https://yunohost.org/#/app_framaforms

## YunoHost specific features

#### Multi-user support

Are LDAP and HTTP auth supported? **Only LDAP**
Can the app be used by multiple users? **Yes**

#### Supported architectures

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/framaforms%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/framaforms/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/framaforms%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/framaforms/)

## Limitations

* Any known limitations.

## Additional information

* Other info you would like to add about this app.

## Links

 * Report a bug: https://github.com/YunoHost-Apps/framaforms_ynh/issues
 * App website: https://framaforms.org/
 * Upstream app repository: https://framagit.org/framasoft/framaforms
 * YunoHost website: https://yunohost.org/

---

## Developer info

Please send your pull request to the [testing branch](https://github.com/YunoHost-Apps/framaforms_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/framaforms_ynh/tree/testing --debug
or
sudo yunohost app upgrade framaforms -u https://github.com/YunoHost-Apps/framaforms_ynh/tree/testing --debug
```
