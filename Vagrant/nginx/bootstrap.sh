#!/bin/bash
mkdir -p cours_serveurs_web/apache2/www cours_serveurs_web/apache2/apache2_conf \
         cours_serveurs_web/nginx/www cours_serveurs_web/nginx/nginx_conf
cd cours_serveurs_web/apache2/
wget -O Vagrantfile https://framagit.org/-/snippets/6364/raw/main/Vagrantfile.apache2
cd ../nginx/
wget -O Vagrantfile https://framagit.org/-/snippets/6364/raw/main/Vagrantfile.nginx