echo "pfELK: Generating pfELK Error Data"
#remove any old pfelk error outputs
sudo rm /data/elk/error.pfelk.log
#create the new file
sudo touch /data/elk/error.pfelk.log
#add system information
echo "#####################################" >> /data/elk/error.pfelk.log
echo "# pfELK System Information ##########" >> /data/elk/error.pfelk.log
echo "#####################################\n" >> /data/elk/error.pfelk.log
printf "$(uname -srm)\n$(cat /etc/os-release)\n" | cat >> /data/elk/error.pfelk.log
#capture directory and files structure
echo "\n#####################################" >> /data/elk/error.pfelk.log
echo "# Listing pfELK Directory Structure #" >> /data/elk/error.pfelk.log
echo "#####################################\n" >> /data/elk/error.pfelk.log
find /data/ | cat >> /data/elk/error.pfelk.log
#capture all config files
echo "\n#####################################" >> /data/elk/error.pfelk.log
echo "# pfELK Config File Details #########" >> /data/elk/error.pfelk.log
echo "#####################################\n" >> /data/elk/error.pfelk.log
cat /data/elk/configurations/*.conf >> /data/elk/error.pfelk.log
echo "\n#####################################" >> /data/elk/error.pfelk.log
echo "# Listing Logstash Pipelines.yml #" >> /data/elk/error.pfelk.log
echo "#####################################\n" >> /data/elk/error.pfelk.log
cat /etc/logstash/pipelines.yml >> /data/elk/error.pfelk.log
echo "\n#####################################" >> /data/elk/error.pfelk.log
echo "# Listing Logstash Logstash.yml Log Path #" >> /data/elk/error.pfelk.log
echo "#####################################\n" >> /data/elk/error.pfelk.log
cat /etc/logstash/logstash.yml | grep path.logs* >> /data/elk/error.pfelk.log
#attach logstash logs
echo "\n#####################################" >> /data/elk/error.pfelk.log
echo "# Appending Logstash Logs ###########" >> /data/elk/error.pfelk.log
echo "#####################################\n" >> /data/elk/error.pfelk.log
tail -20 /data/elk/logs/logstash-plain.log | cat >> /data/elk/error.pfelk.log
#attach Java version
echo "\n#####################################" >> /data/elk/error.pfelk.log
echo "# Java Version ######################" >> /data/elk/error.pfelk.log
echo "#####################################\n" >> /data/elk/error.pfelk.log
java -version 2>> /data/elk/error.pfelk.log
#capture systemctl status outputs to validate services running
echo "\n#####################################" >> /data/elk/error.pfelk.log
echo "# ELK Services Check ################" >> /data/elk/error.pfelk.log
echo "#####################################\n" >> /data/elk/error.pfelk.log
echo "\n###Elasticsearch.service:###\n" >> /data/elk/error.pfelk.log
systemctl status elasticsearch.service -q | cat >> /data/elk/error.pfelk.log
echo "\n###Logstash.service:###\n" >> /data/elk/error.pfelk.log
systemctl status logstash.service -q | cat >> /data/elk/error.pfelk.log
echo "\n###Kibana.service:###\n" >> /data/elk/error.pfelk.log
systemctl status kibana.service -q | cat >> /data/elk/error.pfelk.log
echo "Error Data Collected Successfully"
echo "Attach the contents of /data/elk/error.pfelk.log as a file to your Issue in github"
