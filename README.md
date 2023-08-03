
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High Apache Workers Load
---

This incident type refers to a situation where the Apache server is under high load due to busy workers, which may result in slow or unresponsive websites. This can occur when the number of workers reaches the maximum limit or when a large number of requests are being processed simultaneously. This incident requires immediate attention to avoid any negative impact on the website's performance.

### Parameters
```shell
# Environment Variables

export APACHE_CONFIG_FILE="PLACEHOLDER"

export PATH_TO_APACHE_CONFIG_FILE="PLACEHOLDER"

export DESIRED_NUMBER_OF_WORKERS="PLACEHOLDER"

export MEMORY_LIMIT="PLACEHOLDER"
```

## Debug

### Check the Apache worker status
```shell
systemctl status apache2
```

### Check the number of Apache workers
```shell
ps aux | grep apache2 | grep -v grep | wc -l
```

### Check the Apache server load
```shell
 apachectl status
```

### Check the Apache server log for errors
```shell
tail -f /var/log/apache2/error.log
```

### Check the server access log for traffic
```shell
tail -f /var/log/apache2/access.log
```

### Check the Apache server configuration file for the maximum worker setting
```shell
grep -i 'MaxRequestWorkers' ${APACHE_CONFIG_FILE}
```

### Check the Apache server configuration file for the current worker setting
```shell
grep -i 'MaxClients' ${APACHE_CONFIG_FILE}
```

### A misconfiguration in the Apache server settings that may cause an imbalance in the load distribution among different workers, leading to an overload on some workers.
```shell


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

```

## Repair

### Define variables
```shell
APACHE_CONFIG_FILE=${PATH_TO_APACHE_CONFIG_FILE}

WORKERS_COUNT=${DESIRED_NUMBER_OF_WORKERS}
```

### Update Apache config file
```shell
sed -i "s/MaxRequestWorkers *[0-9]*/MaxRequestWorkers $WORKERS_COUNT/" $APACHE_CONFIG_FILE
```

### Restart Apache server
```shell
systemctl restart apache2.service
```