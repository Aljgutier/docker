# Docker Primer <!-- omit from toc -->



# Table of Contents  <!-- omit from toc -->
- [Docker Commands](#docker-commands)
- [Docker Run vs Docker Compose](#docker-run-vs-docker-compose)
- [Docker Run](#docker-run)
- [Docker Compose](#docker-compose)
- [Docker Bind Mounts and Volumes](#docker-bind-mounts-and-volumes)



# Docker Commands 


Stackoverflow 
https://stackoverflow.com/questions/33907835/docker-error-cannot-delete-docker-container-conflict-unable-to-remove-reposito
```
Save this answer.
There is a difference between docker images and docker containers. Check this SO Question.

In short, a container is a runnable instance of an image. which is why you cannot delete an image if there is a running container from that image. You just need to delete the container first.

docker ps -a                # Lists containers (and tells you which images they are spun from)

docker images               # Lists images 

dockder container ls        # list containners

docker rm <container_id>    # Removes a stopped container

docker rm -f <container_id> # Forces the removal of a running container (uses SIGKILL)

docker rmi <image_id>       # Removes an image 
                            # Will fail if there is a running instance of that image i.e. container

docker rmi -f <image_id>    # Forces removal of image even if it is referenced in multiple repositories, 
                            # i.e. same image id given multiple names/tags 
                            # Will still fail if there is a docker container referencing image

docker stop [OPTIONS] CONTAINER [CONTAINER...] Y

docker image prune -a --all # remove all images

docker system prune -a      # remove everything

docker container ls -a      # list containers including terminated
docker image ls             # list images
docker container rm <container_id>  # remove a container
docker image rm <image_id>   # remove an image

docker system prune -a      # remove everything
```

# Docker Run vs Docker Compose 
https://linuxhint.com/docker-run-vs-docker-compose/

The “docker-compose” and “docker run” commands are executed to create and run the containers. The key difference is the “docker run” command creates a single container. However, “docker-compose” can create, manage and run multiple containers simultaneously. 

# Docker Run
https://linuxhint.com/docker-run-vs-docker-compose/
 
Both “docker run” and “docker-compose” commands are used for a similar purpose to build and fire up the containers to containerize the application or services. The primary difference between these two commands is that the “docker run” command is a purely terminal-based command that executes the image to create a single container. 

**Docker Run**

**Step 1:** Make a Docker File

Dockerfile
```
FROM golang:1.8
WORKDIR /go/src/app
COPY main1.go .
RUN go build -o webserver .
ENTRYPOINT ["./webserver"]
```

**Step 2** Create an image with the docker build command

docker build -t go-image -f main1.dockerfile .

**Step 3:** Create and Start the container

docker run -d -p 8080:8080 go-image

The “-d” flag will execute the container in detached mode, and “-p” specifies the local host port to expose the container

**Step 3:** List all Containers

docker ps -a

**Step 4:**  Visit the assigned port
Visit the assigned port of the local host to check if the container is running or not:

in browser
```
localhost:8080
```

# Docker Compose
https://linuxhint.com/docker-run-vs-docker-compose/

While the “docker-compose” command reads instructions from the “docker-compose.yml” file and is used to manage and run multi-container applications. In other words, it can create and execute more than one container at a time

**Step 1:** Create “docker-compose.yml” File
First, create a file named “docker-compose.yml” file and configure the services required to execute. For instance, we have configured the following configurations:

**“services**”** - configure two different services, “web” and “web2”.

The **“web”** service uses the “main.dockerfile” to containerize and run the “main.go” program.

The **“web2”** service uses the “main1.dockerfile” to dockerize and execute the “main1.go” program.

**“ports”** key is utilized to specify the exposing port for the container. In our scenario, Docker will automatically 
assign the exposing port to the “web” service, and the **“web2”** service will expose on port 8080:

docker-compose.yml
```
version: "alpine"
services:
  web:
    build:
     dockerfile: main.dockerfile
    command: ["./webserver"]
    ports:
      - 8080
 
  web2:
    build:
     dockerfile: main1.dockerfile
    ports:
      - 8080:8080
```

**Step 2:** Start Containers

```
docker-compose up -d
```

**Step 3:** List the Containers

Here, you can see “web” is executing on port “62689” and “web2” is exposing on “8080”:

![Compose ps a](./images/compose_ps_a.png )



Step 4:  navigate the exposing ports of containers for verification:

![Localhost Containers](./images/compose_localhost_containers.png)


# Docker Bind Mounts and Volumes

Introduction to Docker Bind Mounts and Volumes
by Matt McElreath
https://4sysops.com/archives/introduction-to-docker-bind-mounts-and-volumes/

By design, Docker containers do not store persistent data. Any data written to a container's writable layer will no longer be available once the container stops running. Also, getting data written to a container back out of it for another process can be difficult. To solve the issue of persisting data from a container, Docker has two options.

Bind mounts: A bind mount is a file or folder stored anywhere on the container host filesystem, mounted into a running container. The main difference a bind mount has from a volume is that since it can exist anywhere on the host filesystem, processes outside of Docker can also modify it.

Volumes: Volumes are the preferred way to store persistent data Docker containers create or use. The host filesystem also stores volumes, similar to bind mounts. However, Docker completely manages them and stores them under C:\ProgramData\docker\volumes by default.

**Bind Mounts**

Originally, the only way to mount a *bind* mount to a container was to use the *-v* or *--volume* flag as follows. The first part (before the colon) specifies the location on the host file system, and the second part (after the colon) identifies the location within the container.

```
docker run –it --name bindmount -v c:\data:c:\shareddata microsoft/windowsservercore powershell
```

Docker 17.06 introduced the *--mount* flag for standalone containers. Docker recommends using *--mount* flag in favor of *-v* because *--mount* is more explicit and easier to use.

```
docker run -it --name bindmount --mount type=bind,source=c:\data,target=c:\shareddata microsoft/windowsservercore powershell
```

Notice the --mount flag uses key–value pairs separated by commas to specify the mount settings for this container, making it easier to see exactly what they're configuring.

When using the *‑‑mount* flag, the source folder must already exist on the container host. When using -v, if the directory does not exist, the command will create it automatically. If the directory does not exist when using *‑‑mount*, Docker with throw an error.

Specifying *-it* in my docker run command will drop me into a PowerShell prompt on my running container. Running a directory listing on the C:\ drive within the new container shows that I have a folder called shareddata.

**Volumes**

Let's start with creating a new volume. I'm going to go ahead and create one called logdata.

```
docker volume create logdata
```

Similar to the bind mount, we can use the --mount flag to specify a volume to mount to a new container called volume1.

```
docker run -it --name volume1 --mount type=volume,source=logdata,target=c:\logdata microsoft/windowsservercore powershell
```

From inside my new container, I should now see a folder on the C:\ drive called logdata, which currently has no data in it.