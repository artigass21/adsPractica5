#!/bin/bash
#869469, Artigas Subiras, Adrián, T, 1, A
#873026, Becerril Granada, Adrián, T, 1, A

if [ "$#" -ne 1 ]
then
	echo "Usage: $0 <IP>"
else
	IP=$1
	# Comprobamos que nos responde la máquina
	if ping -c 1 "$1";
	then
		# Sacar discos disponibles y tamaño de bloque
		ssh -i "~/.ssh/id_as_ed25519" "as@$1" "sudo sfdisk -s | grep "^/dev/""

		# Mostrar particiones y tamaño
		ssh -i "~/.ssh/id_as_ed25519" "as@$1" "sudo sfdisk -l | grep "^/dev/" | tr -d \"*\" | sed 's/  */ /g' | cut -d ' ' -f1,5"

		# INformación del sistema de ficheros
		ssh -i "~/.ssh/id_as_ed25519" "as@$1" "sudo df -hT | grep -v \"tmpfs\" | grep "^/""
	else
		echo "No se ha podido conecta a la maquina $1"
	fi
fi
