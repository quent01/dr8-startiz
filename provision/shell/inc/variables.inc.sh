#!/bin/bash
#
# variables.inc.sh
#

# Drupal configuration
# @desc : This is the part you can edit
# ---------------------------------------
SITE_NAME="Ceci est un test"
PROJECT_DIR="public"
WEB_ROOT="/var/www/public/web"
LOCALE="fr_FR"
TIMEZONE="Europe/Paris"
ADMIN_USER="tiz"
ADMIN_PWD="azertiz67"
ADMIN_EMAIL="tech@tiz.fr"
ADMIN_FIRSTNAME="Agence"
ADMIN_LASTNAME="Tiz"


# Vagrant variables
# ---------------------------------------
DB_NAME="scotchbox"
DB_USER="root"
DB_PASS="root"
PHP_BASE_VERSION="7"
STACK="apache"
CMS="drupal"


# Colors
# ---------------------------------------
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_NC='\033[0m'              # No Color
C_GREEN='\033[0;32m'
C_BRN='\033[0;33m'
C_BLUE='\033[0;34m'
C_MAGENTA='\033[0;35m'
C_CYAN='\033[0;36m'
C_WHITE='\033[0;97m'


# Filenames
# ---------------------------------------
FILE_APACHE="001-drupal"
FILE_APACHE_CONF="${FILE_APACHE}.conf"
FILE_DRUSH_ALIASES="aliases.drushrc.php"


# Paths
# ---------------------------------------
PATH_A2_SITES_AVAILABLE="/etc/apache2/sites-available/"
PATH_COMPOSER_JSON="${WEB_ROOT}/composer.json"
PATH_PUBLIC="/var/www/public/"
PATH_PROVISION="/var/www/provision/"
PATH_PROVISION_APACHE="${PATH_PROVISION}apache/"
PATH_PROVISION_SHELL="${PATH_PROVISION}shell/"
PATH_VAGRANT="/home/vagrant/"
PATH_DRUSH_ALIASES="${PATH_VAGRANT}/.drush/${FILE_DRUSH_ALIASES}"

