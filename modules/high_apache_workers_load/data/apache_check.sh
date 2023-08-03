

#!/bin/bash

# Check if Apache is installed

if ! command -v apache2 &> /dev/null

then

    echo "Apache is not installed"

    exit

fi

# Check if Apache is running

if ! systemctl is-active --quiet apache2

then

    echo "Apache is not running"

    exit

fi

# Check if Apache configuration is valid

if ! apachectl configtest

then

    echo "Apache configuration is invalid"

    exit

fi

# Check if Apache worker settings are balanced

if [ $(grep -c "BalancerMember" ${PATH_TO_APACHE_CONFIG_FILE}) -lt 2 ]

then

    echo "Apache worker settings are not balanced"

    exit

fi

echo "Apache server is running and workers are balanced"