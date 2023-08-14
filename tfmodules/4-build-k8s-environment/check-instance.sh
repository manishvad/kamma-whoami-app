#!/bin/bash

echo "Check docker is running ..."
`which docker > /dev/null 2>&1 &`
if [ $? -ne 0 ]; then
  echo “Error: docker not running - check ec2 instance”
  exit 1
else
  echo "docker running :)"
fi

echo "Check minikube is running ..."
`which minikube > /dev/null 2>&1 &`
if [ $? -ne 0 ]; then
  echo “Error: minikube not running - check minikube instance”
  exit 1
else
	echo "minikube running :)"
fi

DIR="/home/ec2-user/kamma-k8-manifest-files"
if [ -d "$DIR" ]; then
   echo "'$DIR' found and please wait ..."
else
   echo "Warning: '$DIR' git repo NOT found."
   echo "Cloning git repo kamma-k8-manifest-files"
   `cd /home/ec2-user`
   `git clone https://github.com/manishvad/kamma-k8-manifest-files.git`
fi

# retrieve an authentication token and authenticate your Docker client to your registry
echo "Get ecr auth token & authenticate ..."
`aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 521231545277.dkr.ecr.eu-west-1.amazonaws.com > /dev/null 2>&1 &`
if [ $? -ne 0 ]; then
  echo “Error: failed to get ecr and authenticate token”
  exit 1
else
  echo "Got ecr token & authenticated :)"
fi
