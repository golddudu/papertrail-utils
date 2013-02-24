#DuduG[dudu@ravellosystems.com]
echo "Adding syslog source for logs.papertrailapp.com" "as" $1 "tailing on" $2
if [ $1 != "" ]  && [ $2 != "" ] && [ -f /etc/rsyslog.d/server-log-to-pt.conf ] && [ -f $2 ]
    then
touch  server-log-to-pt.conf
echo "\$InputFileName $2
\$InputFileTag $1:
\$InputFileStateFile stat-$1
\$InputFileSeverity info
\$InputRunFileMonitor"  >> /etc/rsyslog.d/server-log-to-pt.conf

sudo service rsyslog restart
else
          echo "adding log did NOT work please verify the following :"
          echo "Please check that original file :  /etc/rsyslog.d/server-log-to-pt.conf really exists"
          echo "Please check that log file to track exists in path : $2"
          echo "Please use propper syntax : [log Tag Name] [machine log to tail]"
          echo 0
fi
