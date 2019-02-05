

# enter remote session
Enter-PSSession CN1-NUG


## Container Networking ##

# view networks
docker network ls

# view default nat network details
docker network inspect nat

# start a container
docker run -dt nuglab/iis

# start a container with port mapping
docker run -dt -p 8080:80 nuglab/iis

# create a transparent network
docker network create -d transparent -o com.docker.network.windowsshim.interface="Ethernet 4" --subnet=192.168.1.0/24 --gateway=192.168.1.1 tpnet

# start a container on tpnet
docker run -dt --network=tpnet --ip=192.168.1.130 --dns=192.168.1.100 microsoft/windowsservercore


## Container Data Volumes ##

# create a persistent data volume
docker volume create nugdata

# start containers using data volume
docker run --name web1 -dt -v nugdata:c:\data nuglab/iis
docker run --name web2 -dt -v nugdata:c:\data nuglab/iis

# send command into container
docker exec <name_or_id> powershell dir c:\

# view data volumes
docker volume ls

# mount host dir into container
docker run --name web3 -dt -v c:\nuggetlab:c:\mounted nuglab/iis

# send command into container
docker exec <name_or_id> powershell dir c:\


## Container Resource Control ##

# view docker run help
docker run --help

# limit memory & cpu
docker run -dt --memory 512m --cpu-percent 25 nuglab/iis


## Dockerfile - Image Automation ##

# build image from dockerfile
docker tag nuglab/iis nuglab/iis:1.0
docker build -t nuglab/iis .
docker run -dt -p 8080:80 nuglab/iis:latest

## Dockerhub - Image Repo ##

# login to dockerhub
docker login

# push image to nuglab/iis repo
docker push nuglab/iis:latest