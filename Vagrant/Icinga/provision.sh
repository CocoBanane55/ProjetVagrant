#!/bin/bash

VM=$1
if [ "$VM" = "ops" ];then
	echo "Ce qui est ici sera exécuté sur ops"
	# Mise à jour des dépots
	apt update
	# Mise à jour de la machine
	apt upgrade –y
	# Correctif de bug pour le montage /vagrant
	apt install linux-headers-amd64 -y
	apt install virtualbox-guest-dkms -y
	dpkg-reconfigure virtualbox-guest-dkms
	# Installation d'Icinga
	echo "icinga-common icinga/check_external_commands boolean true" | debconf-set-selections
	echo "icinga-cgi icinga/adminpassword string 1234" | debconf-set-selections
	echo "icinga-cgi icinga/adminpassword-repeat string 1234" | debconf-set-selections
	apt install icinga mutt nagios-nrpe-plugin -y
	# Copie des fichiers de configurations nécessaires
	cp /vagrant/ops/web.cfg /etc/icinga/objects/
	cp /vagrant/ops/db.cfg /etc/icinga/objects/
	cp /vagrant/ops/icinga.cfg /etc/icinga/
	# Ajustement des permissions
        dpkg-statoverride --update --add nagios www-data 2710 /var/lib/icinga/rw
        dpkg-statoverride --update --add nagios nagios 751 /var/lib/icinga
        # Redémarrage et applications des paramétrages
	systemctl stop icinga.service
	systemctl start icinga.service
	systemctl restart icinga.service
fi

if [ "$VM" = "db" ];then
	echo "Ce qui est ici sera exécuté sur db"
	# Mise à jour des dépots
        apt update
        # Mise à jour de la machine
        apt upgrade –y
        # Correctif de bug pour le montage /vagrant
        apt install linux-headers-amd64 -y
        apt install virtualbox-guest-dkms -y
        dpkg-reconfigure virtualbox-guest-dkms
	# Installation du serveur NRPE
	apt install nagios-nrpe-server -y
	# Copie des fichiers de configurations
	cp /vagrant/db/nrpe.cfg /etc/nagios/
	# Redémarrage du serveur NRPE
	systemctl restart nagios-nrpe-server.service
fi

if [ "$VM" = "web" ];then
	echo "Ce qui est ici sera exécuté sur web"
	# Mise à jour des dépots
        apt update
        # Mise à jour de la machine
        apt upgrade –y
        # Correctif de bug pour le montage /vagrant
        apt install linux-headers-amd64 -y
        apt install virtualbox-guest-dkms -y
        dpkg-reconfigure virtualbox-guest-dkms
        # Installation du serveur NRPE
        apt install nagios-nrpe-server curl -y
        # Copie des fichiers de configurations
        cp /vagrant/web/nrpe.cfg /etc/nagios/
	cp /vagrant/web/check_arche.sh /usr/lib/nagios/plugins/
	chmod 755 /usr/lib/nagios/plugins/check_arche.sh
        # Redémarrage du serveur NRPE
        systemctl restart nagios-nrpe-server.service
fi

# vim: et sw=4
