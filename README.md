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

As part of the project you will also find 2 Docker Compose files: one used to start the base services (i.e. Eureka and the Configuration Server); and a second one which starts all other services.

In order to make life easier, I also provide a ```run.sh``` script, which will execute both file and get everything in place for you.

You don't need to clone the project, just download the two compose files and the script. The images will be pulled from hub.docker.

After running the script, go to ```http://localhost:8083```, you will see the Eureka dashboard. As the other services start, you will be able to see them registered to Eureka.

# Using Docker images

one can also start the container using the images available on ```hub.docker.com```. However, a container orchestrations
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
7. Elsie-Dee Search
   * ```docker run -p 8087:8087 --link eureka-service --link configuration-service --link elsie-dee-elastic --name=elsie-dee-search ekholabs/elsie-dee-search```
   * Elsie-Dee Search depends on elsie-dee-elastic container. This container uses an elasticsearch:2.4 image, which is part of the Docker Compose file. In order to run the elsie-dee-elastic container manually, execute the following command:
     - ```docker run -p 9200:9200 -p 9300:9300 -e "http.host=0.0.0.0" -e "transport.host=0.0.0.0" -e discovery.zen.minimum_master_nodes=1 --name=elsie-dee-elastic elasticsearch:2.4```
8. Stream Services
   * ```docker run -d -p 8088:8088 --name=stream-services ekholabs/stream-services```
9. Elsie-Dee
   * ```docker run -d -p 80:80 --link configuration-service --link eureka-service --link elsie-deetect --link elsie-deesight --link elsie-dee-audiorip --link stream-services ekholabs/elsie-dee```
