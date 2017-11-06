eval $(minishift docker-env)
##ocr_ip=172.30.1.1
ocr_ip=$(minishift openshift registry)
#docker login -u admin -p $(oc whoami -t) 172.30.1.1:5000
docker login -u admin -p $(oc whoami -t) ${ocr_ip}

docker login -u blockapps-repo -p P@ssw0rd registry-aws.blockapps.net:5000
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-bloch:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-blockapps-docs:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-cirrus:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-kafka:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-nginx:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-apex:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-postgres:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-postgrest:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-smd-ui:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-strato:latest
docker pull zookeeper:3.4.9
docker pull redis:3.2
docker pull  postgres:9.6
