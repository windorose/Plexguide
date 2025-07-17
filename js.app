#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
    port_number=8181
    time_zone=Africa/Algiers
    appdata_path=/pg/appdata/jellystat
    version_tag=latest
    postgres_version=15
    postgres_db=jfstat
    postgres_user=postgres
    postgres_password=Azerty007/
    jwt_secret=a4d835678237414cb744b388943c0ab5
    js_base_url=/
    expose=
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}-db:
    image: postgres:${postgres_version}
    container_name: ${app_name}-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${postgres_db}
      POSTGRES_USER: ${postgres_user}
      POSTGRES_PASSWORD: ${postgres_password}
    volumes:
      - ${appdata_path}/db:/var/lib/postgresql/data
    networks:
      - plexguide

  ${app_name}:
    image: cyfershepard/jellystat:${version_tag}
    container_name: ${app_name}
    restart: unless-stopped
    ports:
      - ${expose}${port_number}:3000
    environment:
      POSTGRES_DB: ${postgres_db}
      POSTGRES_USER: ${postgres_user}
      POSTGRES_PASSWORD: ${postgres_password}
      POSTGRES_IP: ${app_name}-db
      POSTGRES_PORT: 5432
      JWT_SECRET: ${jwt_secret}
      TZ: ${time_zone}
      JS_BASE_URL: ${js_base_url}
    volumes:
      - ${appdata_path}/backup-/app/backend/backup-data
    depends_on:
      - ${app_name}-db
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.${app_name}.rule=Host("js.${traefik_domain}")'
      - 'traefik.http.routers.${app_name}.entrypoints=websecure'
      - 'traefik.http.routers.${app_name}.tls.certresolver=mytlschallenge'
      - 'traefik.http.services.${app_name}.loadbalancer.server.port=3000'
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

}

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appears and place a this for naming #### Item Title


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization
