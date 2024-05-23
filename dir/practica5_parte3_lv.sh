#!/bin/bash
#869469, Artigas Subiras, Adrián, T, 1, A
#873026, Becerril Granada, Adrián, T, 1, A

while read linea;
do
	IFS=,
	read -r vg lv tam sf mp <<< "$linea"
	if sudo lvdisplay  /dev/$vg/$lv;
	then
		sudo lvextend -L $tam /dev/$vg/$lv
		sudo resize2fs /dev/$vg/$lv
	else
		echo "El volumen no existe, se dispone a crearlo..."
		sudo lvcreate -L $tam -n $lv $vg
		sudo mkfs -t $sf /dev/$vg/$lv
		sudo mkdir -p $mp
		echo "/dev/$vg/$lv $mp $sf defaults 0 2" | sudo tee -a /etc/fstab
	fi
done
