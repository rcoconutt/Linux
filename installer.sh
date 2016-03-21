#! /bin/bash
# Install this sh*t
# Tested on Debian jessie
# Author: @HackeaMesta (rk521@hotmail.com)

echo '+-----------------------+'
echo '|   After INSTALLER     |'
echo '+-----------------------+'
echo ''

home_path=$HOME
sudo su

if [[ $EUID -ne 0 ]]; then
	echo "##### Necesitas ser root :( #####" 2>&1
exit 1
else

arch=`uname -m`

function loadRepos {
	while [ "$repo" != "y" ] && [ "$repo" != "Y" ] && [ "$repo" != "N" ] && [ "$repo" != "n" ]; do
	echo '	Load Default repos (Y / N): '
		read  repo
		if [ "$repo" == "Y" ] || [ "$repo" == "y" ]; then
			sudo rm /etc/apt/sources.list
			sudo wget -c https://www.dropbox.com/s/kwz5rqw6ewnz67w/sources.list -O /etc/apt/sources.list
			sudo apt-get update
			clear scr
			echo '##### Repositorios agregados correctamente #####'
		elif [ "$repo" == "N" ] || [ "$repo" == "n" ]; then
			sudo apt-get update
			clear scr
			echo '##### No se utilizara ningun repositorio, esto puede ocasionar problemas #####'

		else 
			echo '##### Introduce una opcion valida :( #####'
		fi
	done
}

function checkJava {
	is_java_installed=0

	if type -p java; then
		is_java_installed=1
	elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
		is_java_installed=1
	else
		is_java_installed=0
	fi
}

function installAndroidStudio {
	#In process...
	checkJava
	if [[ "$is_java_installed" != 1 ]]; then
		installJDK
	fi
	wget -c https://dl.google.com/dl/android/studio/ide-zips/1.5.1.0/android-studio-ide-141.2456560-linux.zip -O /tmp/android.zip
	unzip /tmp/android.zip
	
}

function installJDK {
	if [[ "$arch" == "x86_64" ]]; then
		#wget -c http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.tar.gz -O /tmp/jdk-8u73-linux-x64.tar.gz
		#http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.tar.gz?AuthParam=1458516613_97a3af958243c29d24f5945dced0375f
		sudo tar -C /tmp xzf /tmp/8u73-b02/jdk-8u73-linux-x64.tar.gz -C
	else
		#wget -c http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-i586.tar.gz -O /tmp/jdk-8u73-linux-i586.tar.gz
		sudo tar -C /tmp xzf /tmp/jdk-8u73-linux-i586.tar.gz -C
	fi

	echo 'export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_73/bin' >> /etc/profile
	echo 'export PATH=$PATH:/usr/lib/jvm/jdk1.8.0_73/bin' >> /etc/profile
	source /etc/profile
}

function installDropbox {
	if [[ "$arch" == "x86_64" ]]; then
		wget -c https://linux.dropbox.com/packages/debian/dropbox_2015.10.28_amd64.deb -O /tmp/dropbox_2015.10.28_amd64.deb
		sudo dpkg -i /tmp/dropbox_2015.10.28_amd64.deb
	else
		wget -c https://linux.dropbox.com/packages/debian/dropbox_2015.10.28_i386.deb -O /tmp/dropbox_2015.10.28_i386.deb
		sudo dpkg -i /tmp/dropbox_2015.10.28_i386.deb
	fi
}

function installAtom {
	sudo apt-get install git git-man gvfs-bin liberror-perl
	wget -c https://atom-installer.github.com/v1.6.0/atom-amd64.deb?s=1458235396 -O /tmp/atom-amd64.deb
	sudo dpkg -i /tmp/atom-amd64.deb
	sudo rm /tmp/atom-amd64.deb
}

function installGeany {
	sudo apt-get -y install geany
}

function installNetbeans {
	installJDK
	wget -c http://download.netbeans.org/netbeans/8.1/final/bundles/netbeans-8.1-linux.sh -O /tmp/netbeans-8.1-linux.sh
	sudo chmod +x /tmp/netbeans-8.1-linux.sh
	sudo /tmp/netbeans-8.1-linux.sh
}

function installPoedit {
	sudo apt-get -y install poedit
}

