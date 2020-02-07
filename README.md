# gemfire-docker

# prerequisite

1.You need to download a gemfire 9.x installer(tgz version) from pivotal network, then put this tgz file under `gemfireproductlist` folder.
For example:

`pivotal-gemfire-9.9.1.tgz`

ps:
https://network.pivotal.io/products/pivotal-gemfire#/releases/535421


2.Tested with `Docker Community Edition for Mac 18.05.0-ce-mac66`

https://docs.docker.com/docker-for-mac/install/

3.Built with Oracle JDK: Java SE Development Kit 8u241

https://download.oracle.com/otn/java/jdk/8u241-b07/1f5b5a70bf22433b84d0e960903adac8/jdk-8u241-linux-x64.tar.gz

ps:
Please note that you need to modify the jdk version accordingly from dockerfile once the Oracle JDK download link changed by Oracle. 

# Building the container image
The current Dockerfile is based on a ubuntu:16.04 image + JDK8u241 + Gemfire9.9.0.

Run the below command to compile the dockerfile to build the image:
```
docker build . -t gemfire991:0.1
```

```
XXXXXnoMacBook-puro:gemfire9X user1$ docker build . -t gemfire991:0.1
Sending build context to Docker daemon  118.9MB
Step 1/28 : FROM ubuntu:16.04
16.04: Pulling from library/ubuntu
0a01a72a686c: Pull complete 
cc899a5544da: Pull complete 
19197c550755: Pull complete 
716d454e56b6: Pull complete 
Digest: sha256:3f3ee50cb89bc12028bab7d1e187ae57f12b957135b91648702e835c37c6c971
Status: Downloaded newer image for ubuntu:16.04
 ---> 96da9143fb18
Step 2/28 : MAINTAINER XXXXXX <xxxxxx@gmail.com>
 ---> Running in 7c7a6d28b75d
Removing intermediate container 7c7a6d28b75d
 ---> dbfd5244657b
Step 3/28 : ENV JAVA_VERSION 8u241
 ---> Running in 0d7fbec9b1b2
Removing intermediate container 0d7fbec9b1b2
 ---> 82394b5c8f13
Step 4/28 : ENV BUILD_VERSION b07
 ---> Running in 3a5c32c82a83
Removing intermediate container 3a5c32c82a83
 ---> e4fa06e7132e
Step 5/28 : ENV JAVA_SUB_VERSION 241
 ---> Running in 30bddae24df4
Removing intermediate container 30bddae24df4
 ---> a71497838e04
Step 6/28 : ENV JDK_HASH_VALUE 1f5b5a70bf22433b84d0e960903adac8
 ---> Running in 23155daa012d
Removing intermediate container 23155daa012d
 ---> b4e1895f94c9
Step 7/28 : ENV GEMFIREVERSION 9.9.1
 ---> Running in f71c066a396a
Removing intermediate container f71c066a396a
 ---> f7a9cc9c183d
Step 8/28 : WORKDIR /opt/pivotal
 ---> Running in a7f20aab55c2
Removing intermediate container a7f20aab55c2
 ---> 40639a2e8733
Step 9/28 : RUN apt-get update && apt-get install -y wget
 ---> Running in c36930f446cb
..............
Step 24/28 : ENV CLASSPATH $GEMFIRE/lib/geode-dependencies.jar:$GEMFIRE/lib/gfsh-dependencies.jar:/opt/pivotal/workdir/classes:$CLASSPATH
 ---> Running in f5cb94df5436
Removing intermediate container f5cb94df5436
 ---> 7a329bb996a3
Step 25/28 : COPY workdir /opt/pivotal/workdir
 ---> 2633128f4a98
Step 26/28 : EXPOSE  8080 10334 40404 40405 1099 7070
 ---> Running in 0463d4c13a3a
Removing intermediate container 0463d4c13a3a
 ---> dcb70a747552
Step 27/28 : VOLUME ["/opt/pivotal/workdir/storage"]
 ---> Running in 2cf5a51c1b92
Removing intermediate container 2cf5a51c1b92
 ---> fe885e3eebd7
Step 28/28 : WORKDIR /opt/pivotal/workdir
 ---> Running in 0a676646dfe5
Removing intermediate container 0a676646dfe5
 ---> 0431f7f09d9d
Successfully built 0431f7f09d9d
Successfully tagged gemfire991:0.1
```

# Login into container

