#!/bin/bash

# A new user added in the start up if ADD_USER environment variable is given
# ex) docker run  -e ADD_USER={username} RSA_PUBLIC_KEY=  ...
if [[ ! -z $ADD_USER ]];
then
    adduser --disabled-password --gecos ""  "$ADD_USER" > /dev/null
    usermod -aG sudo "$ADD_USER" > /dev/null
    sudo -u "$ADD_USER" mkdir /home/"$ADD_USER"/.ssh
    sudo -u "$ADD_USER" chmod 700 /home/"$ADD_USER"/.ssh
    sudo -u "$ADD_USER" touch /home/"$ADD_USER"/.ssh/authorized_keys

    if [[ ! -z $RSA_PUBLIC_KEY ]];
    then
        sudo -u "$ADD_USER" echo "$RSA_PUBLIC_KEY" >> /home/"$ADD_USER"/.ssh/authorized_keys
    else
        sudo -u "$ADD_USER" cat /tmp/id_rsa.pub >> /home/"$ADD_USER"/.ssh/authorized_keys
    fi
    sudo -u "$ADD_USER" chmod 600 /home/"$ADD_USER"/.ssh/authorized_keys
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
fi

/usr/sbin/sshd -D

CMD=${1:-"exit 0"}

if [[ "$CMD" == "-d" ]];
then
    service sshd stop
    /usr/sbin/sshd -D
else
    /bin/bash -c "$*"
fi
