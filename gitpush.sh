#!/bin/bash

sudo rm /root/.git-credentials
### Directory name, user, url and public ip enumeration
dirname=${PWD##*/}
github_user=$( echo $dirname | cut -d "." -f1 )
github_url="https://github.com/"$github_user"/"$github_user".github.io"
publicip=$( curl -s icanhazip.com )

### Tor service and torsocks start
read -p "Press any key to restart tor service"
echo '--- Restarting tor service ---'
sudo service tor restart && sleep 3
echo '--- Activating torsocks for current terminal session ---'
. torsocks on
torpublicip=$( curl -s icanhazip.com )

### IP addresses enumeration, credential enumeration & input
echo "--- WAN public IP/Onion public IP: $publicip/$torpublicip"
echo "--- Username: $github_user"
echo "--- Repository URL: $github_url"
echo "--- Please input personal token: ---"
read personal_token

### GIT init, credential enrollment, commit and push
git init
git config user.name $github_user
git config user.password $personal_token
git config credential.helper store
git remote add origin $github_url
git add -A
git branch -M main
git commit -m 'Test'
git push -f -u origin main
sleep 2

### Housekeeping
echo "--- Dectivating torsocks for current terminal session ---"
. torsocks off
echo "--- Deleting .git folder ---"
sudo rm -r .git
echo "--- Stopping tor service ---"
sudo service tor stop
