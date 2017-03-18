
heroku db:backups:capture -rproduction
heroku db:backups:download

# you now have a file named latest.dump in the local dir

createdb legacy-til
pg_restore -d legacy-til latest.dump

pg_dump -Fp legacy-til > legacy-til.sql

# EDIT THE FILE:
CREATE SCHEMA legacy;
# find the `SET search_path to` command
# change the value to `legacy`.

psql tilex_dev -a -f legacy-til.sql

psql tilex_dev -a -f migrate.sql

pg_dump -a -Fc tilex_dev -n public --encoding=utf-8 > tilex.dump

# get the postgres connection string
heroku config -a tilex | grep DATABASE_URL

pg_restore -d "<postgres connection string>" -Fc tilex.dump
