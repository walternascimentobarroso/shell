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
    ${PSQL}/psql -U postgres --command="CREATE USER ${userName} WITH PASSWORD '${password}';"
	menuBase
}

basenew(){
	displayimagem
	echo "---------------GERENCIAMENTO DE USUARIO------------------"
	echo "Nome da Base"
	read baseName
	${PSQL}/psql -U postgres --command="CREATE DATABASE ${baseName} WITH OWNER = postgres;"
	clear
	menuBase
}

baserestore(){
	displayimagem
	echo "---------------GERENCIAMENTO DE USUARIO------------------"
	echo "Nome da Base a ser restaurada"
	read baseName
	echo "Caminho do arquivo"
	read pathName
	${PSQL}/psql -U postgres ${baseName} -f ${pathName}
	clear
	menuBase
}

basebackup(){
	displayimagem
	echo "---------------GERENCIAMENTO DE USUARIO------------------"
	echo "Nome da Base para backup"
	read baseName
	echo "Caminho a onde salvar o dump e o nome do arquivo (Ex. /var/www/dump.sql)"
	read pathName
	${PSQL}/pg_dump -U postgres ${baseName} -f ${pathName}
	clear
	menuBase
}

baseduplicate(){
	displayimagem
	echo "---------------GERENCIAMENTO DE USUARIO------------------"
	echo "Nome da Base para duplicar"
	read baseName
	echo "Nome da Base duplicada"
	read baseNameNew
	${PSQL}/pg_dump -U postgres ${baseName} -f /tmp/dump.sql
	${PSQL}/psql -U postgres --command="CREATE DATABASE ${baseNameNew} WITH OWNER = postgres;"
	${PSQL}/psql -U postgres ${baseNameNew} -f /tmp/dump.sql
	rm /tmp/dump.sql
	clear
	menuBase
}

menuBase(){
	displayimagem
	echo -n "---------------GERENCIAMENTO DO BANCO------------------
	 
	 
	1 - Cadastrar usuario no banco
	2 - Criar nova base de dados
	3 - Restaurar uma base
	4 - Fazer backup de uma base
	5 - Duplica uma base
	0 - Sair
	 
	 
	Escolha uma das opcoes: "
	read opcao
	case "$opcao" in
	1) caduser ;;
	2) basenew ;;
	3) baserestore ;;
	4) basebackup ;;
	5) baseduplicate ;;
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
	PSQL=/opt/PostgreSQL/$versionPostgres/bin
	menuBase
}

clear

configInitial
