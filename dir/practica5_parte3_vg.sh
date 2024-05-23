#!/bin/bash
#869469, Artigas Subiras, Adrián, T, 1, A
#873026, Becerril Granada, Adrián, T, 1, A

#Comprobamos el nº de parámetros
if [ "$#" -lt 2 ]
then
	echo "Usage: $0 <nombre_vg> <part1> ..."
else
	# Verificamos que tenemos privilegios
	if [ $EUID -ne 0 ]
	then
		echo "Se requieren privilegios"
	else
		# Guardamos el grupo de volúmenes
		vg="$1"
		shift

		# Comprobamos que el grupo de volúmenes exista
		if ! vgdisplay "$vg";
		then
			echo "El grupo de volumenes \"$vg\" no se ha encontrado"
		else
			for particion in "$@";
			do
				# Comprobamos que existe la particion
				if ! lsblk "$particion";
				then
					echo "No se ha podido encontrar la particion \"$particion\""
					continue
				else
					# Comprobamos si la partición está montada y en tal caso la desmontamos
					if findmnt "$particion";
					then
						echo "La particion \"$particion\" va a ser desmontada"
						umount "$particion"

					fi
					vgextend "$vg" "$particion"
				fi
			done
		fi
	fi
fi
