## Scripted Installation Guide (pfSense/OPNsense) + Elastic Stack 
- [x] Automate Installation
- [ ] Automate Configuration 

## Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)

# Installation

## 0a. Download and Run Script
```
sudo wget https://raw.githubusercontent.com/3ilson/pfelk/master/ez-pfelk-installer.sh
```
### 0b. Make the script executable 
```
sudo chmod +x ez-pfelk-installer.sh
```
### 0c. Execute the script 
```
sudo ./ez-pfelk-installer.sh
```

# Configuration 

## 1a. MaxMind
- Create a MaxMind Account @ https://www.maxmind.com/en/geolite2/signup
- Login to your MaxMind Account; navigate to "My License Key" under "Services" and Generate new license key
#### 1b. Edit GeoIP.conf
```
sudo nano /etc/GeoIP.conf
```
#### 1c. Modify lines 7 & 8 as follows (without < >):
```
AccountID <Input Your Account ID>
LicenseKey <Input Your LicenseKey>
```
#### 1d. Amend line 13 as follows:
```
EditionIDs GeoLite2-City GeoLite2-Country GeoLite2-ASN
```
#### 1e. Download Maxmind Databases
```
sudo geoipupdate -d /data/elk/GeoIP/
```
#### 1f. Add cron 
```
sudo nano /etc/cron.weekly/geoipupdate
```
#### 1g. Add the following and save/exit (automatically updates Maxmind every week on Sunday at 1700hrs)
```
00 17 * * 0 geoipupdate -d /data/elk/GeoIP
```
## 2. Configure Logstash|v7.6+
#### 2a. Enter your pfSense/OPNsense IP address 
`sudo nano /data/elk/configurations/01-inputs.conf`
```
Change line 12; the "if [host] =~ ..." should point to your pfSense/OPNsense IP address
Change line 15; rename "firewall" (OPTIONAL) to identify your device (i.e. backup_firewall)
Change line 18-27; (OPTIONAL) to point to your second PF IP address or ignore
```
#### 2b. Revise/Update w/pf IP address 
`sudo nano /data/elk/configurations/01-inputs.conf`
```
For pfSense uncommit line 34 and commit out line 31
For OPNsense uncommit line 31 and commit out line 34
```
## 3. Configure Kibana|v7.6+
#### 3a. Configure Kibana
```
sudo nano /etc/kibana/kibana.yml
```
#### 3b. Modify host file (/etc/kibana/kibana.yml)
- server.port: 5601
- server.host: "0.0.0.0"

## 4. Complete Configuration --> [Configuration](configuration.md)
