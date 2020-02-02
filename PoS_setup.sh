#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your timedepositcoin POS server  .*"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [ $DOSETUP = "y" ]  
then
  sudo apt-get update
  sudo apt-get -y upgrade
  sudo apt-get -y dist-upgrade
  sudo apt-get update
  sudo apt-get install -y zip unzip

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

  timedepositcoin-cli stop
  wget https://github.com/wonderbuilder/timedepositcoin/releases/download/v1.0.0.0/Linux.zip
  unzip Linux.zip
  chmod +x Linux/bin/*
  sudo mv  Linux/bin/* /usr/local/bin
  rm -rf linux.zip Linux

  sudo apt-get install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw 22711
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

fi

## Setup conf
mkdir -p ~/.timedepositcoin
echo ""
echo "Configure your POS Server now!"


echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` > ~/.timedepositcoin/timedepositcoin.conf
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> ~/.timedepositcoin/timedepositcoin.conf
echo "rpcallowip=127.0.0.1" >> ~/.timedepositcoin/timedepositcoin.conf
echo "rpcport=$RPCPORT" >> ~/.timedepositcoin/timedepositcoin.conf
echo "listen=1" >> ~/.timedepositcoin/timedepositcoin.conf
echo "server=1" >> ~/.timedepositcoin/timedepositcoin.conf
echo "daemon=1" >> ~/.timedepositcoin/timedepositcoin.conf
echo "logtimestamps=1" >> ~/.timedepositcoin/timedepositcoin.conf
echo "maxconnections=256" >> ~/.timedepositcoin/timedepositcoin.conf
echo "staking=1" >> ~/.timedepositcoin/timedepositcoin.conf
echo "" >> ~/.timedepositcoin/timedepositcoin.conf

timedepositcoind -daemon
