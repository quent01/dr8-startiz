#!/bin/bash
#
# provisionning.inc.sh
#

function start_provisionning(){
    alert_info "Provisioning virtual machine..."
    alert_info "$(alert_line)"
    alert_info "You choose to install ${CMS} version 8 with the stack ${STACK}"
    alert_info "Your project directory will be ${PROJECT_DIR} and web root ${WEB_ROOT}"
    alert_info "It will work on php ${PHP_BASE_VERSION}"
}

function drupal_provisionning(){
    alert_info "$(alert_line)"
    alert_info "Provisioning Drupal..."
    alert_info "$(alert_line)"

    cd /var/www/
    mkdir -p ${PROJECT_DIR}
    cd "${PROJECT_DIR}"

    if [[ "$(drupal_already_installed)" == "true" ]]; then
        alert_info "Drupal 8 already installed."
        drupal_install_dependencies
    else
        drupal_install
    fi

    alert_success "$(alert_line)"
    alert_success "End Provisioning Drupal..."
    alert_success "$(alert_line)"
}