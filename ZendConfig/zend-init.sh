#!/bin/bash
currentDir=$(pwd)
telaM2Tool="====================M2TOOL=================="
echo $telaM2Tool
echo "Informe o caminho onde deseja iniciar seu projeto:
Ex.: /var/www/";read caminho
cd $caminho
clear
echo $telaM2Tool
echo "Nome do projeto:
Ex.: Projeto";read projeto
#mMaiusculo=`echo -e echo $projeto | sed 's!.*/!!'` --Isso pega a ultima ocorrecia de uma string ex.: echo "/var/www/projeto" | sed 's!.*/!!'

git clone git://github.com/zendframework/ZendSkeletonApplication.git $projeto
cd $projeto

$currentDir/phpVendor.sh
