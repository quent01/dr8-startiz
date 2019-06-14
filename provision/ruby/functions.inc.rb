# -*- mode: ruby -*-
# vi: set ft=ruby :

def conf_file_exists()
    return (File.exist?("vagrant.json"))
end

def is_php7(php_base_version)
    if(php_base_version === '7')
        return true
    end
    return false
end

def is_apache(stack)
    if(stack === 'apache')
        return true
    end
    return false
end