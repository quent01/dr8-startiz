#!/bin/bash
#
# json.sh
#

function installation_of_shell_dependencies(){
    alert_info "$(alert_line)"
    alert_info "Installation of JQ a JSON parser..."
    alert_info "$(alert_line)"
    yes | sudo apt-get install jq
    alert_success "JQ was installed with success"
}

function json_get_key() {
    KEY="${1}"
    echo "$(cat ${FILE_CONFIG} | jq -r '.'${KEY})"
}

installation_of_shell_dependencies

# JSON VARIABLES
# ---------------------------------------
STACK="$(json_get_key 'stack')"
PROJECT_DIR=$(json_get_key 'project_dir')
WEB_ROOT="$(json_get_key 'web_root')"
LOCALE="$(json_get_key 'locale')"
TIMEZONE="$(json_get_key 'timezone')"
PHP_BASE_VERSION="$(json_get_key 'php_base_version')"
ADMIN_USER="$(json_get_key 'admin.user')";
ADMIN_PWD="$(json_get_key 'admin.password')";
ADMIN_EMAIL="$(json_get_key 'admin.email')";
ADMIN_FIRSTNAME="$(json_get_key 'admin.firstname')";
ADMIN_LASTNAME="$(json_get_key 'admin.lastname')";