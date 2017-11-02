### RUN THESE. These basiaclly get the image from the BlockApps repo and then push it to OpenShift. Then we create a project called strato (the name is fixed for now) and then creates the project. The you create a route in nginx service and click on it (under Applications/Services). You will gte the dashboard

sh getImages.sh 
oc new-project strato
sh setupImages.sh
sh startup.sh


