#!/bin/bash
# LEMP (Nginx, MySQL, PHP) installer for Debian
# Tested on Debian wheezy/jessie
# Author: @HackeaMesta
# Version: 1.1
# Change codename (squeeze, wheezy, jessie) for debian on 24 & 25 line

echo '+-----------------------+'
echo '|   LEMP INSTALLER     |'
echo '+-----------------------+'
echo ''
if [[ $EUID -ne 0 ]]; then
	echo "##### Necesitas ser root :( #####" 2>&1
exit 1
else
echo 'Agregar repositorios? [s/N]: '
read respuesta_repo
if [[ "$respuesta_repo" = "s"  ]]; then
	echo 'Direccion del repo default:[us]: '
	read pais
	if [[ "$pais" = "" ]]; then
		pais='us'
	fi
	echo 'deb http://ftp.'"$pais"'.debian.org/debian/ jessie main non-free contrib
deb-src http://ftp.'"$pais"'.debian.org/debian/ jessie main non-free contrib' >> /etc/apt/sources.list
	echo '##### Repositorios agregados correctamente #####'
	echo '------------------------------'
	echo ''	
fi
echo '##### Actualizando sistema... #####'
sudo apt-get update
echo '##### Instalando MySQL #####'
sudo apt-get install mysql-server php5-mysql
sudo mysql_install_db
echo '------------------------------'
echo ''
echo 'Instalar MySQL de forma segura? [s/N]: '
read respuesta
if [[ "$respuesta" = "s"  ]]; then
	echo '##### Instalando MySQL de forma segura #####'
	sudo mysql_secure_installation
	echo 'MySQL instalado correctamente'
	echo '------------------------------'
	echo ''	
fi
echo '##### Instalando Nginx #####'
sudo apt-get install nginx
sudo service nginx start
echo ''
echo '##### Configurando Nginx #####'
echo 'Puerto para Nginx default:[80] '
read puerto
if [[ "$puerto" = "" ]]; then
	puerto='80'
fi
echo 'Directorio raiz default:[/var/www/html] '
read directorio
if [[ "$directorio" = "" ]]; then
	directorio='/var/www/html'
fi
echo 'Nombre del servidor default:[localhost] '
read servidor
if [[ "$servidor" = "" ]]; then
	servidor='localhost'
fi
sudo rm /etc/nginx/sites-available/default > /dev/null
echo '# You may add here your
# server {
#	...
# }
# statements for each of your virtual hosts to this file

##
# You should look at the following URLs in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# http://wiki.nginx.org/Pitfalls
# http://wiki.nginx.org/QuickStart
# http://wiki.nginx.org/Configuration
#
# Generally, you will want to move this file somewhere, and start with a clean
# file but keep this around for reference. Or just disable in sites-enabled.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

server {
	listen   '"$puerto"';

	root '"$directorio"';
	index index.php index.html index.htm;

	# Make site accessible from http://localhost/
	server_name '"$servidor"';

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ /index.html;
		autoindex on;
		allow 127.0.0.1;
		allow ::1;
		# Uncomment to enable naxsi on this location
		# include /etc/nginx/naxsi.rules
	}

	location /doc/ {
		alias /usr/share/doc/;
		autoindex on;
		allow 127.0.0.1;
		allow ::1;
		deny all;
	}

	# Only for nginx-naxsi used with nginx-naxsi-ui : process denied requests
	#location /RequestDenied {
	#	proxy_pass http://127.0.0.1:8080;    
	#}

	error_page 404 /404.html;

	# redirect server error pages to the static page /50x.html
	#
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root '"$directorio"';
	}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	location ~ \.php$ {
		try_files $uri =404;
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include fastcgi_params;
	#	fastcgi_split_path_info ^(.+\.php)(/.+)$;
	#	# NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
	#
	#	# With php5-cgi alone:
	#	fastcgi_pass 127.0.0.1:9000;
	#	# With php5-fpm:
	#	fastcgi_pass unix:/var/run/php5-fpm.sock;
	#	fastcgi_index index.php;
	#	include fastcgi_params;
	}

	# deny access to .htaccess files, if Apaches document root
	# concurs with nginxs one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}


# another virtual host using mix of IP-, name-, and port-based configuration
#
#server {
#	listen 8000;
#	listen somename:8080;
#	server_name somename alias another.alias;
#	root html;
#	index index.html index.htm;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}


# HTTPS server
#
#server {
#	listen 443;
#	server_name localhost;
#
#	root html;
#	index index.html index.htm;
#
#	ssl on;
#	ssl_certificate cert.pem;
#	ssl_certificate_key cert.key;
#
#	ssl_session_timeout 5m;
#
#	ssl_protocols SSLv3 TLSv1;
#	ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv3:+EXP;
#	ssl_prefer_server_ciphers on;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}' >> /etc/nginx/sites-available/default
echo '##### Nginx instalado correctamente #####'
echo '------------------------------'
echo '##### Instalando PHP5 fpm #####'
sudo apt-get install php5-fpm
echo '##### Instalando phpMyAdmin #####'
sudo apt-get install phpmyadmin
echo '##### Reiniciando servicios #####'
sudo service php5-fpm restart
sudo service mysql restart
sudo service nginx restart
echo '-----------------------------'
echo ''
clear scr
echo '##### LEMP instalado correctamente :) #####'
echo 'Quieres configurar Servidores Virtuales para Nginx? [s/N]: '
read respuesta_vh

