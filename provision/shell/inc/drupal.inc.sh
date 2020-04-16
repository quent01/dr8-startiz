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
    composer require --no-progress --prefer-dist --no-suggest zaporylie/composer-drupal-optimizations:^1.1 --dev
    composer install --no-progress --prefer-dist --no-plugins --no-suggest
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
            composer require --dev --no-progress --prefer-dist --no-suggest "drupal/${arr[$module]}"
        else
            composer require --no-progress --prefer-dist --no-suggest "drupal/${arr[$module]}"
        fi
    done
}

function drupal_enable_modules(){
    cd $PATH_PUBLIC
    
    local arr=("$@")
    local arr_length="${#arr[@]}"

    alert_info "Activation of ${CMS} ${CMS_VERSION} modules"
    alert_info "$(alert_line)"
    for module in "${!arr[@]}"; do
        local path_module="${PATH_MODULES_CONTRIB}${arr[$module]}"
        local step=$(($module+1))

        if [[ -d "$path_module" ]]; then
            alert_info "(${step}/${arr_length}) : Activation of module ${arr[$module]}"
            vendor/bin/drupal module:install --no-interaction --yes ${arr[$module]}
        fi
    done
}

function drupal_install(){
    alert_info "Installation of ${CMS} ${CMS_VERSION}..."
    alert_info "$(alert_line)"

    cd $PATH_PUBLIC
    
    composer --global config process-timeout 0   
    composer global require --no-progress --prefer-dist hirak/prestissimo 

    composer create-project "drupal-composer/drupal-project:${CMS_VERSION}.x-dev" ./ --no-progress --stability dev --no-interaction --no-install --prefer-dist

    composer install --no-progress --prefer-dist --no-suggest
    composer require --no-progress --prefer-dist --no-suggest zaporylie/composer-drupal-optimizations:^1.1 --dev
    alert_success "${CMS} ${CMS_VERSION} was downloaded with success."    
    vendor/bin/drupal site:install standard --langcode="fr" --db-port="3306" --db-prefix="" --db-type="mysql" --db-host="127.0.0.1" --db-name="${DB_NAME}" --db-user="${DB_USER}" --db-pass="${DB_PASS}" --account-name="${ADMIN_USER}" --account-mail="${ADMIN_EMAIL}" --account-pass="${ADMIN_PWD}" --site-name="${SITE_NAME}" --site-mail="${ADMIN_EMAIL}"

    # Installation of modules
    drupal_install_modules "${ARR_MODULES[@]}"
    drupal_enable_modules "${ARR_MODULES[@]}"
    
    drupal_install_modules "${ARR_MODULES_DEV[@]}" "--dev"
    drupal_enable_modules "${ARR_MODULES_DEV[@]}"
    
    sudo find ./ -type f -exec chmod 664 {} +
    sudo find ./ -type d -exec chmod 775 {} +

    alert_success "${CMS} ${CMS_VERSION} has been installed with success."
    alert_success "$(alert_line)"    
}