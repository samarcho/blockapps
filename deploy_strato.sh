#!/usr/bin/env bash

set -e

read -p "Enter the Openshift username (the one you use to login to web console'): " username

read -sp "Enter the Openshift user password: " password
echo "
"

read -p "Enter infra public IP: " PUBLIC_IP

read -sp "Enter the new password for STRATO dashboard access: " UI_PASSWORD

cp blockapps.tpl.yml blockapps.yml
sed -i -e 's/__public_ip__/'"${PUBLIC_IP}"'/g' blockapps.yml
sed -i -e 's/__ui_password__/'"${UI_PASSWORD}"'/g' blockapps.yml

export project_name=strato

# GRANT PERMISSIONS, LOGIN
oc login -u system:admin
oc adm policy add-scc-to-user anyuid -n ${project_name} -z default
oc adm policy add-role-to-user admin ${username}
# Unnecessary permissions - we keep here just in case
#oc adm policy add-role-to-user system:image-builder ${username}
#oc adm policy add-role-to-user system:registry ${username}

oc login -u ${username} -p ${password}

oc new-project ${project_name}

#GET IMAGES
sudo docker login -u blockapps-repo -p P@ssw0rd registry-aws.blockapps.net:5000
sudo docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-bloch:7bbd197
sudo docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-blockapps-docs:ebc2107
sudo docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-cirrus:277150b
sudo docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-nginx:0c2ab39
sudo docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-postgrest:04fc86b
sudo docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-smd-ui:821da75
sudo docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-strato:f341b5e
sudo docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-apex:228caf4
sudo docker pull redis:3.2
sudo docker pull postgres:9.6
sudo docker pull spotify/kafka:latest

# SETUP IMAGES
export ocr_ip="$(oc get svc -n default | grep docker-registry | awk '{print $2}'):5000"
sudo docker login -u $(oc whoami) -p $(oc whoami -t) ${ocr_ip}

## tag images
for image in $(sudo docker images --format {{.Repository}}:{{.Tag}} | grep registry-aws.blockapps.net:5000/blockapps-repo)
do
  image_name=${image##*/}              ## getting last part of the image name:tag
  image_name=${image_name%%:*}         ## extracting name from name:tag
  echo tag image: $image as ${ocr_ip}/${project_name}/blockapps-${image_name}:latest
  sudo docker tag $image ${ocr_ip}/${project_name}/blockapps-${image_name}:latest
done

for image in redis:3.2 postgres:9.6 spotify/kafka:latest
do
 echo tag image: $image
 image_name=${image%%:*} # extracting name from name:tag

 if [ "$image" = "spotify/kafka:latest" ]; then
   image_name="kafka"
   echo $image_name
 fi

  sudo docker tag $image ${ocr_ip}/${project_name}/blockapps-$image_name:latest
done

#push images
for image in postgres redis kafka silo-smd-ui silo-apex silo-bloch silo-blockapps-docs silo-cirrus silo-strato silo-nginx silo-postgrest
do
  echo push image: $image
  sudo docker push ${ocr_ip}/${project_name}/blockapps-$image:latest
done

#STARTUP
oc create -f blockapps.yml