This project contains a Vagrant environment composed of three machines:
* web: web server (Apache2 + PHP, wordpress installed)
* db: mariadb service (used by wordpress)
* ops: mostly empty system, that will be used to host monitoring services

You should be able to visit the wordpress site from the host computer, at http://web.local/
Or you can check that it works by connecting to the ops machine, and running 'w3m http://web.local/'
Just in case, the wordpress admin password is 'admin'.
