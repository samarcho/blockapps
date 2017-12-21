#!/bin/bash
## CREATE STRATO PROJECT
##oc new-project $1 


oc login -u system:admin


oc adm policy add-role-to-user system:image-builder vmadmin 
oc adm policy add-role-to-user system:registry vmadmin 
oc adm policy add-role-to-user admin vmadmin 
oc login -u vmadmin -p $TOKEN_PASS 


oc secrets new docker-pull-secret-dev .dockerconfigjson=${HOME}/.docker/config.json 
oc secrets link default docker-pull-secret-dev --for=pull 


oc create -f blockapps.yml