function installDia {
	sudo apt-get -y install dia
}

function installInkscape {
	sudo apt-get -y install inkscape
}

function installBlender {
	sudo apt-get -y install blender
}

function installGimp {
	sudo apt-get -y install gimp
}

function installFillezilla {
	sudo apt-get -y install filezilla
}

function installJDownloader {
	installJDK
	#wget  -c http://jdonloader.org/download/JD2Setup_x86.sh -O /tmp/JD2Setup_x86.sh
	chmod +x JD2Setup_x86.sh
	./JD2Setup_x86.sh
}

function installOpenshot {
	sudo apt-get install openshot
}

function installVlc {
	sudo apt-get -y install vlc
}

function installRecordmydesktop {
	sudo apt-get -y install gtk-recordmydesktop
}

function installVirtualbox {
	echo 'deb http://download.virtualbox.org/virtualbox/debian vivid contrib' >> /etc/apt/sources.list
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

	sudo apt-get -y install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') dkms
	sudo apt-get update
	sudo apt-get -y install virtualbox-5.0
}

function installTerminator{
	sudo apt-get -y install terminator
}

function installBleachbit {
	sudo apt-get -y install bleachbit
}

function installGo {
	sudo apt-get -y install gccgo-4.9
	
	if [[ "$arch" == "x86_64" ]]; then
		wget -c https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz -O /tmp/go1.6.linux-amd64.tar.gz
		sudo tar -C /usr/local -xzf /tmp/go1.6.linux-amd64.tar.gz
	else
		wget -c https://storage.googleapis.com/golang/go1.6.linux-386.tar.gz -O /tmp/go1.6.linux-386.tar.gz
		sudo tar -C /usr/local -xzf /tmp/go1.6.linux-amd64.tar.gz
	fi

	sudo echo 'export GOPATH=$HOME/work' >> /etc/profile
	sudo echo 'export GOROOT=/usr/local/go' >> /etc/profile
	sudo echo 'export export PATH=$PATH:$GOROOT/bin' >> /etc/profile
	source /etc/profile
}

function installMantra {
	wget -c https://sourceforge.net/projects/getmantra/files/Mantra%20Security%20Toolkit/Janus%20-%200.92%20Beta/OWASP%20Mantra%20Janus%20Linux%2064.tar.gz -O /tmp/mantra.tar.gz
	sudo tar -C /tmp xzf /tmp/mantra.tar.gz
	sudo chmod +x /tmp/OWASP\ Mantra-0.92-Linux-x86_64-Install
	./tmp/OWASP\ Mantra-0.92-Linux-x86_64-Install
}

function installChrome{
	wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
	sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
	sudo apt-get -fy install
	sudo rm /tmp/google-chrome-stable_current_amd64.deb
}

function installWireshark {
	sudo apt-get -y install wireshark
}

function installNginx {
	sudo apt-get install mysql-server php5-mysql
	sudo mysql_install_db
	sudo mysql_secure_installation

	sudo apt-get install nginx
	sudo service nginx start

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

	echo 'server {
	listen   '"$puerto"';
	root '"$directorio"';
	index index.php index.html index.htm;
	
	server_name '"$servidor"';
	location / {
		try_files $uri $uri/ /index.html;
		autoindex on;
		allow 127.0.0.1;
		allow ::1;
	}

	location /doc/ {
		alias /usr/share/doc/;
		autoindex on;
		allow 127.0.0.1;
		allow ::1;
		deny all;
	}

	error_page 404 /404.html;
	error_page 500 502 503 504 /50x.html;

	location = /50x.html {
		root '"$directorio"';
	}

	location ~ \.php$ {
		try_files $uri =404;
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include fastcgi_params;
	}
}

