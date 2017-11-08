#!/bin/bash
## CREATE STRATO PROJECT
##oc new-project $1 


oc login -u system:admin


### SAMAR - not sure we need these next 4 lines anymore
oc adm policy add-role-to-user system:image-builder developer 
oc adm policy add-role-to-user system:registry developer 
oc adm policy add-role-to-user admin developer 
oc login -u developer -p developer

# sets the docker env being used and login to minishift registry
###minishift docker-env

## AS DEV
oc secrets new docker-pull-secret-dev .dockerconfigjson=${HOME}/.docker/config.json 
oc secrets link default docker-pull-secret-dev --for=pull 


oc create -f blockapps.yml

