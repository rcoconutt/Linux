#!/bin/bash
# Tested on Debian Wheezy 7.x
clear scr
echo '+--------------------------------+'
echo '|   Sublime Text 2 1NST4LL3R     |'
echo '|        by @HackeaMesta         |'
echo '+--------------------------------+'
echo ''

if [[ $EUID -ne 0 ]]; then
	echo "##### Necesitas ser root :( #####" 2>&1
exit 1

else
arch=`uname -m`
cd /tmp/
	if [[ "$arch" == "x86_64" ]]; then
		echo '##### Descargando y extrayendo versión de 64 bits... #####'
		echo ''
		wget -c http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2
		sudo tar -jxf 'Sublime Text 2.0.2 x64.tar.bz2' --transform 's/Sublime Text 2/sublime-text-2/' -C /usr/lib/
	else
		echo '##### Descargando y extrayendo versión de 32 bits... #####'
		wget -c http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2
		sudo tar -jxf 'Sublime Text 2.0.2.tar.bz2' --transform 's/Sublime Text 2/sublime-text-2/' -C /usr/lib/
	fi
	while [ "$respuesta" != "S" ] && [ "$respuesta" != "s" ] && [ "$respuesta" != "N" ] && [ "$respuesta" != "n" ]; do
		echo ''
		echo 'Deseas crackear Sublime Text ahora? [S/n]: '
		read respuesta
		if [ "$respuesta" == "S" ] || [ "$respuesta" == "s" ]; then
			cd /usr/lib/sublime-text-2/
			sudo sed 's/\x33\x42/\x32\x42/g' sublime_text > cracked
			sudo rm sublime_text && mv cracked sublime_text
			sudo chmod 777 sublime_text
			echo 'Directorio Home: Default ['$HOME']'
			read directorio
			if [[ $directorio = "" ]]; then
				directorio=$HOME
			fi
			licensefile=$directorio'/.config/sublime-text-2/Settings/License.sublime_licenses'
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
		fi
	done
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
clear scr
echo '################################'
echo 'Sublime Text se instalo correctamente, si tienes problemas con la activación, dirigite a: Help > e introduce la licencia manualmente :)'
echo ''
echo '-----BEGIN LICENSE-----
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
-----END LICENSE-----'
fi
