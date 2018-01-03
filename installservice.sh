#!/bin/sh
#for Ubuntu 16-17 only

#this is the first version so it will be a service running a script, updates will come

echo "Type the name of the service"
read service
echo "Type path of to the script including script ( /path/script. )"
read path
sudo mkdir $path #will create path if it does not exist or just fail

sudo echo '
[Unit]
Description= CPU monitor
After=Network.target

[Service]
User=root
Restart=always
Type=forking
Restart=10
ExecStart=/bin/sh $path

[Install]
WantedBy=multi-user.target' | tee -a /etc/systemd/system/$service.service

sudo chmod 755 /etc/systemd/system/$service.service
sudo echo "plese put script in script-folder"
read -p "Have you done it (y/n)?" yn
   case $yn in
    [Yy]* ) sudo systemctl daemon-reload
            sudo systemctl start $service
    ;;

    [Nn]* ) exit;;
    * ) echo 'Please answer yes or no.';;
   esac
