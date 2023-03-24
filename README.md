# Docker Tutorial


Follow the steps from this tutorial on Medium - 
[Docker Tutorial](https://medium.com/google-cloud/introduction-to-docker-and-kubernets-on-gcp-with-hands-on-configuration-part-1-docker-3d9709ee9f6a)

by Vaibhav Khullar

# Setup

STEP 1  - google-shell ... mkdir and clone repo
```
> mdkir docker_tutorial  
> cd docker tutorial
> git clone https://github.com/manbobo2002/docker.git
```

STEP 2  - Run Auth Login ... follow instructions
```

```

STEP 3 - setup cloud-shell environment ... all are in ./setup.sh   
```
> gcloud auth login
> gcloud config set project alg-analytics-247823  
> gcloud config set compute/zone us-central1-a  
> gcloud config set compute/region us-central1  
```

STEP 4  ... if node is not already installed, test with > node -v
https://cloud.google.com/nodejs/docs/setup  
```
> nvm install stable
    Downloading and installing node v19.8.1...
    Downloading https://nodejs.org/dist/v19.8.1/node-v19.8.1-linux-x64.tar.xz...
    ################################################################################################################################## 100.0%
    Computing checksum with sha256sum
    Checksums matched!
    Now using node v19.8.1 (npm v9.5.1)
> nvm alias default stable
    default -> stable (-> v19.8.1)
> node -v
    v19.8.1
```

npm is the Node Package Manager for Node.js and is normally installed alongside Node.js. You use npm to install Node.js packages from the npm repository. For example:

```
npm install --save express
```


# Test app.js on cloud-shell


run the app
```
> node app.js
    Server running at http://127.0.0.1:8080/
```

In another terminal
```
> curl localhost:8080
    Hello World
```

# Deploy Application with Docker


Dockerfile   
```
    # Use the node image with version 13.12
    FROM node:13.12

    # Set working directory in the container to /app
    WORKDIR /app

    # Copy current directory into the container at /app
    ADD . /app

    # Ensure the port 8080 of container is open to the outside world
    EXPOSE 8080
    # Open port 9000 for TCP
    EXPOSE 9000

    # Using node and run app.js
    CMD ["node", "app.js"]
```

Five Steps  
1. pull the Docker image with specified version. 
2. set the working directory in the container. 
3. copy the current directory into the container. Note that “.” means the current directory. 
4. Then we open the port 8080 of container. 
5. And finally we run the node command to kick start the app.js application


Build the Docker File

The command flag -t means to name and tag an image i.e. name:tag. By default, the tag will be “latest” if we don’t specify a tag.

Notice also "." the PATH (to the docker build artifacts) is a required input

```
> docker build . -t node-app:1.0 
    [+] Building ... 
```

check the image
```
> docker images
    REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
    node-app     1.0       7bac268f5519   3 minutes ago   943MB
```

node-app is the image we just built. If we want to remove node image, we have to remove node-app image because node-app makes use of node image

next step is to run the image
```
>  docker run -p 5000:8080 --name app-demo node-app:1.0
    Server running at http://127.0.0.1:8080/
```

The -p means to map the localhost port 5000 to the container port 8080 i.e. localhost port:container port. Then the --name flag gives a name to the container.

Now we curl it to check that it is running

```
> curl localhost:5000
    Hello World
```

# Enter to Docker Container
As I mentioned before, someone may say Docker is a micro VM. It is not accurate but not totally wrong. In fact, we could “enter” the container we created. Suppose we want to enter my app-demo2 container, we type:

```
> docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                              NAMES
6b284b535973   node-app:1.0   "docker-entrypoint.s…"   18 minutes ago   Up 18 minutes   9000/tcp, 0.0.0.0:5000->8080/tcp   app-demo

```

container id = 6b284b535973 
TCP port 9000

```
> docker exec -it 6b284b535973 bash
    root@6b284b535973:/app# 
    root@6b284b535973:/app# ls
        Dockerfile  README.md  app.js  docker_git_clone  setup.sh 
    root@6b284b535973:/app# exit   
```

# Clean Up Docker Containers

```
> docker ps -q
    6b284b535973
> docker ps -aq
    6b284b535973
```

```
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
```