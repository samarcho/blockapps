ocr_ip=$(oc get svc -n default | grep docker-registry | awk '{print $2}')
docker login -u admin -p $(oc whoami -t) ${ocr_ip}:5000

docker login -u blockapps-repo -p P@ssw0rd registry-aws.blockapps.net:5000
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-bloch:d24b87f
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-blockapps-docs:ebc2107
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-cirrus:d9d20d3
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-kafka:96db9ff
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-nginx:0664e62
#docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-postgres:750b87e
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-postgres:latest
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-postgrest:ae5c1c5
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-smd-ui:25cac97
docker pull registry-aws.blockapps.net:5000/blockapps-repo/silo-strato:kafka-zk-strato
docker pull redis:3.2
docker pull  postgres:9.6

# ENABLE CORS IN OPENSHIFT
