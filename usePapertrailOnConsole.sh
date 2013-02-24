#DuduG[dudu@ravellosystems.com]
echo "Running papertrail installer on your machine with token " $1
if [ $1 != "" ] 
    then
apt-get install rubygems
echo "installing papertrail..."
gem install papertrail
echo "token: "$1 > ~/.papertrail.yml
papertrail -h
else
	  echo "No token specified, please input your token like this:"
          echo "./userPapertrailOnConsole.sh [yourToken]"
	  echo 0
fi
