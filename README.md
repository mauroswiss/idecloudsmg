SMG - Docker Image
=============================


Cloud9 v3 Dockerfile
====================

This repository contains Dockerfile of Cloud9 IDE for Docker's automated build published to the public Docker Hub Registry.



## How Usage

    docker run -it -d -p 80:80 smg/cloud9-smg
    
#You can add custom configuration and a workspace as directory with the argument *-v /path/workspace/:/workspace/* like this :
docker run -d --name container-test -p 8888:80 -p 8880:8080 -p 8881:8081 -p 8882:8082 -p 8883:8083 -e 'C9_FULLNAME=<YOURFULLNAME>' -e 'C9_EMAIL=<YOURMAIL>' -e 'PORT=8880' -e 'PORT1=8881' -e 'PORT2=8882' -e 'PORT3=8883' -e 'C9_USER=<YOURUSER>' -e 'C9_PASSWORD=<YOURPASS>' -e 'IP=0.0.0.0' -e 'C9_PARAMS=-p 80' -v /home/ide/workspaces/test/:/workspace/ testc9
    
