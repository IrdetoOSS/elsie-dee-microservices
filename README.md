# Elsie-Dee Microservices

This repository contains a collection of all microservices used by Elsie-Dee.
From here one can with one command line clone all the repositories and / or
run ```docker-compose``` to start them in one go.

For more details about the other micoservices, please check the submodules for specific
information.

# Getting the Source

* ```git clone git@github.com:ekholabs/elsie-dee-microservices.git --recurse-submodules```

Usually the HEAD is attached to the reference commit. To get things a bit
simpler, checkout master from all submodules with the command below:

* ```git submodule foreach git checkout master```

# Using Git

There is no magic in using the submodules. All git commands work fine. However, one must
pay attention when pushing submodules changes towards git. Also, it's important to
update the reference commit that the parent module has with the submodules.

Need help? Google is your friend.

# Docker Compose

Using ```docker-compose``` we can start the containers based on the latest changes on the source code.
After cloning the repository run the following:

* ```docker-compose up -d --remove-orphans```

**Remark:** there is an issue with the way we are using Spring Retry. It is causing
problems with containers not registering to Eureka due to dependency order. The workaround for now is:

* After running Docker Compose, do the following:
  * Run ```docker ps```;
  * Copy the ID of the elsie-deetect container;
  * Run ```docker restart [container_id]```
  * Copy the ID of the elsie-deesight container;
  * Run ```docker restart [container_id]```
  * Copy the ID of the elsie-deeaudiorip container;
  * Run ```docker restart [container_id]```
  * Copy the ID of the elsie-dee container;
  * Run ```docker restart [container_id]```

The Elsie-Dee container depends on the previous two, that's why we restart it as the last one.

If you now go to ```http://localhost:8083``` you will see the Eureka dashboard and all
applications registered to it.

# Using Docker images

Once can also start the container using the images available on ```hub.docker.com```. However, a container orchestrations
tool would help to manager all six containers.

The images can be found on: (ekholabs)[https://hub.docker.com/ekholabs]

Running the containers on the command line will require the following sequence (assuming one has pulled the images):

1. Eureka Service
   * ```docker run -d -p 8083:8083 --name=eureka-service ekholabs/eureka-service```
2. Configuration Service
   * ```docker run -d -p 8082:8082 --link eureka-service --name=configuration-service ekholabs/configuration-service```
3. Face Classification
   * ```docker run -d -p 8084:8084 --name=face-classifier ekholabs/face-classifier```
4. Elsie-Dee Sight
   * ```docker run -d -p 8085:8085 --link face-classifier --link configuration-service --link eureka-service --name=elsie-deesight ekholabs/elsie-deesight```
5. Elsie-Deetect
   * ```docker run -d -p 8080:8080 --link configuration-service --link eureka-service --name=elsie-deetect ekholabs/elsie-deetect```
6. Elsie-Dee Audio Rip
   * ```docker run -d -p 8086:8086 --link configuration-service --link eureka-service --name=elsie-dee-audiorip ekholabs/elsie-dee-audiorip```
7. Elsie-Dee
   * ```docker run -d -p 80:80 --link configuration-service --link eureka-service --link elsie-deetect --link elsie-deesight --link elsie-dee-audiorip ekholabs/elsie-dee```
