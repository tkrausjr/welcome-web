# go-welcome-web

# Simple HTTP Server using Go net/http module
* Tested on OSX 10.12.6 and go 1.9

## Install Go
* This is not necessary as we will use a golang base container in our Dockerfile.

## Application Build Step
High Level is checkout the REPO to get the Dockerfile and run a "docker build". The Dockerfile will set a GO WORKDIR and copy the REPO Source from the Docker Host to the Container using Docker COPY an
then a GO Install inside the Container.

(Docker or Build Host)
* Checkout the Repo.
  * git clone https://github.com/tkrausjr/welcome-web.git
  * cd ./welcome-web
* Build the Go Binaries from Src.
  * docker build -t welcome-web .
* SHOW Build Output
  * docker images
* Test Locally:
  * docker run -p 8080:8080 --name="welcome-web-1" -d welcome-web:latest


## Push the Image to a new Repository
NOTE: This will require to have the CA Cert for the Registry to Root of Trust. IN PKS, you can copy the Opsman CA Cert to /etc/docker/certs.d/harbor.tpmlab.vmware.com/ca.crt   and restart docker daemon.
* (Optional) Log in to new repository
  * docker login harbor.tpmlab.vmware.com -u admin
* Tag the newly built image
  * docker tag welcome-web:latest harbor.tpmlab.vmware.com/library/welcome-web:latest
* Push the newly built image.
  * docker push harbor.tpmlab.vmware.com/library/welcome-web:latest

## Run the site in Kubernetes Cluster
* Create a Deployment with the Image 
  * kubectl run welcome-web --replicas=2 --labels="run=welcome-web" --image=harbor.tpmlab.vmware.com/library/welcome-web:latest --port=8080
* Create an externally accessible Service for the Deployment
  * kubectl expose deployment welcome-web --type=LoadBalancer --name=welcome-web
* Get Deployment Status
  * k get deploy
  * NAME          READY   UP-TO-DATE   AVAILABLE   AGE
  * welcome-web   2/2     2            2           65s
* Get Service LB EXTENRAL-IP  (Ex. 10.190.64.71) 
  * kubectl get svc
  * NAME              TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
  * kubernetes        ClusterIP      10.100.200.1     <none>        443/TCP          5d19h
  * welcome-web       LoadBalancer   10.100.200.109   10.51.0.23    8080:32629/TCP   2m32s
* Now you can test access at http://<EXTERNAL-IP>:8080
  * Chrome 10.51.0.23:8080
  * curl 10.51.0.23:8080

## Run the site locally right from the local REPO.
* $ cd /Users/kraust/Documents/go-workspace/src/github/demo-app
* $ go run conference-app.go

## Test
* Note the PORT the server is Listening on:
* Open Chrome and navigate to http://localhost:<port>  Defaults to :8080 


