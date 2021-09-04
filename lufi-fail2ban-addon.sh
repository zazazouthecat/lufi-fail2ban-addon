#Script SBER v1.0 - 04/09/2021

# - Script d'installation automatisé
#!/bin/bash


# On vérifie si l'utilisateur à les droits sudo ou root
if ! [ $( id -u ) = 0 ]; then
    echo "Merci de lancer ce script en root ou sudo" 1>&2
    exit 1
fi


# Colors to use for output
YELLOW2='\033[1;33m'
YELLOW='\033[1;43m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BLACK='\033[0;30m'
NC='\033[0m' # No Color

# Log Location
LOG="/tmp/lufi_install.log"

# Initialize variable values
iphost=""
installFail2ban=""
installLDAP=""
lufiDb=""
lufiUser=""
lufiPwd=""
PROMPT=""
fail2banbanTime=""
fail2banfindTime=""
fail2banmaxRetry=""
fail2bancustomIp=""
fail2banNotBanIpRange=""
fail2banLogPath=""

#Prez !
clear
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▓███▓▒${WHITE}░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}████▓▓██▓${WHITE}░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒${BLACK}███${WHITE}░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▒▒▓████████████████████████▓▒▒${WHITE}░░░░░░░░░░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▒▓█████▓▓▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓███${RED}██${BLACK}██▓▒${WHITE}░░░░░░░░░▒${BLACK}▓██▓${YELLOW}▒▒▒▒${BLACK}▓███▒${WHITE}░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░░░░${BLACK}▒████▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓▓▓▓${YELLOW}▒▒▒▒▒▒▒▒${BLACK}▓██${RED}███████${BLACK}██▓${WHITE}▒░░░${BLACK}▒███▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░░░${BLACK}▒████▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓████████▓${YELLOW}▒▒${BLACK}▓██${RED}████████████${BLACK}██▓███▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░░░${BLACK}▓███▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓██▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓${YELLOW}▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓████${TELLOW}▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░░${BLACK}▒███${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓▓▓▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░${BLACK}███▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░${BLACK}▒██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░${BLACK}▒██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░${BLACK}▒██${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░${BLACK}▒██${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░${BLACK}██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░${BLACK}███${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}▒██▓${YELLOW}▒▒▒▒▒▒▒▒▒▒▒▒${BLACK}▓█${YELLOW}▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}███${YELLOW}▒▒▒▒▒▒▒▒${BLACK}▓█▓${YELLOW}▒▒${BLACK}▓██${YELLOW}▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}███${YELLOW}▒▒▒${BLACK}▓█▓${YELLOW}▒▒${BLACK}▓██${YELLOW}▒▒▒${BLACK}▓▓${YELLOW}▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▒██▓${YELLOW}▒▒▒${BLACK}███${YELLOW}▒▒▒${BLACK}██▓${YELLOW}▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▒██▓${YELLOW}▒▒▒${BLACK}███${YELLOW}▒▒▒${BLACK}▓█▓${YELLOW}▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▒██▓${YELLOW}▒▒▒${BLACK}▓██▓${YELLOW}▒▒▒${BLACK}▓▓▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▒██▓${YELLOW}▒▒▒▒${BLACK}██▓${YELLOW}▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}███${YELLOW}▒▒▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}███${YELLOW}▒▒▒▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░${BLACK}▒██▓${YELLOW}▒▒▒${BLACK}▓██${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░${BLACK}███${YELLOW}▒${BLACK}███${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░${BLACK}▒████${RED}████████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░${BLACK}▓██${RED}███████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░▒▒░░░░░░░▒▒░░░░░▒▒░░▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒░░░░░"
echo -e "${WHITE}░░░░░░░${BLACK}███${RED}████████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░▒▒░░░░░░░▒▒░░░░░▒▒░░▒▒░░░░░░░░░░░▒▒░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░${BLACK}███${RED}█████████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░▒▒░░░░░░░▒▒░░░░░▒▒░░▒▒▒▒▒▒░░░░░░░▒▒░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░${BLACK}███${RED}██████${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░▒▒░░░░░░░▒▒░░░░░▒▒░░▒▒░░░░░░░░░░░▒▒░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░${BLACK}▓███${RED}██${BLACK}██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒░░░▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░░${BLACK}▓████▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░Fail2Ban Add-on v1.0░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░░░${BLACK}▒███▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░░${BLACK}▒███▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░..::THE NERD CAT::..░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░░░${BLACK}▓██▓${YELLOW}▒▒▒▒▒${BLACK}▓██▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░${BLACK}▓███${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${BLACK}███${YELLOW}▒▒▒▒▒${BLACK}███▒${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${BLACK}███▓${YELLOW}▒${BLACK}▓███${WHITE}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
echo -e "${WHITE}░${BLACK}▒████▓${WHITE}▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░\033[0m"
echo
echo
echo
# Fin de Prez !



#################
### FAIL2BAN ###
#################
# On demande si on veut utiliser le Fail2Ban
	if [[ -z ${installFail2ban} ]]; then
		echo -e -n "${CYAN}Voulez-vous installer la fonction Fail2Ban (Anti-BruteForce) ? (O/n): ${NC}"
		read PROMPT
		if [[ ${PROMPT} =~ ^[Nn]$ ]]; then
			installFail2ban=false
		else
			installFail2ban=true
		fi
	fi

	# Installation et configuration de fail2ban
	if [ "${installFail2ban}" = true ]; then
		[ -z "${fail2banbanTime}" ] \
		&& read -p "Entrez le nombre de minutes ou l'ip sera bannie (Ex : 15 ): " fail2banbanTime
		[ -z "${fail2banmaxRetry}" ] \
		&& read -p "Entrez le nombre maximum autorisé de tentative de mot de passe (Ex : 5) : " fail2banmaxRetry
		[ -z "${fail2banfindTime}" ] \
		&& read -p "Entrez le laps de temps autorisé pour faire le maximum de tentative (Ex : 10 , Si 5 essais en < 10min = Ban) : " fail2banfindTime
		[ -z "${fail2banLogPath}" ] \
		&& read -p "Entrez le chemin ou est installé l'applicaton Lufi (Ex : /etc/lufi) : " fail2banLogPath
		
		echo
		echo -e "${CYAN}Installation du paquet Fail2ban & ufw...${NC}"

		apt-get -y install fail2ban &>> ${LOG}
		apt-get -y install ufw &>> ${LOG}
		if [ $? -ne 0 ]; then
			echo -e "${RED}Echec. Voir ${LOG}${NC}" 1>&2
			#exit 1 -- useless
		else
			echo -e "${GREEN}OK${NC}"
		fi
		echo
		
		echo -e "${CYAN}Configuration de Fail2ban pour Lufi...${NC}"
			
		cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
		
		echo -e "${CYAN}Téléchargement du fichier filter Lufi pour Fail2Ban...${NC}"
		wget --no-check-certificate -q --show-progress https://raw.githubusercontent.com/zazazouthecat/lufi-fail2ban-addon/main/fail2ban/filter.d/lufi.conf -O /etc/fail2ban/filter.d/lufi.conf

		
		echo "[lufi]" >> /etc/fail2ban/jail.d/lufi.conf
		echo "enabled = true" >> /etc/fail2ban/jail.d/lufi.conf
		echo "banaction=ufw" >> /etc/fail2ban/jail.d/lufi.conf
		#On transforme les minustes de fail2banbanTime en secondes
		fail2banbanTime=$((fail2banbanTime*60))
		echo "bantime=${fail2banbanTime}" >> /etc/fail2ban/jail.d/lufi.conf
		#On transforme les minustes de fail2banfindTime en secondes
		fail2banfindTime=$((fail2banfindTime*60))
		echo "findtime=${fail2banfindTime}" >> /etc/fail2ban/jail.d/lufi.conf
		echo "maxretry=${fail2banmaxRetry}" >> /etc/fail2ban/jail.d/lufi.conf
		echo "logpath=${fail2banLogPath}/log/production.log" >> /etc/fail2ban/jail.d/lufi.conf
					
		echo
		echo -e "${CYAN}Ajout de regle, pour empêcher les ip locales d'être bannies ${NC}"

		if [[ -z ${fail2bancustomIp} ]]; then
				echo -e -n "${CYAN}Voulez-vous configurer une plage d'ip perso en plus de celle par défaut ? (O/n): ${NC}"
				read PROMPT
				if [[ ${PROMPT} =~ ^[Nn]$ ]]; then
					fail2bancustomIp=false
					echo -e "${BLUE} Ajout de la regle par defaut \033[1;33m(127.0.0.1/8 & 192.168.0.0/16)\033[0m"
					echo "ignoreip=127.0.0.1/8 192.168.0.0/16" >> /etc/fail2ban/jail.d/lufi.conf
				else
					fail2bancustomIp=true
				fi
		fi
		if [ "${fail2bancustomIp}" = true ]; then
			[ -z "${fail2banNotBanIpRange}" ] \
			&& read -p "Entrez la plage d'ip a exclure (Ex : 172.16.0.0/16): " fail2banNotBanIpRange
			echo "ignoreip=127.0.0.1/8 192.168.0.0/16 ${fail2banNotBanIpRange}" >> /etc/fail2ban/jail.d/lufi.conf
			echo -e "${BLUE} Ajout de la regle personalisée \033[1;33m(127.0.0.1/8 & 192.168.0.0/16 & ${fail2banNotBanIpRange})\033[0m"
			#sed -i "s|#ignoreip = 127.0.0.1/8 ::1|ignoreip = 127.0.0.1/8 ::1 192.168.0.0/16 ${fail2banNotBanIpRange}|" /etc/fail2ban/jail.local
		fi
		
		echo
		echo -e "${CYAN}Démarrage du service Fail2ban & Activation au démarrage...${NC}"
		sudo service fail2ban restart
		systemctl enable fail2ban
		
		echo
		echo -e "${CYAN}Démarrage du service ufw & Activation au démarrage...${NC}"
		sudo service ufw restart
		systemctl enable ufw
		sudo ufw --force enable
		#On autorise les flux sur le port 8080 dans ufw
		echo -e "${YELLOW2} Autorisation des flux sur le port 8081 & 80 & 443 dans ufw"
		sudo ufw allow 8081
		sudo ufw allow 80
		sudo ufw allow 443
		echo
		echo -e "${YELLOW2} Autorisation des flux sur le port 22 dans ufw"
		echo -e "${BLUE} Autorisation par defaut de \033[1;33m192.168.0.0/16\033[0m ${BLUE}port 22\033[0m"
		sudo ufw allow from 192.168.0.0/16 to any port 22
		if [ "${fail2bancustomIp}" = true ]; then
			echo -e "${BLUE} Autorisation personalisée de \033[1;33m${fail2banNotBanIpRange}\033[0m ${BLUE}port 22\033[0m"
			sudo ufw allow from ${fail2banNotBanIpRange} to any port 22
		fi
	fi


# Done
systemctl start lufi.service
sudo service lufi restart


echo -e "${CYAN} **********  Installation Terminée   **********\033[0m"
