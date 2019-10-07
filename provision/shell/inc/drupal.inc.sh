#!/bin/bash
#
# drupal.inc.sh
#

function drupal_already_installed(){
    if [ -f ${PATH_COMPOSER_JSON} ]; then
        return 0
    fi
    return 1
}

# Installation of composer dependencies
# in the case we pull the project but we never build it
function drupal_install_dependencies(){
    alert_info "Installation of Drupal 8 dependencies ..."
    alert_info "$(alert_line)"    
    composer --global config process-timeout 0
    composer global require hirak/prestissimo
    composer install --prefer-dist --optimize-autoloader
    alert_success "Drupal 8 dependencies were installed with success..."
    alert_success "$(alert_line)"
}

function drupal_install(){
    alert_info "Installation of Drupal 8..."
    alert_info "$(alert_line)"   
    
    composer --global config process-timeout 0    
    composer create-project drupal-composer/drupal-project:8.x-dev ./ --stability dev --no-interaction --no-install --prefer-dist --remove-vcs
    composer install --prefer-dist --optimize-autoloader
    alert_success "Drupal 8 was downloaded with success."    
    drush site-install standard --db-url=mysql://${DB_USER}:${DB_PASS}@localhost/${DB_NAME} --account-name=${ADMIN_USER} --account-pass=${ADMIN_PWD} --site-name=${SITE_NAME}
    
    sudo find ./ -type f -exec chmod 664 {} +
    sudo find ./ -type d -exec chmod 775 {} +

    alert_success "Drupal 8 has been installed with success."
    alert_success "$(alert_line)"    
}