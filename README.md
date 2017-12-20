# BlockApps-OpenShift
### RUN THESE. These basically get the image from the BlockApps repo and then push it to OpenShift. Then we create a project called strato (the name is fixed for now).

export TOKEN_PASS=<vmadmin passwd>

./getImages.sh (one time only)

oc new-project strato

./setupImages.sh

oadm policy add-scc-to-user anyuid -n strato -z default

./startup.sh

You will then click on the nginx route (under Applications/Services). You will get the dashboard and create users, send ether and create contracts.

Also add env Vars in *strato* deployment:
kafkaHost = kafka
zkHost = kafka

Pending : Need to fix the hardwired route in the env variables.
