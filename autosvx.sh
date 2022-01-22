#!/bin/bash

# MIT License

# Copyright (c) [2022] [Dave Vermeulen]

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

echo "--------------------------------------------------------------"
echo                      "This Script Is Meant To Be Run" 
echo                          "On A Fresh Install Of"
echo                     "Raspbian / Arm32-Bit / Arm64-Bit"   
echo  "--------------------------------------------------------------"

			 
	echo "--------------------------------------------------------------"
    echo "   This Script Currently Requires a internet connection       "
    echo "--------------------------------------------------------------"
    wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null

    if [[ ! -s /tmp/index.google ]] ;then
            echo "No Internet connection. Please check ethernet cable / wifi connection"
            /bin/rm /tmp/index.google
            exit 1
    else
            echo "               I Found the Internet ... continuing!!!!!"
            /bin/rm /tmp/index.google
    fi

    echo "--------------------------------------------------------------"
    printf ' Current ip is eth0: '; ip -f inet addr show dev eth0 | sed -n 's/^ *inet *\([.0-9]*\).*/\1/p'
    printf ' Current ip is wlan0: '; ip -f inet addr show dev wlan0 | sed -n 's/^ *inet *\([.0-9]*\).*/\1/p'
    echo "--------------------------------------------------------------"
    echo

#svxlink deps
                echo "------------------------------------------------"
                echo "Installing and Configuring Svxlink Dependencies."
                echo "------------------------------------------------"


sudo apt-get install -y python3 python3-pip git 
sudo pip install pyserial
sudo apt-get install -y nano
sudo apt-get update -y
#Cleanup
sudo apt-get clean
sleep 1
                
		echo "-------------------------------------------------------------------------"
                echo "Temporarily adding the Buster software repository and installing SvxLink."
                echo "-------------------------------------------------------------------------"


echo 'deb http://mirrordirector.raspbian.org/raspbian/ buster main' | sudo tee /etc/apt/sources.list.d/svxlink.list

sudo apt-get -t buster install svxlink-server -y

echo 'Removingthe Buster software repository'

sudo rm /etc/apt/sources.list.d/svxlink.list

        echo "--------------------------------------------------------------"
        echo "                Installing svxlink sounds                     "
        echo "--------------------------------------------------------------"

cd /usr/share/svxlink/sounds/
sudo wget https://github.com/sm0svx/svxlink-sounds-en_US-heather/releases/download/14.08/svxlink-sounds-en_US-heather-16k-13.12.tar.bz2
sudo tar xvjf svxlink-sounds-en_US-heather-16k-13.12.tar.bz2
sudo ln -s en_US-heather-16k en_US
sudo rm /usr/share/svxlink/sounds/svxlink-sounds-en_US-heather-16k-13.12.tar.bz2

         echo "--------------------------------------------------------------"
         echo "          Installing svxlink into the gpio group              "
         echo "--------------------------------------------------------------"
#adding user svxlink to gpio user group
sudo usermod -a -G gpio svxlink
 
         echo "--------------------------------------------------------------"
         echo "              Setting up configuration files                  "
         echo "--------------------------------------------------------------"
 
 # Ask the user for their callsign
echo Please enter your callsign
echo
read -p 'Callsign: ' uservar 
echo
sudo echo 'CALLSIGN='$uservar >> /home/pi/SvxLink/ModuleEchoLink.conf
# Ask the user for login details
echo Please enter your echolink password
echo
read -sp 'Password: ' passvar
echo 
sudo echo 'PASSWORD='$passvar >> /home/pi/SvxLink/ModuleEchoLink.conf
echo
echo
# Ask the user for name
echo Please enter your name
echo
read -p 'SYSOPNAME: ' qthvar  
sudo echo 'SYSOPNAME='$qthvar  >> /home/pi/SvxLink/ModuleEchoLink.conf
echo
echo
# Ask the user for name
echo Please enter your name
echo
read -p 'LOCATION=: ' locvar 
echo 
sudo echo 'LOCATION='$locvar  >> /home/pi/SvxLink/ModuleEchoLink.conf

         echo "--------------------------------------------------------------"
         echo "               Copying Svxlink Configuration Files            "
         echo "--------------------------------------------------------------"

sudo cp -r /home/pi/SvxLink/svxlink.conf /etc/svxlink
sudo cp -r /home/pi/SvxLink/ModuleEchoLink.conf /etc/svxlink/svxlink.d
sudo cp -r /home/pi/SvxLink/rc.local /etc/

#sudo rm -r /home/pi/SvxLink

	
	   echo "-------------------------------------------------------------------------"
       echo "      Reboot Now! Setup and configuration of your echolink is now done   " 
       echo	"-------------------------------------------------------------------------"
	   echo "---------------------------------------------------------------------------------------"
       echo "             To Manually Tweak The Svxlink or OS Configuration Files 
                            	       open them with nano editor.  " 
       echo	"---------------------------------------------------------------------------------------"
	   echo "---------------------------------------------------------------------------------------"
       echo "   The locations of the config files can be found in the installation guide
                                    	    or the net " 
       echo	"---------------------------------------------------------------------------------------"
	   echo
while true; do
    read -p "Do you wish to reboot now?" yn
    case $yn in
        [Yy]* ) sudo reboot ; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
	done
	exit
	
#Please be sure to check out my youtube channel Thanks! 73's Dave ZR6LSD
#YouTube: https://www.youtube.com/channel/UChsvCpuR1VJg0w5DX9j5GsA
