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

function apache_provisionning(){
    alert_info "$(alert_line)"
    alert_info "Provisioning Apache..."
    alert_info "$(alert_line)"
    
    apache_configure_vhost

    alert_success "$(alert_line)"
    alert_success "End Provisioning Apache..."
    alert_success "$(alert_line)"
}

function drupal_provisionning(){
    alert_info "$(alert_line)"
    alert_info "Provisioning ${CMS} ${CMS_VERSION}..."
    alert_info "$(alert_line)"

    cd /var/www/
    mkdir -p ${PROJECT_DIR}
    cd "${PROJECT_DIR}"

    if drupal_already_installed; then
        alert_info "${CMS} ${CMS_VERSION} already installed."
        drupal_install_dependencies
    else
        drupal_install
    fi

    alert_success "$(alert_line)"
    alert_success "End Provisioning ${CMS} ${CMS_VERSION}..."
    alert_success "$(alert_line)"
}