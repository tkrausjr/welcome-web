# Dockerfile used to doweaload latest Source for Conference App
# and build a new Docker Image with default Entrypoint
# Listening on port TCP 8080

# Use Official Go UBUNTU Jessie or Alpine Secure Image as the base image.

# FROM golang:1.8.4-jessie
FROM golang:1.8.5-alpine3.6

MAINTAINER  TKraus 

# Create a directory inside the container to store our go web app and
# make it working directory.
RUN mkdir -p /go/src/go-welcome-web
WORKDIR /go/src/go-welcome-web

# Copy the go-http directory into the container.
COPY . /go/src/go-welcome-web

# Download and install third party dependencies into the container.
RUN go-wrapper download 
RUN go-wrapper install 

# Set the PORT environment variable
ENV PORT 8080

# Expose port 8080 to the host so that outer-world can access your application
EXPOSE 8080

# Tell Docker what command to run when the container starts
CMD ["go-wrapper", "run"]
