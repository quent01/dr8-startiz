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
    alert_info "Installation of ${CMS} ${CMS_VERSION} dependencies ..."
    alert_info "$(alert_line)"    
    composer --global config process-timeout 0
    composer global require hirak/prestissimo
    composer require zaporylie/composer-drupal-optimizations:^1.1 --dev
    composer install --prefer-dist --optimize-autoloader
    alert_success "${CMS} ${CMS_VERSION} dependencies were installed with success..."
    alert_success "$(alert_line)"
}

function drupal_install_modules(){
    cd $PATH_PUBLIC
    local arr=("$@")
    local opt="${@: -1}"
    alert_info "Installation of ${CMS} ${CMS_VERSION} modules"
    alert_info "$(alert_line)"

    if [[ $opt == "--dev" ]]; then
        unset 'arr[${#arr[@]}-1]'
    fi

    local arr_length="${#arr[@]}"

    for module in "${!arr[@]}"; do
        local step=$(($module+1))
        alert_info "(${step}/${arr_length}) : Installation of module drupal/${arr[$module]}"

        if [[ $opt == "--dev" ]]; then
            composer require --dev "drupal/${arr[$module]}"
        else
            composer require "drupal/${arr[$module]}"
        fi
    done
}

function drupal_enable_modules(){
    local arr=("$@")
    local arr_length="${#arr[@]}"

    alert_info "Activation of ${CMS} ${CMS_VERSION} modules"
    alert_info "$(alert_line)"
    for module in "${!arr[@]}"; do
        local path_module="${PATH_MODULES_CONTRIB}${arr[$module]}"
        local step=$(($module+1))

        if [[ -d "$path_module" ]]; then
            alert_info "(${step}/${arr_length}) : Activation of module ${arr[$module]}"
            drush en ${arr[$module]}
        fi
    done
}

function drupal_install(){
    alert_info "Installation of ${CMS} ${CMS_VERSION}..."
    alert_info "$(alert_line)"   
    
    composer --global config process-timeout 0    
    composer create-project drupal-composer/drupal-project:8.x-dev ./ --stability dev --no-interaction --no-install --prefer-dist --remove-vcs
    composer install --prefer-dist --optimize-autoloader
    alert_success "${CMS} ${CMS_VERSION} was downloaded with success."    
    drush site-install standard --db-url=mysql://${DB_USER}:${DB_PASS}@localhost/${DB_NAME} --account-name=${ADMIN_USER} --account-pass=${ADMIN_PWD} --site-name=${SITE_NAME}

    # Installation of modules
    cd $PATH_PUBLIC
    drupal_install_modules "${ARR_MODULES[@]}"
    drupal_enable_modules "${ARR_MODULES[@]}"
    
    drupal_install_modules "${ARR_MODULES_DEV[@]}" "--dev"
    drupal_enable_modules "${ARR_MODULES_DEV[@]}"
    
    sudo find ./ -type f -exec chmod 664 {} +
    sudo find ./ -type d -exec chmod 775 {} +

    alert_success "${CMS} ${CMS_VERSION} has been installed with success."
    alert_success "$(alert_line)"    
}