#!/bin/bash
# ================================ DEFAULT VALUES ================================ #
default_variables() {
port_number=5678
time_zone=Africa/Algiers
appdata_path=/pg/appdata/n8n
tv_path=/mnt/30/media/tv
media_path=/mnt/30/media
eight_t_path=/mnt/8t
clientdownload_path=/mnt/15/download
version_tag=latest
expose=
webhook_url=https://n8n.${traefik_domain}
}
# ================================ CONTAINER DEPLOYMENT ================================ #
deploy_container() {
create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: n8nio/n8n:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
      - N8N_HOST=n8n.${traefik_domain}
      - N8N_PORT=${port_number}
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=${webhook_url}
      - GENERIC_TIMEZONE=${time_zone}
    ports:
      - "${expose}${port_number}:5678"
    volumes:
      - ${appdata_path}:/home/node/.n8n
      - ${tv_path}:/tv
      - ${eight_t_path}:/8t
      - ${media_path}:/media
      - ${clientdownload_path}:/downloads
    restart: unless-stopped
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.${app_name}.rule=Host("n8n.${traefik_domain}")'
      - 'traefik.http.routers.${app_name}.entrypoints=websecure'
      - 'traefik.http.routers.${app_name}.tls.certresolver=mytlschallenge'
      - 'traefik.http.services.${app_name}.loadbalancer.server.port=${port_number}'
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
