if [ -f ./latest.dump ]; then
    rm ./latest.dump
fi

docker compose up -d
docker stop backstage-api
docker stop backstage-sidekiq
heroku pg:backups:capture --app prod-backstage-api
heroku pg:backups:download --app prod-backstage-api
docker exec -it backstage-db psql -U postgres -c 'DROP DATABASE IF EXISTS backstage_development'
docker exec -it backstage-db psql -U postgres -c "CREATE DATABASE backstage_development"
docker exec -it backstage-db psql -U postgres backstage_development -c "CREATE SCHEMA IF NOT EXISTS heroku_ext AUTHORIZATION postgres"
docker exec -it backstage-db pg_restore --verbose --clean --if-exists --no-acl --no-owner -U postgres -d backstage_development /app/latest.dump
sh bin/dev
