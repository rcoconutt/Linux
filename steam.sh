#!/bin/bash
# Steam installer for Debian Wheezy
# Tested on Debian 7.x
# https://wiki.debian.org/es/Steam
echo '+-----------------------+'
echo '|   Steam INSTALLER     |'
echo '+-----------------------+'
if [[ $EUID -ne 0 ]]; then
	echo "##### Necesitas ser root :( #####" 2>&1
exit 1
else
arch=`uname -m`
while [ "$repo" != "sid" ] && [ "$repo" != "jessie" ] && [ "$repo" != "N" ]; do
	echo '	Elige un repositorio para instalar Steam: '
	echo '	Debian Jessie  [jessie]'
	echo '	Debian Sid     [sid]'
	echo '	No usar repo   [N]'
		echo "Repositorio: "
		read  repo
		if [[ "$repo" = "sid"  ]]; then
			echo 'deb http://http.debian.net/debian/ sid main contrib non-free' >> /etc/apt/sources.list
			echo '##### Repositorios Sid agregados correctamente #####'
		elif [[ "$repo" = "jessie" ]]; then
			echo 'deb http://http.debian.net/debian/ jessie main contrib non-free' >> /etc/apt/sources.list
			echo '##### Repositorios Jessie agregados correctamente #####'
		elif [[ "$repo" = "N" ]]; then
			echo '##### No se utilizara ningun repositorio, esto puede ocasionar problemas #####'
		else 
			echo '##### Introduce una opcion valida :( #####'
		fi
done
	if [[ "$arch" = "x86_64" ]]; then
		echo '##### Agregando arquitectura de 32 bits... #####'
		sudo dpkg --add-architecture i386
	fi
echo '##### Actualizando sistema... #####'
sudo apt-get update
while [ "$gpu" != "nvidia" ] && [ "$gpu" != "amd" ] && [ "$gpu" != "intel" ]; do
	echo '	Elige tu tarjeta grafica: '
	echo '	Nvidia   [nvidia]'
	echo '  ATI/AMD  [amd]'
	echo '  Intel    [intel]'
		echo "Tarjeta grafica: "
		read  gpu
		if [[ "$gpu" = "nvidia" ]]; then
			echo '##### Instalando OpenGL de 32 bits para Nvidia... #####'
			sudo apt-get install libgl1-nvidia-glx:i386
		elif [[ "$gpu" = "amd" ]]; then
			echo '##### Instalando OpenGL de 32 bits para ATI/AMD... #####'
			sudo apt-get install libgl1-fglrx-glx:i386
		elif [[ "$gpu" = "intel" ]]; then
			echo '##### Instalando OpenGL de 32 bits para Intel... #####'
			sudo apt-get install libgl1-mesa-glx:i386
		else
			echo '##### Introduce una opcion valida :( #####'
		fi
done
sudo apt-get install debconf multiarch-support libc6  libgl1-mesa-dri libgl1-mesa-glx libstdc++6 libtxc-dxtn0 libx11-6 libxinerama1  xterm xz-utils fonts-liberation zenity
cd ~/
wget -c http://repo.steampowered.com/steam/archive/precise/steam_latest.deb && sudo dpkg -i steam_latest.deb
echo ''
echo '##### Steam instalado correctamente :) #####'
fi
