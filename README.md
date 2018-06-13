# gemfire-docker

# prerequisite

1.You need to download a gemfire 9.x installer(zip version) from pivotal network, then put this zip file under `gemfireproductlist` folder.
For example:

`pivotal-gemfire-9.2.0.zip`

ps:
https://network.pivotal.io/products/pivotal-gemfire#/releases/8052

2.Tested with `Docker Community Edition for Mac 18.05.0-ce-mac66`

https://docs.docker.com/docker-for-mac/install/

# Building the container image
The current Dockerfile is based on a ubuntu:14.04 image + JDK8u172 + Gemfire9.2.0.

Run the below command to compile the dockerfile to build the image:
```
docker build . -t gemfire92:0.1
```

```
XXXXXnoMacBook-puro:gemfire9X user1$ docker build . -t gemfire92:0.1
Sending build context to Docker daemon  99.41MB
Step 1/29 : FROM ubuntu:14.04
 ---> a35e70164dfb
Step 2/29 : MAINTAINER XXXXX <xxxxxxxx@gmail.com>
 ---> Using cache
 ---> 41d7e7ca62e6
Step 3/29 : ENV JAVA_VERSION 8u172
 ---> Using cache
 ---> c1f5f732dc76
Step 4/29 : ENV BUILD_VERSION b11
 ---> Using cache
 ---> e1c40acbe4f1
Step 5/29 : ENV JAVA_SUB_VERSION 172
 ---> Running in 9e5f04482d55
Removing intermediate container 9e5f04482d55
..............
Step 26/29 : COPY workdir /opt/pivotal/workdir
 ---> cf0c7e02befd
Step 27/29 : COPY lab21.truststore lab21.truststore
 ---> 4c7af81d5873
Step 28/29 : EXPOSE  8080 10334 40404 40405 1099 7070
 ---> Running in 028846849ad3
Removing intermediate container 028846849ad3
 ---> d08a2291bb65
Step 29/29 : VOLUME ["/opt/pivotal/workdir/"]
 ---> Running in 79106f0baf0c
Removing intermediate container 79106f0baf0c
 ---> 2cd825cca150
Successfully built 2cd825cca150
Successfully tagged gemfire92:0.1
```

# Login into container

