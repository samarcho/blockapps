project_name=strato
eval $(minishift docker-env)
##ocr_ip=172.30.1.1
ocr_ip=$(minishift openshift registry)
#docker login -u admin -p $(oc whoami -t) 172.30.1.1:5000
docker login -u admin -p $(oc whoami -t) ${ocr_ip}

## docker login -u admin -p eYX6gDJVZuJcDXGj9SQ4Y4nlXrHKADmrcLOjcxnWVDo 172.30.1.1:5000

## tag images
for image in $(docker images --format {{.Repository}}:{{.Tag}} | grep registry-aws.blockapps.net:5000/blockapps-repo)
do
  image_name=${image##*/}              ## getting last part of the image name:tag
  image_name=${image_name%%:*}         ## extracting name from name:tag
  echo tag image: $image as ${ocr_ip}/${project_name}/blockapps-${image_name}:latest
##  docker tag $image ${ocr_ip}:5000/${project_name}/blockapps-${image_name}:latest
  docker tag $image ${ocr_ip}/${project_name}/blockapps-${image_name}:latest
done

for image in zookeeper:3.4.9 redis:3.2 postgres:9.6
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
for image in postgres-cirrus zookeeper redis silo-smd-ui silo-bloch silo-blockapps-docs silo-cirrus silo-strato silo-kafka silo-nginx silo-postgres silo-postgrest silo-apex
do
 echo push image: $image
  docker push ${ocr_ip}/${project_name}/blockapps-$image:latest
done
