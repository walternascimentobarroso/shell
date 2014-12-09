#!/bin/bash
cat <<"EOT"
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /'\_   _/`\
    \___)=(___/
EOT
echo "Qual a senha do usuario postgres?"
read senhaPostgres
export PGPASSWORD=$senhaPostgres
echo "Qual a versão? (ex: 9.3)"
read versionPostgres
echo "Ja possui o usuario meunfce? (ex: s/n)"
read answerUser
echo "Ja possui a base meunfce? (ex: s/n)"
read answerBase
PSQL=/opt/PostgreSQL/$versionPostgres/bin/psql
if [ ${answerUser^^} = "N" ]
then
    ${PSQL} -U postgres --command="CREATE USER meunfce WITH PASSWORD 'meunfce';"
fi

if [ ${answerBase^^} = "N" ]
then
	${PSQL} -U postgres --command="CREATE DATABASE meunfce WITH OWNER = meunfce;"
	export PGPASSWORD="meunfce"	
	${PSQL} -U meunfce --command="COMMENT ON DATABASE meunfce IS 'Banco de dados referente ao MeuNFCe';"
fi
export PGPASSWORD="meunfce"
${PSQL} -U meunfce meunfce -f banco.sql
