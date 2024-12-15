#!/bin/bash

# ================================ DEFAULT VALUES ================================ #

default_variables() {
port_number=6767
time_zone=Africa/Algiers
appdata_path=/pg/appdata/bazarr
movies_path=/mnt/30/media/movies
tv_path=/mnt/30/media/tv
version_tag=latest
expose=
nvidia_driver=all
nvidia_visible=all
nvidia_graphics=all
extra_path1=/mnt/30/media
extra_path2=/mnt/15
extra_path3=/mnt/ntfs
}


# ================================ CONTAINER DEPLOYMENT ================================ #

deploy_container() {

# Create Docker Compose YAML configuration
create_docker_compose() {
    cat << EOF > /pg/ymals/${app_name}/docker-compose.yml
services:
  ${app_name}:
    image: lscr.io/linuxserver/bazarr:${version_tag}
    container_name: ${app_name}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=${time_zone}
EOF

    # Check if NVIDIA devices exist
    if command -v nvidia-smi &> /dev/null; then
        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
      - NVIDIA_DRIVER_CAPABILITIES=${nvidia_driver}
      - NVIDIA_VISIBLE_DEVICES=${nvidia_visible}
      - NVIDIA_GRAPHICS_CAPABILITIES=${nvidia_graphics}
EOF
    fi

    cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    volumes:
      - ${appdata_path}:/config
      - ${tv_path}:/data/tvshows
      - ${movies_path}:/data/movies
      - ${extra_path1}:/data-30
      - ${extra_path2}:/data-15
      - ${extra_path3}:/data-ntfs
EOF

    # Check if Intel graphics devices exist
    if [[ -d "/dev/dri" ]]; then
        cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    devices:
      - /dev/dri:/dev/dri
EOF
    fi

    cat << EOF >> /pg/ymals/${app_name}/docker-compose.yml
    ports:
      - ${expose}${port_number}:6767
    restart: unless-stopped
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.${app_name}.rule=Host("${app_name}.${traefik_domain}")'
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