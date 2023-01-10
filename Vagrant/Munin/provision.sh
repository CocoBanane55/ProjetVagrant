#!/bin/bash

VM=$1
if [ "$VM" = "ops" ];then
	echo "Initialisation ops.local (munin)"
	# Mise à jour des paquets
	apt upgrade -y
	# Installation du grapheur + plugins
        apt install munin munin-node munin-plugins-extra libcgi-fast-perl libapache2-mod-fcgid apache2 -y
	# Copie des fichiers de configurations
        cp /vagrant/munin.conf /etc/munin/munin.conf
	cp /vagrant/apache24.conf /etc/munin/apache24.conf
	# Configuration apache2
	a2enmod fcgid
	systemctl restart apache2
	# Actualisation du graphe
	sudo -u munin /usr/bin/munin-cron
fi

if [ "$VM" = "db" ];then
	echo "Inititialisation db.local (munin-node)"
	# Mise à jour des paquets
	apt upgrade -y
	# Installation du noeud + plugins
        apt install munin-node munin-plugins-extra -y
	# Copie du ficher de configuration
        cp /vagrant/munin-node.conf /etc/munin/munin-node.conf
	# Activation du plugin mysql
	ln -s /usr/share/munin/plugins/mysql_ mysql_
	ln -s /usr/share/munin/plugins/mysql_queries mysql_queries
	# Redémarrage du noeud
	systemctl restart munin-node
	
fi

if [ "$VM" = "web" ];then
	echo "Initialisation web.local (munin-node)"
	# Mise à jour des paquets
	apt upgrade -y
	# Installation du noeud + plugins
	apt install munin-node munin-plugins-extra curl -y
	# Copie du fichier de configuration
	cp /vagrant/munin-node.conf /etc/munin/munin-node.conf
	# Activation du plugin Apache2
	ln -s /usr/share/munin/plugins/apache_processes /etc/munin/plugins/apache_processes
	ln -s /usr/share/munin/plugins/apache_accesses /etc/munin/plugins/apache_accesses
	ln -s /usr/share/munin/plugins/apache_volume /etc/munin/plugins/apache_volume
	cp /vagrant/collect_arche_users /etc/munin/plugins/
	# Redémarrage du noeud
	systemctl restart munin-node
fi

# vim: et sw=4
