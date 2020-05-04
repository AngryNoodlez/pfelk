#!/bin/sh
# Use this script to install OS dependencies, downloading and compile pfELK dependencies

# This script will
# * use apt-get/yum to install OS dependancies
# * download known working versions of pfELK dependencies
# * configure pfELK <-- In Work... Configuration Script
# * install Elasticstack
# * install Java 11 LTS
# * install Maxmind (GeoIP) <-- In Work... Configuration Script
# * install apt-trasnport-https (ATH)

# Check the existance of sudo
command -v sudo >/dev/null 2>&1 || { echo >&2 "pfELK: sudo is required to be installed"; exit 1; }

# Installing pfELK dependencies
echo "pfELK: Installing Inital Dependencies & Added Respositories"

#Redhat
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y install wget apt-transport-https; sudo yum add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

#Debian
if hostnamectl | grep 'Operating System: Debian*' > /dev/null; then
  sudo apt-get -qq install wget apt-transport-https gnupg2 software-properties-common dirmngr lsb-release ca-certificates; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#Ubuntu
if hostnamectl | grep 'Operating System: Ubuntu*' > /dev/null; then
  sudo apt-get -qq install wget apt-transport-https; sudo add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#FreeBSD (forthcoming)
#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr wget apt-transport-https; sudo add-apt-repository ppa:maxmind/ppa; sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list; sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#  MAKE=gmake
#fi


# Update Required Respositories
echo "pfELK: Updating Respositories"
#Redhat
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y update
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

#Debian
if hostnamectl | grep 'Operating System: Debian*' > /dev/null; then
  sudo apt-get -qq update
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#Ubuntu
if hostnamectl | grep 'Operating System: Ubuntu*' > /dev/null; then
  sudo apt-get -qq update 
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#FreeBSD (forthcoming)
#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr update
#  MAKE=gmake
#fi

# Install Required Respositories
echo "pfELK: Installing Required Respositories - This may take some time, please be patient"

#Redhat
if [ -f "/etc/redhat-release" ] || [ -f "/etc/system-release" ]; then
  sudo yum -y install openjdk-11-jre; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
  if [ $? -ne 0 ]; then
    echo "pfELK: yum failed"
    exit 1
  fi
fi

#Debian
if hostnamectl | grep 'Operating System: Debian*' > /dev/null; then
  sudo apt-get -qq install openjdk-11-jre; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash; cd $HOME; wget https://github.com/maxmind/geoipupdate/releases/download/v4.3.0/geoipupdate_4.3.0_linux_amd64.deb; sudo dpkg -i ./geoipupdate_4.3.0_linux_amd64.deb
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi

#Ubuntu
if hostnamectl | grep 'Operating System: Ubuntu*' > /dev/null; then
  sudo apt-get -qq install openjdk-11-jre; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
  if [ $? -ne 0 ]; then
    echo "pfELK: apt-get failed"
    exit 1
  fi
fi


#FreeBSD (forthcoming)
#if [ "$UNAME" = "FreeBSD" ]; then
#  sudo pkg_add -Fr install openjdk-11-jre; sudo apt-get -qq install geoipupdate; sudo apt-get -qq install elasticsearch; sudo apt-get -qq install kibana; sudo apt-get -qq install logstash
#  MAKE=gmake
#fi

# System Configuration
echo "pfELK: System Optimization"
sudo swapoff -a

# Download Configuration & Pattern
  echo "pfELK: Retrieving Confguration Files"
  sudo mkdir /data 
  sudo mkdir /data/elk
  sudo mkdir /data/elk/patterns
  sudo mkdir /data/elk/templates
  sudo mkdir /data/elk/configurations
  sudo mkdir /data/elk/logs
  sudo mkdir /data/elk/GeoIP
  cd /data/elk/configurations
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/01-inputs.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/05-firewall.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/10-others.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/20-suricata.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/25-snort.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/30-geoip.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/35-rules-desc.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/40-dns.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/45-cleanup.conf
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/configurations/50-outputs.conf
  cd /data/elk/patterns
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/patterns/pfelk.grok
  cd /data/elk/templates
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/data/templates/pf-geoip-template.json
##
# Add Configuration Script Here
##

# Install/Troubleshoot Success Message
echo "pfELK: Finalizing Installtion"
  cd /etc/logstash
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/pipelines.yml
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/logstash.yml
  cd /data/elk
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/error-data.sh
  sudo chmod +x /data/elk/error-data.sh
  sudo chmod 777 /data/elk/logs
  sudo wget https://raw.githubusercontent.com/AngryNoodlez/pfelk/master/readme.txt
  cat readme.txt
exit 0
