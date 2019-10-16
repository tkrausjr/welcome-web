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
* (Optional) Log in to new repository
  * docker login harbor.tpmlab.vmware.com -u admin
* Tag the newly built image
  * docker tag welcome-web:latest harbor.tpmlab.vmware.com/library/welcome-web:latest
* Push the newly built image.
  * docker push harbor.tpmlab.vmware.com/library/welcome-web:latest

## Run the site in Kubernetes Cluster
* Create a Deployment with the Image 
  * kubectl run conference-app --replicas=2 --labels="run=conference-app" --image=tkrausjr/conference-app:latest --port=8080
* Create an externally accessible Service for the Deployment
  * kubectl expose deployment conference-app --type=NodePort --name=conference-app
* Get NodePort: Value  (Ex. 32449 )
  * kubectl describe services conference-app
* Get node name ( Ex. vm-c7d7773d-fd57-4efa-b8aa-14c405dde4cb)
  * kubectl get nodes 
* Get IP  (Ex. 10.190.64.71) 
  * kubectl describe node vm-c7d7773d-fd57-4efa-b8aa-14c405dde4cb
* Now you can test access at http://<ExternalIP>:<NodePort>
  * Chrome http://10.190.64.71:32449
  * curl http://10.190.64.71:32449

## Run the site locally right from the local REPO.
* $ cd /Users/kraust/Documents/go-workspace/src/github/demo-app
* $ go run conference-app.go

## Test
* Note the PORT the server is Listening on:
* Open Chrome and navigate to http://localhost:<port>  Defaults to :8080 

## Update the Website Static Content
The App will serve the contents of the /public folder so to make canges to the Website you would update the contents of the ./public folder. In this case we are using the Open Source product HUGO so we change our site settings in this repo (https://github.com/tkrausjr/my-conference) and the output is put in a ./public folder which we can move over to the go-http repo.
* $ cp -R ./public ~/github/go-http/
