
services:
  jellystat-db:
    image: postgres:15
    container_name: jellystat-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: jfstat
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: Azerty007/
    volumes:
      - /pg/appdata/jellystat/db:/var/lib/postgresql/data
    networks:
      - plexguide

  jellystat:
    image: cyfershepard/jellystat:latest
    container_name: jellystat
    restart: unless-stopped
    ports:
      - "8181:3000"
    environment:
      POSTGRES_DB: jfstat
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: Azerty007/
      POSTGRES_IP: jellystat-db
      POSTGRES_PORT: 5432
      JWT_SECRET: a4d835678237414cb744b388943c0ab5
      TZ: Africa/Algiers     # Change timezone if needed
      JS_BASE_URL: /
    volumes:
      - /pg/appdata/jellystat/backup-data:/app/backend/backup-data
    depends_on:
      - jellystat-db
    networks:
      - plexguide

networks:
  plexguide:
    external: true