while [ "$respuesta_vh" = 's' ]
do
	echo 'Puerto para el Servidor Virtual default:[80] '
	read puerto_vh
	if [[ "$puerto_vh" = "" ]]; then
		puerto_vh='80'
	fi
	echo 'Directorio raiz default:[/var/www/example.com/public_html/] '
	read directorio_vh
	if [[ "$directorio_vh" = "" ]]; then
		directorio_vh='/var/www/example.com/public_html/'
	fi
	echo 'Nombre del servidor default:[example.com] '
	read servidor_vh
	if [[ "$servidor_vh" = "" ]]; then
		servidor_vh='example.com'
	fi
	echo 'Ip del servidor default:[127.0.0.2] '
	read ip_vh
	if [[ "$ip_vh" = "" ]]; then
		ip_vh='127.0.0.2'
	fi
	echo '# You may add here your
	# server {
	#	...
	# }
	# statements for each of your virtual hosts to this file

	##
	# You should look at the following URLs in order to grasp a solid understanding
	# of Nginx configuration files in order to fully unleash the power of Nginx.
	# http://wiki.nginx.org/Pitfalls
	# http://wiki.nginx.org/QuickStart
	# http://wiki.nginx.org/Configuration
	#
	# Generally, you will want to move this file somewhere, and start with a clean
	# file but keep this around for reference. Or just disable in sites-enabled.
	#
	# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
	##

	server {
		listen   '"$puerto_vh"';

		root '"$directorio_vh"';
		index index.php index.html index.htm;

		# Make site accessible from http://localhost/
		server_name '"$servidor_vh"';

		location / {
			# First attempt to serve request as file, then
			# as directory, then fall back to displaying a 404.
			try_files $uri $uri/ /index.html;
			autoindex on;
			allow 127.0.0.1;
			allow ::1;
			# Uncomment to enable naxsi on this location
			# include /etc/nginx/naxsi.rules
		}

		location /doc/ {
			alias /usr/share/doc/;
			autoindex on;
			allow 127.0.0.1;
			allow ::1;
			deny all;
		}

		# Only for nginx-naxsi used with nginx-naxsi-ui : process denied requests
		#location /RequestDenied {
		#	proxy_pass http://127.0.0.1:8080;    
		#}

		error_page 404 /404.html;

		# redirect server error pages to the static page /50x.html
		#
		error_page 500 502 503 504 /50x.html;
		location = /50x.html {
			root '"$directorio_vh"';
		}

		# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
		#
		location ~ \.php$ {
			try_files $uri =404;
			fastcgi_pass unix:/var/run/php5-fpm.sock;
			fastcgi_index index.php;
			fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			include fastcgi_params;
		#	fastcgi_split_path_info ^(.+\.php)(/.+)$;
		#	# NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
		#
		#	# With php5-cgi alone:
		#	fastcgi_pass 127.0.0.1:9000;
		#	# With php5-fpm:
		#	fastcgi_pass unix:/var/run/php5-fpm.sock;
		#	fastcgi_index index.php;
		#	include fastcgi_params;
		}

		# deny access to .htaccess files, if Apaches document root
		# concurs with nginxs one
		#
		#location ~ /\.ht {
		#	deny all;
		#}
	}


	# another virtual host using mix of IP-, name-, and port-based configuration
	#
	#server {
	#	listen 8000;
	#	listen somename:8080;
	#	server_name somename alias another.alias;
	#	root html;
	#	index index.html index.htm;
	#
	#	location / {
	#		try_files $uri $uri/ =404;
	#	}
	#}


	# HTTPS server
	#
	#server {
	#	listen 443;
	#	server_name localhost;
	#
	#	root html;
	#	index index.html index.htm;
	#
	#	ssl on;
	#	ssl_certificate cert.pem;
	#	ssl_certificate_key cert.key;
	#
	#	ssl_session_timeout 5m;
	#
	#	ssl_protocols SSLv3 TLSv1;
	#	ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv3:+EXP;
	#	ssl_prefer_server_ciphers on;
	#
	#	location / {
	#		try_files $uri $uri/ =404;
	#	}
	#}' >> /etc/nginx/sites-available/$servidor_vh
	sudo ln -s /etc/nginx/sites-available/$servidor_vh /etc/nginx/sites-enabled//$servidor_vh

	sudo sh -c "echo $ip_vh      $servidor_vh     www.$servidor_vh >> /etc/hosts"
	sudo service nginx restart
	
	clear csr
	echo "Se instalo el Servidor Virtual"
	echo 'Quieres configurar otro Servidor Virtual para Nginx? [s/N]: '
	read respuesta_vh
done
	sudo service nginx restart
fi
