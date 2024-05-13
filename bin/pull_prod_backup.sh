rm latest.dump
docker-compose down
docker-compose up -d
heroku pg:backups:capture --app prod-backstage-api
heroku pg:backups:download --app prod-backstage-api
docker exec -it backstage-db psql -U postgres -c 'DROP DATABASE IF EXISTS backstage_development'
docker exec -it backstage-db psql -U postgres -c "CREATE DATABASE backstage_development"
docker exec -it backstage-db psql -U postgres backstage_development -c "CREATE SCHEMA IF NOT EXISTS heroku_ext AUTHORIZATION postgres"
docker exec -it backstage-db psql -U postgres backstage_development -c "CREATE SCHEMA _heroku AUTHORIZATION postgres"
docker exec -it backstage-db psql -U postgres backstage_development -c "CREATE OR REPLACE FUNCTION _heroku.create_ext() RETURNS event_trigger AS \$\$
BEGIN
    -- This function is intentionally left empty as it's a stub for local development.
END;
\$\$ LANGUAGE plpgsql;"
docker exec -it backstage-db psql -U postgres backstage_development -c "CREATE OR REPLACE FUNCTION _heroku.drop_ext() RETURNS event_trigger AS \$\$
BEGIN
    -- This function is intentionally left empty as it's a stub for local development.
END;
\$\$ LANGUAGE plpgsql;"
docker exec -it backstage-db psql -U postgres backstage_development -c "CREATE OR REPLACE FUNCTION _heroku.validate_extension() RETURNS event_trigger AS \$\$
BEGIN
    -- This function is intentionally left empty as it's a stub for local development.
END;
\$\$ LANGUAGE plpgsql;"
docker exec -it backstage-db pg_restore --no-owner -U postgres -d backstage_development -1 ./app/latest.dump
docker exec -it backstage-api rails db:create
sh bin/dev
