#!/bin/bash
php composer.phar self-update; 
php composer.phar require --dev zendframework/zftool:dev-master; 
php composer.phar require doctrine/doctrine-orm-module:*
php composer.phar install; 

