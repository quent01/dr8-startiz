#!/bin/bash
#
# apache.inc.sh
#



function apache_configure_vhost(){

    if [ USE_HTTPS ]; then
        sudo a2enmod ssl
        sudo service apache2 restart
        # sudo mkdir /etc/apache2/ssl
        # sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "/C=FR/ST=Paris/L=Paris/O=Agence Tiz/OU=Development/CN=local.test"

        # we modify conf file with settings
        sed -i.bak "s|%WEB_ROOT%|${WEB_ROOT}|g" ${PATH_PROVISION_APACHE}${FILE_APACHE_SSL_CONF}
        # we copy conf file to vm
        cp ${PATH_PROVISION_APACHE}${FILE_APACHE_SSL_CONF} ${PATH_A2_SITES_AVAILABLE}
    fi

    # we modify conf file with settings
    sed -i.bak "s|%WEB_ROOT%|${WEB_ROOT}|g" ${PATH_PROVISION_APACHE}${FILE_APACHE_CONF}

    # we copy conf file to vm
    cp ${PATH_PROVISION_APACHE}${FILE_APACHE_CONF} ${PATH_A2_SITES_AVAILABLE}
    

    # we reset initial file
    cd ${PATH_PROVISION_APACHE}
    rm -f ${FILE_APACHE_CONF}
    rm -f ${FILE_APACHE_SSL_CONF}
    mv ${FILE_APACHE_CONF}.bak ${FILE_APACHE_CONF}
    mv ${FILE_APACHE_SSL_CONF}.bak ${FILE_APACHE_SSL_CONF}

    sudo chmod 644 ${PATH_A2_SITES_AVAILABLE}${FILE_APACHE_CONF}
    sudo a2dissite 000-default
    sudo a2ensite ${FILE_APACHE}

    if [ USE_HTTPS ]; then
        # we reset initial file
        cd ${PATH_PROVISION_APACHE}
        rm ${FILE_APACHE_SSL_CONF}
        mv ${FILE_APACHE_SSL_CONF}.bak ${FILE_APACHE_SSL_CONF}
        
        sudo chmod 644 ${PATH_A2_SITES_AVAILABLE}${FILE_APACHE_SSL_CONF}
        sudo a2ensite ${FILE_APACHE_SSL}
    fi

    sudo service apache2 restart
}