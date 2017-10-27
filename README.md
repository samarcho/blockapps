# BlockApps-OpenShift
You will need to get access to BlockApps bu going through the Getting Started website.
Then follow the instructions and log into their repository. Note that you need to login
since the startup script (below) will use that in the secret. Just run the startup.sh file
with the project-name as an argument. There are some glitches and the deployment may need
to be started manually which is good as we need to deploy in a particular order:

1. Zookeeper, Kafka, postgres, redis, cirrus, posgrest,
2. strato
3. bloch 
4. strato, smd-ui 
5. nginx 

Create a route for the nginx component using the UI. Just look at the "services" and click on the "nginx" service. Leave the defaults. Click on the route link and you will get the login for the dashboard.

Pending : To fix the actual demo, we need to fix up the paths.
