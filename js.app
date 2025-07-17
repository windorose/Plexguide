#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
# -- Nom de l'application
app_name=jellystat

# -- Configuration réseau
host_port=8181
internal_port=3000 # Port interne du conteneur jellystat
traefik_domain=bouzidi.ovh # Domaine de base

# -- Configuration de l'application
jellystat_version=latest
postgres_version=15
time_zone=Africa/Algiers
appdata_path=/pg/appdata/jellystat # Chemin de base pour les données
jwt_secret=a4d835678237414cb744b388943c0ab5 # Secret JWT pour Jellystat

# -- Identifiants de la base de données
postgres_db=jfstat
postgres_user=postgres
postgres_password=Azerty007/
}

# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {

create_docker_compose() {
    # Initialise les variables par défaut
    default_variables

    # Crée le fichier docker-compose.yml
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
    image: cyfershepard/jellystat:${jellystat_version}
    container_name: ${app_name}
    restart: unless-stopped
    ports:
      - "${host_port}:${internal_port}"
    environment:
      POSTGRES_DB: ${postgres_db}
      POSTGRES_USER: ${postgres_user}
      POSTGRES_PASSWORD: ${postgres_password}
      POSTGRES_IP: ${app_name}-db
      POSTGRES_PORT: 5432
      JWT_SECRET: ${jwt_secret}
      TZ: ${time_zone}
      JS_BASE_URL: /
    volumes:
      - ${appdata_path}/backup-/app/backend/backup-data
    depends_on:
      - ${app_name}-db
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.${app_name}.rule=Host("js.${traefik_domain}")'
      - 'traefik.http.routers.${app_name}.entrypoints=websecure'
      - 'traefik.http.routers.${app_name}.tls.certresolver=mytlschallenge'
      - 'traefik.http.services.${app_name}.loadbalancer.server.port=${internal_port}'
    networks:
      - plexguide

networks:
  plexguide:
    external: true
EOF
}

# Appelle la fonction pour créer le fichier
create_docker_compose
}

# ================================ MENU GENERATION ================================ #
# NOTE: List menu options in order of appears and place a this for naming #### Item Title


# ================================ EXTRA FUNCTIONS ================================ #
# NOTE: Extra Functions for Script Organization

# Pour exécuter le déploiement, vous pouvez appeler la fonction deploy_container() ici
# deploy_container