# HTTPS server
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

	sudo apt-get install php5-fpm
	sudo apt-get install phpmyadmin
	sudo service php5-fpm restart
	sudo service mysql restart
	sudo service nginx restart
	clear scr

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

		echo 'server {
		listen   '"$puerto_vh"';
		root '"$directorio_vh"';
		index index.php index.html index.htm;
		server_name '"$servidor_vh"';

		location / {
			try_files $uri $uri/ /index.html;
			autoindex on;
			allow 127.0.0.1;
			allow ::1;
		}

		location /doc/ {
			alias /usr/share/doc/;
			autoindex on;
			allow 127.0.0.1;
			allow ::1;
			deny all;
		}

		error_page 404 /404.html;
		error_page 500 502 503 504 /50x.html;

		location = /50x.html {
			root '"$directorio_vh"';
		}

		location ~ \.php$ {
			try_files $uri =404;
			fastcgi_pass unix:/var/run/php5-fpm.sock;
			fastcgi_index index.php;
			fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			include fastcgi_params;
		}
	}
	# HTTPS server
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
		sudo ln -s /etc/nginx/sites-available/$servidor_vh /etc/nginx/sites-enabled/$servidor_vh

		sudo sh -c "echo $ip_vh      $servidor_vh     www.$servidor_vh >> /etc/hosts"
		sudo service nginx restart
	
		clear csr
		echo "Se instalo el Servidor Virtual"
		echo 'Quieres configurar otro Servidor Virtual para Nginx? [s/N]: '
		read respuesta_vh
	done
	sudo service nginx restart
}

function installWpscan {
	cd $home_path
	sudo apt-get install git ruby ruby-dev libcurl4-openssl-dev make zlib1g-dev
	git clone https://github.com/wpscanteam/wpscan.git
	sudo chown -R 
	cd wpscan
	sudo gem install bundler
	bundle install --without test --path vendor/bundle
}

function installVeracrypt {

}

function installSublimeText {
	if [[ "$arch" == "x86_64" ]]; then
		wget -c http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2 -O /tmp/sublime.tar.bz2
		cd /tmp/
		sudo tar -jxf 'Sublime Text 2.0.2 x64.tar.bz2' --transform 's/Sublime Text 2/sublime-text-2/' -C /usr/lib/
	else
		wget -c http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2 -O /tmp/sublime.tar.bz2
		cd /tmp/
		sudo tar -jxf 'Sublime Text 2.0.2.tar.bz2' --transform 's/Sublime Text 2/sublime-text-2/' -C /usr/lib/
	fi

	cd /usr/lib/sublime-text-2/
	sudo sed 's/\x33\x42/\x32\x42/g' sublime_text > cracked
	sudo rm sublime_text && mv cracked sublime_text
	sudo chmod 777 sublime_text

	licensefile=$home_path'/.config/sublime-text-2/Settings/License.sublime_licenses'
			sudo echo '-----BEGIN LICENSE-----
Patrick Carey
Unlimited User License
EA7E-18848
4982D83B6313800EBD801600D7E3CC13
F2CD59825E2B4C4A18490C5815DF68D6
A5EFCC8698CFE589E105EA829C5273C0
C5744F0857FAD2169C88620898C3845A
1F4521CFC160EEC7A9B382DE605C2E6D
DE84CD0160666D30AA8A0C5492D90BB2
75DEFB9FD0275389F74A59BB0CA2B4EF
EA91E646C7F2A688276BCF18E971E372
-----END LICENSE-----' >> $licensefile

	sudo ln -s /usr/lib/sublime-text-2/sublime_text /usr/bin/sublime_text
	sudo echo '#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
# Only KDE 4 seems to use GenericName, so we reuse the KDE strings.
# From Ubuntus language-pack-kde-XX-base packages, version 9.04-20090413.
GenericName=Text Editor
Type=Application
Terminal=false
Exec="/usr/bin/sublime_text"
Comment[es_MX]=Sublime Text 2 Editor
Name=Sublime Text
Comment=Sublime Text 2 Editor
Icon=/usr/lib/sublime-text-2/Icon/48x48/sublime_text.png
Categories=TextEditor;IDE;Development
X-Ayatana-Desktop-Shortcuts=NewWindow
[NewWindow Shortcut Group]
Name=New Window
Exec="/usr/bin/sublime_text -n"' >> /usr/share/applications/sublime-text.desktop
}

function installNodejs {
	sudo apt-get -y install nodejs npm
}

#To do...
#apache
#sqlmap
#weevely
#wpscan
#steam
#zenmap (nmap)
#Workbench (Mysql Server)
#Qt
#geanymotion
#javaFX
#firefox (DE)

fi
