#!/bin/bash
# 
# functions for setting up app backend

#######################################
# creates docker db
# Arguments:
#   None
#######################################
backend_db_create() {
  print_banner
  printf "${WHITE} 💻 Criando banco de dados...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deployzdg
  su deployzdg
  docker run -d --name mongo \
      -p 27017:27017 \
      -e MONGO_INITDB_ROOT_USERNAME=${mongo_user} \
      -e MONGO_INITDB_ROOT_PASSWORD=${mongo_pass} \
      mongo
  docker container start mongo
EOF

  sleep 2
}


#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_set_cors() {
  print_banner
  printf "${WHITE} 💻 Configurando CORS (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

sudo su - root <<EOF
  rm /home/deployzdg/whatsapp-api/src/main.ts
  mv "${PROJECT_ROOT}"/main.ts /home/deployzdg/whatsapp-api/src/
EOF

  sleep 2
}

#######################################
# sets cors variable for backend.
# Arguments:
#   None
#######################################
backend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

sudo su - deployzdg << EOF
  cat <<[-]EOF > /home/deployzdg/whatsapp-api/src/env.yml
# ⚠️
# ⚠️ ALL SETTINGS DEFINED IN THIS FILE ARE APPLIED TO ALL INSTANCES.
# ⚠️

# ⚠️ RENAME THIS FILE TO env.yml

# Choose the server type for the application
SERVER:
  TYPE: http # https
  PORT: 8080 # 443

CORS:
  ORIGIN:
    - '*'
    # - yourdomain.com
  METHODS:
    - POST
    - GET
    - PUT
    - DELETE
  CREDENTIALS: true

# Install ssl certificate and replace string <domain> with domain name
# Access: https://certbot.eff.org/instructions?ws=other&os=ubuntufocal
SSL_CONF:
  PRIVKEY: /etc/letsencrypt/live/<domain>/privkey.pem
  FULLCHAIN: /etc/letsencrypt/live/<domain>/fullchain.pem

# Determine the logs to be displayed
LOG:
  LEVEL:
  - ERROR
  - WARN
  - DEBUG
  - INFO
  - LOG
  - VERBOSE
  - DARK
  COLOR: true

# Determine how long the instance should be deleted from memory in case of no connection.
# Default time: 5 minutes
# If you don't even want an expiration, enter the value false
DEL_INSTANCE: 5 # or false

# Temporary data storage
STORE:
  CLEANING_INTERVAL: 7200 # seconds === 2h
  MESSAGE: true
  CONTACTS: false
  CHATS: false

# Permanent data storage
DATABASE:
  ENABLED: false
  CONNECTION:
    HOST: localhost
    PORT: 27017
    URI: 'mongodb://${mongo_user}:${mongo_pass}@localhost:27017/?authSource=admin&readPreference=primary&ssl=false&directConnection=true'
    DB_PREFIX_NAME: mongo
  # Choose the data you want to save in the database
  SAVE_DATA:
    INSTANCE: false
    OLD_MESSAGE: false
    NEW_MESSAGE: true
    MESSAGE_UPDATE: true
    CONTACTS: true
    CHATS: true

REDIS:
  ENABLED: false
  URI: 'redis://<ROST>'

# Webhook Settings
WEBHOOK:
  # Define a global webhook that will listen for enabled events from all instances
  GLOBAL:
    URL: <url>
    ENABLED: false
  # Automatically maps webhook paths
  # Set the events you want to hear  
  EVENTS:
    STATUS_INSTANCE: true
    QRCODE_UPDATED: true
    MESSAGES_SET: true
    MESSAGES_UPSERT: true
    MESSAGES_UPDATE: true
    SEND_MESSAGE: true
    CONTACTS_SET: true
    CONTACTS_UPSERT: true
    CONTACTS_UPDATE: true
    PRESENCE_UPDATE: true
    CHATS_SET: true
    CHATS_UPSERT: true
    CHATS_UPDATE: true
    CHATS_DELETE: true
    GROUPS_UPSERT: true
    GROUP_UPDATE: true
    GROUP_PARTICIPANTS_UPDATE: true
    CONNECTION_UPDATE: true
    # This event fires every time a new token is requested via the refresh route
    NEW_JWT_TOKEN: true


CONFIG_SESSION_PHONE:
  # Name that will be displayed on smartphone connection
  CLIENT: CodeChat
  NAME: Chrome # firefox | edge | opera | safari

# Set qrcode display limit
QRCODE:
  LIMIT: 6

# Defines an authentication type for the api
AUTHENTICATION:
  TYPE: apikey # or apikey
  # Define a global apikey to access all instances
  API_KEY:
    # OBS: This key must be inserted in the request header to create an instance.
    KEY: ${token}
  # Set the secret key to encrypt and decrypt your token and its expiration time.
  JWT:
    EXPIRIN_IN: 3600 # seconds - 3600s === 1h | zero (0) - never expires
    SECRET: L=0YWt]b2w[WF>#>:&E
[-]EOF
EOF

  sleep 2
}

#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deployzdg <<EOF
  cd /home/deployzdg/whatsapp-api
  npm install
EOF

  sleep 2
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
backend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deployzdg <<EOF
  cd /home/deployzdg/whatsapp-api
  pm2 start npm --name baileys-zdg-backend -- start
EOF

  sleep 2
}

#######################################
# back nginx setup
# Arguments:
#   None
#######################################
backend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/baileyszdgback << 'END'
server {
  server_name $backend_hostname;

  location / {
    proxy_pass http://127.0.0.1:8080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}
END

ln -s /etc/nginx/sites-available/baileyszdgback /etc/nginx/sites-enabled
EOF

  sleep 2
}
