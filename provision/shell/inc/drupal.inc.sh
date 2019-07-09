#!/bin/bash
#
# drupal.inc.sh
#

function drupal_already_installed(){
    if [[ -e $FILE_COMPOSER ]]; then
        echo "true"
    fi
    echo "false"
}

# Installation of composer dependencies
# in the case we pull the project but we never build it
function drupal_install_dependencies(){
    alert_info "Installation of Drupal 8 dependencies ..."
    alert_info "$(alert_line)"    
    composer --global config process-timeout 2000
    composer install --prefer-dist
    alert_success "Drupal 8 dependencies were installed with success..."
    alert_success "$(alert_line)"
}

function drupal_install(){
    alert_info "Installation of Drupal 8..."
    alert_info "$(alert_line)"    
    
    composer create-project drupal-composer/drupal-project:8.x-dev ./ --stability dev --no-interaction
    alert_success "Drupal 8 was downloaded with success."    
    drush site-install standard --db-url=mysql://${DB_USER}:${DB_PASS}@localhost/${DB_NAME} --account-name=${ADMIN_USER} --account-pass=${ADMIN_PWD} --site-name=${SITE_NAME}

    alert_success "Drupal 8 has been installed with success."
    alert_success "$(alert_line)"    
}