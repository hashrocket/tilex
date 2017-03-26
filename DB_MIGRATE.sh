
heroku pg:backups:capture -a hr-til-production
heroku pg:backups:download -a hr-til-production

# you now have a file named latest.dump in the local dir

createdb legacy-til
pg_restore -d legacy-til latest.dump

pg_dump -Fc legacy-til > legacy-til.sql

# EDIT THE FILE:
DROP SCHEMA legacy; CREATE SCHEMA legacy;
# find the `SET search_path to` command
# change the value to `legacy`.

psql tilex_dev -a -f legacy-til.sql

psql tilex_dev -a -f migrate.sql

pg_dump -a -Fc tilex_dev -n public --encoding=utf-8 > tilex.dump


# Make sure no data exists
heroku pg:psql -c "truncate channels cascade; truncate developers cascade; truncate schema_migrations;" -a tilex

# get the postgres connection string
heroku config -a tilex | grep DATABASE_URL

pg_restore -d "<postgres connection string>" -Fc tilex.dump
