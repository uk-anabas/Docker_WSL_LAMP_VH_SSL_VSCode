#!/bin/sh
docker exec docker_wsl_lamp_vh_ssl_vscode-php-apache-1 php "$@"
return $?