Run the below command to run the container instance(you need to modify the volume directory according to your machine's path):
```
docker run -it -h pivhdsne.localdomain -v /Users/user1/Downloads/workshop/volume_folder:/opt/pivotal/workdir -p 10334:10334 -p 7070:7070 -p 1099:1099 -p 8080:8080 gemfire991:0.1 bash
```
or

You can also run without any volume mapping if you don't want reuse the persistence files which generated from the container.
```
docker run -it -h pivhdsne.localdomain -p 10334:10334 -p 7070:7070 -p 1099:1099 -p 8080:8080 gemfire991:0.1 bash
```

# Start locator and cacheserver from container:
```
root@pivhdsne:/opt/pivotal/workdir# ./startLocator.sh 
.........
Locator in /opt/pivotal/workdir/locator on pivhdsne.localdomain[10334] as locator is currently online.
Process ID: 49
Uptime: 14 seconds
Geode Version: 9.9.1
Java Version: 1.8.0_241
Log File: /opt/pivotal/workdir/locator/locator.log
JVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dpulse.Log-File-Name=pulse9.2.log -Dpulse.Log-File-Location=. -Dpulse.Log-Level=fine -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /opt/pivotal/pivotal-gemfire-9.9.1/lib/geode-core-9.9.1.jar:/opt/pivotal/pivotal-gemfire-9.9.1/lib/geode-dependencies.jar

Successfully connected to: JMX Manager [host=pivhdsne.localdomain, port=1099]

Cluster configuration service is up and running.
```
```
root@pivhdsne:/opt/pivotal/workdir# ./startServer1.sh 
.....
Server in /opt/pivotal/workdir/server1 on pivhdsne.localdomain[40404] as server1 is currently online.
Process ID: 141
Uptime: 7 seconds
Geode Version: 9.9.1
Java Version: 1.8.0_241
Log File: /opt/pivotal/workdir/server1/server1.log
JVM Arguments: -Dgemfire.locators=pivhdsne.localdomain[10334] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -Dgemfire.mcast-port=0 -Dgemfire.cache-xml-file=/opt/pivotal/workdir/server1/Server.xml -Dgemfire.statistic-archive-file=server1.gfs -XX:OnOutOfMemoryError=kill -KILL %p -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /opt/pivotal/pivotal-gemfire-9.9.1/lib/geode-core-9.9.1.jar:/opt/pivotal/pivotal-gemfire-9.9.1/lib/gfsh-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.9.1/lib/geode-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.9.1/lib/gfsh-dependencies.jar:/opt/pivotal/workdir/classes::/opt/pivotal/pivotal-gemfire-9.9.1/extensions/*:/opt/pivotal/pivotal-gemfire-9.9.1/lib/geode-dependencies.jar
```
```
root@pivhdsne:/opt/pivotal/workdir# ./startServer2.sh 
......
Server in /opt/pivotal/workdir/server2 on pivhdsne.localdomain[40405] as server2 is currently online.
Process ID: 259
Uptime: 10 seconds
Geode Version: 9.9.1
Java Version: 1.8.0_241
Log File: /opt/pivotal/workdir/server2/server2.log
JVM Arguments: -Dgemfire.locators=pivhdsne.localdomain[10334] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -Dgemfire.mcast-port=0 -Dgemfire.cache-xml-file=/opt/pivotal/workdir/server2/Server.xml -Dgemfire.statistic-archive-file=server2.gfs -XX:OnOutOfMemoryError=kill -KILL %p -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806
Class-Path: /opt/pivotal/pivotal-gemfire-9.9.1/lib/geode-core-9.9.1.jar:/opt/pivotal/pivotal-gemfire-9.9.1/lib/gfsh-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.9.1/lib/geode-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.9.1/lib/gfsh-dependencies.jar:/opt/pivotal/workdir/classes::/opt/pivotal/pivotal-gemfire-9.9.1/extensions/*:/opt/pivotal/pivotal-gemfire-9.9.1/lib/geode-dependencies.jar
```

```
root@pivhdsne:/opt/pivotal/workdir# gfsh
    _________________________     __
   / _____/ ______/ ______/ /____/ /
  / /  __/ /___  /_____  / _____  / 
 / /__/ / ____/  _____/ / /    / /  
/______/_/      /______/_/    /_/    9.9.1

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
```

# Login into Pulse UI with local browser

Open a internet browser with the below URL to access Pulse. 

http://localhost:7070/pulse/

<img src="https://github.com/GSSJacky/gemfire-docker/blob/master/cluster_image.png" 
alt="Gemfire Cluster Info" width="480" height="360" border="10" />

# start a new gfsh container to access with gemfire cluster:

1.confirm the mac host's ip address such as `10.34.138.201` by ifconfig command.

2.Open a new mac terminal console to run the below command:
```
docker run -it gemfire991:0.1 gfsh
```

```
XXXXXnoMacBook-puro:~ XXXXXX$ docker run -it gemfire991:0.1 gfsh
    _________________________     __
   / _____/ ______/ ______/ /____/ /
  / /  __/ /___  /_____  / _____  / 
 / /__/ / ____/  _____/ / /    / /  
/______/_/      /______/_/    /_/    9.9.1

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
```

# How to remove this image

```
XXXXnoMacBook-puro:gemfire9X XXXXXX$ docker images | grep gemfire991
gemfire991                                                0.1                  c078d7129bea        20 hours ago        1.5GB
```

```
XXXXXnoMacBook-puro:gemfire9X XXXXX$ docker rmi -f c078d7129bea
Untagged: gemfire991:0.1
Deleted: sha256:c078d7129bead6c1c0865e0f33a26e832c678d1d36107afb7790e39e1f0856cd
Deleted: sha256:3b222d33d7987c426d532ea09fe123d8d5bffa5c75ae73244498e515b41e28f8
Deleted: sha256:f7550ecb871f8485fc86be354d5dc72bd82b017b298c20369c07a5186a94c1f5
Deleted: sha256:3b1f78c03530d5f40cdf7fc5ee81449ff3cf383ddbecee43baf1ecf84cbfb6d9
Deleted: sha256:434c7d3e0fe42e4eb88e536c1c775ef690c2088187b360429a018c0876d218e2
```
