#!/usr/bin/env bash

set -e

# SET PERMISSIONS FOR 'developer' USER
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin developer

username=developer

read -p "Enter minishift VM IP (e.g. 192.168.64.1):  " PUBLIC_IP
#PUBLIC_IP=192.168.64.4

UI_PASSWORD=admin

cp blockapps.tpl.yml blockapps.yml
sed -i -e 's/__public_ip__/'"${PUBLIC_IP}"'/g' blockapps.yml
sed -i -e 's/__ui_password__/'"${UI_PASSWORD}"'/g' blockapps.yml
export project_name=strato

#LOGIN
oc login -u ${username}

oc new-project ${project_name}

oc adm policy add-scc-to-user anyuid -n ${project_name} -z default
oc adm policy add-role-to-user system:image-builder ${username}
oc adm policy add-role-to-user system:registry ${username}
oc adm policy add-role-to-user admin ${username}
oc adm policy add-role-to-user cluster-admin ${username}

#GET IMAGES
docker login -u blockapps-repo -p P@ssw0rd registry-aws.blockapps.net:5000
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-bloch:7bbd197
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-blockapps-docs:ebc2107
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-cirrus:277150b
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-nginx:0c2ab39
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-postgrest:04fc86b
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-smd-ui:821da75
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-strato:f341b5e
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-apex:228caf4
docker pull redis:3.2
docker pull postgres:9.6
docker pull spotify/kafka:latest

# SETUP IMAGES
export ocr_ip="$(oc get svc -n default | grep docker-registry | awk '{print $2}'):5000"
docker login -u $(oc whoami) -p $(oc whoami -t) ${ocr_ip}

## tag images
for image in $(docker images --format {{.Repository}}:{{.Tag}} | grep registry-aws.blockapps.net:5000/blockapps-repo)
do
  image_name=${image##*/}              ## getting last part of the image name:tag
  image_name=${image_name%%:*}         ## extracting name from name:tag
  echo tag image: $image as ${ocr_ip}/${project_name}/blockapps-${image_name}:latest
  docker tag $image ${ocr_ip}/${project_name}/blockapps-${image_name}:latest
done

for image in redis:3.2 postgres:9.6 spotify/kafka:latest
do
 echo tag image: $image
 image_name=${image%%:*} # extracting name from name:tag

 if [ "$image" = "spotify/kafka:latest" ]; then
   image_name="kafka"
   echo $image_name
 fi

  docker tag $image ${ocr_ip}/${project_name}/blockapps-$image_name:latest
done

#push images
for image in postgres redis kafka silo-smd-ui silo-apex silo-bloch silo-blockapps-docs silo-cirrus silo-strato silo-nginx silo-postgrest
do
  echo push image: $image
  docker push ${ocr_ip}/${project_name}/blockapps-$image:latest
done

#STARTUP
oc create -f blockapps.yml