Run the below command to run the container instance(you need to modify the volume directory according to your machine's path):
```
docker run -it -h pivhdsne.localdomain -v /Users/user1/Downloads/workshop/volume_folder:/opt/pivotal/workdir -p 10334:10334 -p 7070:7070 -p 1099:1099 -p 8080:8080 gemfire92:0.1 bash
```
or

You can also run without any volume mapping if you don't want reuse the persistence files which generated from the container.
```
docker run -it -h pivhdsne.localdomain -p 10334:10334 -p 7070:7070 -p 1099:1099 -p 8080:8080 gemfire92:0.1 bash
```

# Start locator and cacheserver from container:
```
root@pivhdsne:/opt/pivotal/workdir# ./startLocator.sh 
..
Locator in /opt/pivotal/workdir/locator on pivhdsne.localdomain[10334] as locator is currently online.
Process ID: 54
Uptime: 1 minute 1 second
Geode Version: 9.2.0
Java Version: 1.8.0_172
Log File: /opt/pivotal/workdir/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dpulse.Log-File-Name=pulse9.2.log -Dpulse.Log-File-Location=. -Dpulse.Log-Level=fine -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /opt/pivotal/pivotal-gemfire-9.2.0/lib/geode-core-9.2.0.jar:/opt/pivotal/pivotal-gemfire-9.2.0/lib/geode-dependencies.jar

Successfully connected to: JMX Manager [host=pivhdsne.localdomain, port=1099]

Cluster configuration service is up and running.
```
```
root@pivhdsne:/opt/pivotal/workdir# ./startServer1.sh 
.....
Server in /opt/pivotal/workdir/server1 on pivhdsne.localdomain[40404] as server1 is currently online.
Process ID: 193
Uptime: 5 seconds
Geode Version: 9.2.0
Java Version: 1.8.0_172
Log File: /opt/pivotal/workdir/server1/server1.log
JVM Arguments: -Dgemfire.locators=pivhdsne.localdomain[10334] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -Dgemfire.mcast-port=0 -Dgemfire.cache-xml-file=/opt/pivotal/workdir/server1/Server.xml -Dgemfire.statistic-archive-file=server1.gfs -XX:OnOutOfMemoryError=kill -KILL %p -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /opt/pivotal/pivotal-gemfire-9.2.0/lib/geode-core-9.2.0.jar:/opt/pivotal/pivotal-gemfire-9.2.0/lib/gfsh-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.2.0/lib/geode-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.2.0/lib/gfsh-dependencies.jar:/opt/pivotal/workdir/classes::/opt/pivotal/pivotal-gemfire-9.2.0/lib/geode-dependencies.jar
```
```
root@pivhdsne:/opt/pivotal/workdir# ./startServer2.sh 
.......
Server in /opt/pivotal/workdir/server2 on pivhdsne.localdomain[40405] as server2 is currently online.
Process ID: 343
Uptime: 8 seconds
Geode Version: 9.2.0
Java Version: 1.8.0_172
Log File: /opt/pivotal/workdir/server2/server2.log
JVM Arguments: -Dgemfire.locators=pivhdsne.localdomain[10334] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -Dgemfire.mcast-port=0 -Dgemfire.cache-xml-file=/opt/pivotal/workdir/server2/Server.xml -Dgemfire.statistic-archive-file=server2.gfs -XX:OnOutOfMemoryError=kill -KILL %p -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /opt/pivotal/pivotal-gemfire-9.2.0/lib/geode-core-9.2.0.jar:/opt/pivotal/pivotal-gemfire-9.2.0/lib/gfsh-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.2.0/lib/geode-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.2.0/lib/gfsh-dependencies.jar:/opt/pivotal/workdir/classes::/opt/pivotal/pivotal-gemfire-9.2.0/lib/geode-dependencies.jar

```

```
root@pivhdsne:/opt/pivotal/workdir# gfsh
    _________________________     __
   / _____/ ______/ ______/ /____/ /
  / /  __/ /___  /_____  / _____  / 
 / /__/ / ____/  _____/ / /    / /  
/______/_/      /______/_/    /_/    9.2.0

Monitor and Manage Pivotal GemFire
gfsh>connect --locator=localhost[10334]
Connecting to Locator at [host=localhost, port=10334] ..
Connecting to Manager at [host=pivhdsne.localdomain, port=1099] ..
Successfully connected to: [host=pivhdsne.localdomain, port=1099]

Cluster-1 gfsh>list members
 Name   | Id
------- | -------------------------------------------
locator | 172.17.0.2(locator:54:locator)<ec><v0>:1024
server1 | 172.17.0.2(server1:192)<v1>:1025
server2 | 172.17.0.2(server2:343)<v2>:1026

Cluster-1 gfsh>list regions
List of regions
----------------------
exampleRegion
exampleRegionPar1
exampleRegionRep1
exampleRegion_previous
tradeInstruction
```

# Login into Pulse UI with local browser

Open a internet browser with the below URL to access Pulse. 

http://localhost:7070/pulse/

<img src="https://github.com/GSSJacky/gemfire-docker/blob/master/pulse.png" 
alt="Pulse UI" width="480" height="360" border="10" /> <img src="https://github.com/GSSJacky/gemfire-docker/blob/master/cluster_image.png" 
alt="Gemfire Cluster Info" width="480" height="360" border="10" />

# start a new gfsh container to access with gemfire cluster:

1.confirm the mac host's ip address such as `10.34.138.201` by ifconfig command.

2.Open a new mac terminal console to run the below command:
```
docker run -it gemfire92:0.1 gfsh
```

```
JackynoMacBook-puro:~ jackyxu$ docker run -it gemfire92:0.1 gfsh
    _________________________     __
   / _____/ ______/ ______/ /____/ /
  / /  __/ /___  /_____  / _____  / 
 / /__/ / ____/  _____/ / /    / /  
/______/_/      /______/_/    /_/    9.2.0

Monitor and Manage Pivotal GemFire
gfsh>connect --locator=10.34.138.201[10334]
Connecting to Locator at [host=10.34.138.201, port=10334] ..
Connecting to Manager at [host=172.17.0.2, port=1099] ..
Successfully connected to: [host=172.17.0.2, port=1099]

Cluster-1 gfsh>list members
 Name   | Id
------- | -------------------------------------------
locator | 172.17.0.2(locator:54:locator)<ec><v0>:1024
server1 | 172.17.0.2(server1:193)<v1>:1025

Cluster-1 gfsh>list regions
List of regions
----------------------
exampleRegion
exampleRegionPar1
exampleRegionRep1
exampleRegion_previous
tradeInstruction
```

# How to remove this image

```
JackynoMacBook-puro:gemfire9X jackyxu$ docker images | grep gemfire92
gemfire92                                                0.1                  c078d7129bea        20 hours ago        1.5GB
```

```
JackynoMacBook-puro:gemfire9X jackyxu$ docker rmi -f c078d7129bea
Untagged: gemfire92:0.1
Deleted: sha256:c078d7129bead6c1c0865e0f33a26e832c678d1d36107afb7790e39e1f0856cd
Deleted: sha256:3b222d33d7987c426d532ea09fe123d8d5bffa5c75ae73244498e515b41e28f8
Deleted: sha256:f7550ecb871f8485fc86be354d5dc72bd82b017b298c20369c07a5186a94c1f5
Deleted: sha256:3b1f78c03530d5f40cdf7fc5ee81449ff3cf383ddbecee43baf1ecf84cbfb6d9
Deleted: sha256:434c7d3e0fe42e4eb88e536c1c775ef690c2088187b360429a018c0876d218e2
```
