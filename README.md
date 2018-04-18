# REPO IS DEPRECATED: 
Please, use [https://github.com/blockapps/strato-openshift](https://github.com/blockapps/strato-openshift) for the latest updates

# BlockApps-OpenShift

These commands basically get the images from the BlockApps repo and then push them to OpenShift repo. Then we create a project called `strato` (the name is fixed for now) and spin up deployments.

## Openshift cluster

1. ssh to master node.

2. clone this repo and from the repo directory run:
 ```
 ./deploy_strato.sh
 ```

3. Follow the white rabbit.

## Minishift local

1. Run minishift VM, set docker and oc environment for the terminal session with commands:
 ```
 eval $(minishift oc-env)
 eval $(minishift docker-env)
 ```

2. clone this repo and from the repo directory run:
 ```
 ./deploy_strato_minishift.sh
 ```

## Dashboard
Visit the nginx hostname in your browser to open STRATO Dashboard (in Openshift Console select `STRATO` project, then Applications > Routes).

Credentials to access the Dashboard:
Openshift cluster: `admin/<password_you_set_on_deployment>`
Minishift local: `admin/admin`