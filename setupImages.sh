project_name=strato
#eval $(minishift docker-env)
oc login -u vmadmin -p $TOKEN_PASS
ocr_ip="$(oc get svc -n default | grep docker-registry | awk '{print $2}'):5000"
#docker login -u admin -p $(oc whoami -t) 172.30.1.1:5000
echo $ocr_ip
docker login -u vmadmin -p $(oc whoami -t) ${ocr_ip}

## tag images
for image in $(docker images --format {{.Repository}}:{{.Tag}} | grep registry-aws.blockapps.net:5000/blockapps-repo)
do
  image_name=${image##*/}              ## getting last part of the image name:tag
  image_name=${image_name%%:*}         ## extracting name from name:tag
  echo tag image: $image as ${ocr_ip}/${project_name}/blockapps-${image_name}:latest
  docker tag $image ${ocr_ip}/${project_name}/blockapps-${image_name}:latest
done

for image in redis:3.2 postgres:9.6
do
 echo tag image: $image         ## extracting name from name:tag
 image_name=${image%%:*}         ## extracting name from name:tag
 echo $image

 if [ "$image" == "postgres:9.6" ]; then
   image_name="postgres-cirrus"
   echo $image_name
 fi

  docker tag  $image ${ocr_ip}/${project_name}/blockapps-$image_name:latest
done

#push images
for image in postgres-cirrus redis silo-smd-ui silo-bloch silo-blockapps-docs silo-cirrus silo-strato silo-kafka silo-nginx silo-postgres silo-postgrest
do
 echo push image: $image
  docker push ${ocr_ip}/${project_name}/blockapps-$image:latest
done
