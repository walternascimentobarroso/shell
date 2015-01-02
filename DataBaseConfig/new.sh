#!/bin/bash
displayimagem(){
clear
cat <<"EOT"
            /(        )`
            \ \___   / |
            /- _  `-/  '
           (/\/ \ \   /\
           / /   | `    \
           O O   ) /    |
           `-^--'`<     '
          (_.)  _  )   /
           `.___/`    /
             `-----' /
<----.     __ / __   \
<----|====O)))==) \) /====
<----'    `--' `.__,' \
             |        |
              \       /
        ______( (_  / \______
      ,'  ,-----'   |        \
      `--{__________)        \/

EOT
}

sair(){
	clear
	exit
}

caduser(){
	clear
	displayimagem
	echo "---------------GERENCIAMENTO DE USUARIO------------------"
	echo "Nome do usuario"
	read userName
	echo "Senha"
	read password
    ${PSQL} -U postgres --command="CREATE USER ${userName} WITH PASSWORD '${password}';"
	menuBase
}

basenew(){
	displayimagem
	echo "---------------GERENCIAMENTO DE USUARIO------------------"
	echo "Nome da Base"
	read baseName
	${PSQL} -U postgres --command="CREATE DATABASE ${baseName} WITH OWNER = postgres;"
	clear
	menuBase
}

baserestore(){
	clear
}

basebackup(){
	clear
}

menuBase(){
	displayimagem
	echo -n "---------------GERENCIAMENTO DO BANCO------------------
	 
	 
	1 - Cadastrar usuario no banco
	2 - Criar nova base de dados
	3 - Restaurar uma base
	4 - Fazer backup de uma base
	0 - Sair
	 
	 
	Escolha uma das opcoes: "
	read opcao
	case "$opcao" in
	1) caduser ;;
	2) basenew ;;
	3) baserestore ;;
	4) basebackup ;;
	0) sair
	 
	esac
}

configInitial(){
	displayimagem
	echo "Qual a senha do usuario postgres?"
	read senhaPostgres
	export PGPASSWORD=$senhaPostgres
	echo "Qual a versão? (ex: 9.3)"
	read versionPostgres
	PSQL=/opt/PostgreSQL/$versionPostgres/bin/psql
	menuBase
}

clear

configInitial
