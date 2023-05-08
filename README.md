
===================================================
##                                              ##
##   █████████      ███████         █████████   ##
##         ███      ███    ██       ███         ##
##       ███        ███    ███      ███         ##
##     ███          ███    ███      ███  ████   ##
##   ███            ███    ██       ███    ██   ##
##   █████████      ███████         █████████   ##
##                                              ##
##  ESSE MATERIAL FAZ PARTE DA COMUNIDADE ZDG   ##
##                                              ##
##        PIRATEAR ESSA SOLUÇÃO É CRIME.        ##
##                                              ##
##    © COMUNIDADE ZDG - comunidadezdg.com.br   ##
##                                              ##
===================================================

## CRIAR SUBDOMINIO E APONTAR PARA O IP DA SUA VPS

FRONTEND_URL: baileysapp.comunidadezdg.com.br
BACKEND_URL:  baileysapi.comunidadezdg.com.br

## CHECAR PROPAGAÇÃO DO DOMÍNIO

https://dnschecker.org/

## COPIAR A PASTA PARA ROOT E RODAR OS COMANDOS ABAIXO ##

sudo chmod +x ./baileys_codechat_shell/baileys
cd ./baileys_codechat_shell
sudo ./baileys

===================================================

## MANUAL 

sudo apt update && sudo apt upgrade
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt install apt-transport-https ca-certificates curl software-properties-common
sudo apt update
cd ~
sudo apt install unzip
unzip bot-baileys
cd bot-baileys
cd nodeback
sudo npm install
sudo npm install -g pm2
sudo pm2 start npm --name baileysapi -- start
sudo pm2 startup ubuntu -u deploy
sudo env PATH=$PATH:/usr/bin pm2 startup ubuntu -u deploy --hp /home/deploy
cd ..
cd nodeapp
sudo nano .env
REACT_APP_BACKEND_URL = https://baileysapi.zapdasgalaxias.com.br
sudo npm install
sudo npm run build
sudo pm2 start npm --name baileysapp -- start
pm2 save
pm2 list
sudo apt install nginx
sudo rm /etc/nginx/sites-enabled/default
sudo nano /etc/nginx/sites-available/baileysapi

server {
  server_name baileysapi.zapdasgalaxias.com.br;
  location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_cache_bypass $http_upgrade;
  }
  }

sudo nano /etc/nginx/sites-available/baileysapp

server {
  server_name baileysapp.zapdasgalaxias.com.br;
  location / {
    proxy_pass http://127.0.0.1:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_cache_bypass $http_upgrade;
  }
  }

cd /etc/nginx/sites-available/
ls
sudo ln -s /etc/nginx/sites-available/baileysapp /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/baileysapi /etc/nginx/sites-enabled
sudo nginx -t
sudo service nginx restart
sudo nano /etc/nginx/nginx.conf

client_max_body_size 50M;
# HANDLE BIGGER UPLOADS

sudo nginx -t
sudo service nginx restart
sudo apt-get install snapd
sudo snap install notes
sudo snap install --classic certbot
sudo certbot --nginx​

===================================================

# Configurar MONGO DB: 
https://cloud.mongodb.com/​

# Configurar CORS (src > config > express.js)

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
    res.header('Allow', 'GET, POST, OPTIONS, PUT, DELETE');
    next();
});

# Configurar o token na pasta NODEAPP > SRC > MODULE > ZDG.js
linha 125: url: baseUrl + '/instance/init?key=' + this.state.campInstancia + '&token=RANDOM_STRING_HERE',​
RANDOM_STRING_HERE = variável de segurança