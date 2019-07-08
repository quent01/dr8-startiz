#!/bin/bash
#
# apache.inc.sh
#



function apache_configure_vhost(){
    # we modify conf file with settings
    sed -i 's/%WEB_ROOT%/${WEB_ROOT}/g' ${PATH_PROVISION_APACHE}${FILE_APACHE_CONF}

    # we copy conf file to vm
    cp ${PATH_PROVISION_APACHE}${FILE_APACHE_CONF} ${PATH_A2_SITES_AVAILABLE}    
    sudo a2dissite 000-default
    sudo a2ensite ${FILE_APACHE}
    sudo service apache2 restart
}