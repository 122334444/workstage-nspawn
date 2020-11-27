#!/bin/bash

for i in "$@"
do
case $i in
	--BIND_DIR=*)
		BIND_DIR="${i#*=}"
	;;
	--cont_name=*)
		cont_name="${i#*=}"
	;;
	--cont_pass=*)
		cont_pass="${i#*=}"
	;;
	--cont_super_pass=*)
		cont_super_pass="${i#*=}"
	;;
	*)
		#echo "BAD KEYS FOUND"
	;;
esac
done

ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
echo -e "\n\nEDITOR=nano\nVISUAL=nano" >> /etc/environment
echo -e "en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
mkinitcpio -p linux

cat <<EOF > /etc/pam.d/login
#%PAM-1.0

#auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
account    include      system-local-login
session    include      system-local-login
EOF

cat <<EOF >> /etc/sudoers


$cont_name ALL=(ALL) NOPASSWD: ALL
EOF

cat <<EOF > /etc/systemd/network/80-container-host0.network
[Match]
Name=host0

[Network]
DHCP=yes
EOF

mkdir /root/.ssh
cp $BIND_DIR/conf/authorized_keys /root/.ssh/authorized_keys
cp $BIND_DIR/conf/sshd_config /etc/ssh/sshd_config
useradd -m -g users -G wheel -s /bin/bash $cont_name
systemctl enable systemd-resolved systemd-networkd sshd
echo -e "$cont_super_pass\n$cont_super_pass" | passwd root
echo -e "$cont_pass\n$cont_pass" | passwd $cont_name

exit

