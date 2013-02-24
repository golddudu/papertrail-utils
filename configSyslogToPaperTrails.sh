#DuduG[dudu@ravellosystems.com]
echo "Running syslog configuration for logs.papertrailapp.com" $1 $2 "as" $3 "tailing on" $4 "from source" $5
if [ $1 == "-p" ] && [ $2 -ge 1000  ] && [ $3 != "" ]  && [ $4 != "" ] && [ $5 != "" ] && [ -f $4 ]
    then
touch  server-log-to-pt.conf
echo "\$ModLoad imfile
\$InputFileName $4 
\$InputFileTag $3:
\$InputFileStateFile stat-$3
\$InputFileSeverity info
\$InputRunFileMonitor

\$InputFilePollInterval 10 #Polls every 10 seconds for updates" > server-log-to-pt.conf

#dowload the certificate from PT and copy
wget https://papertrailapp.com/tools/syslog.papertrail.crt
mv syslog.papertrail.crt /etc/syslog.papertrail.crt
#install gnuTLS security module
apt-get -y install rsyslog-gnutls
ls -la /usr/lib/rsyslog/lmnsd_gtls.so

sudo sed -e 's/$PrivDropToGroup syslog/$PrivDropToGroup adm/' /etc/rsyslog.conf > rsyslog.temp
if grep -Fxq "@@logs.papertrailapp.com:$2" rsyslog.conf
then
     echo "log destination entry already exists"
else
     sudo echo "\$DefaultNetstreamDriverCAFile /etc/syslog.papertrail.crt # trust these CAs
	\$ActionSendStreamDriver gtls # use gtls netstream driver
	\$ActionSendStreamDriverMode 1 # require TLS
	\$ActionSendStreamDriverAuthMode x509/name # authenticate by hostname
	
	\$LocalHostName $5

	*.*;CRON.none   @@logs.papertrailapp.com:$2" >> rsyslog.temp
fi
sudo mv rsyslog.temp /etc/rsyslog.conf
sudo mv  server-log-to-pt.conf /etc/rsyslog.d/.
cat /etc/rsyslog.d/server-log-to-pt.conf |grep InputFileName
cat /etc/rsyslog.d/server-log-to-pt.conf |grep InputFileTag
cat /etc/rsyslog.conf |grep PrivDropToGroup
cat /etc/rsyslog.conf |grep papertrailapp
sudo service rsyslog restart
else
	  echo "adding log did NOT work please verify the following :"
      echo "Please check that log file to track exists in path : $2"
	  echo "Please use propper syntax : -p [port number <greater than 1000>] [log Tag Name] [machine log to tail]"
	  echo 0
fi
