# Elsie-Dee Microservices

This repository contains a collection of all microservices used by Elsie-Dee.
From here one can with one command line clone all the repositories and / or
run ```docker-compose``` to start them in one go.

# Getting the Source

* ```git clone git@github.com:ekholabs/elsie-dee-microservices.git --recurse-submodules```

Usually the HEAD is attached to the reference commit. Just to get things a bit
simpler, checkout master from all submodules with the command below:

* ```git submodule foreach git checkout master```

# Using Git

The is no magic in using the submodules. All git commands work fine. However, one must
pay attention when pushing submodules changes towards git. Also it's important to
update the reference that the parent module has with the submodules.

Need help? Google is your friend.

# Docker Compose

Using ```docker-compose``` will start the containers based on the latest uploaded to
```hub.docker.com```. After cloning the repository run the following:

* ```docker-compose up -d --remove-orphans```

**Remark:** there is an issue with the way we are using Spring Retry. It is causing
problems with two containers not registering to Eureka. The workaround for now is:

* After running Docker Compose do:
  * Run ```docker ps```;
  * Copy the ID of the elsie-dee container;
  * Run ```docker restart [container_id]```
  * Copy the ID of the elsie-deetect container;
  * Run ```docker restart [container_id]```

If you now go to ```http://localhost:8083``` you will see the Eureka dashboard and all
applications registered to it.
