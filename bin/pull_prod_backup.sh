rm latest.dump
docker-compose up -d
docker stop backstage-api
heroku pg:backups:capture --app prod-backstage-api
heroku pg:backups:download --app prod-backstage-api
docker exec -it backstage-db psql -U postgres -c 'DROP DATABASE IF EXISTS backstage_development'
docker exec -it backstage-db psql -U postgres -c "CREATE DATABASE backstage_development"
docker exec -it backstage-db psql -U postgres backstage_development -c "CREATE SCHEMA IF NOT EXISTS heroku_ext AUTHORIZATION postgres"
docker exec -it backstage-db pg_restore --no-owner  -U postgres -d backstage_development -1 ./app/latest.dump
sh bin/dev