# netvirt-ha-docker

Run an ODL cluster on a single machine with these scripts.

Each ODL instance will run in its own docker container. Each container will mount its own
overlay mount of your netvirt/karaf/target/assembly directory. This means that (a) all three
containers share your single set of files comprising for e.g., the netvirt distribution, (b) the changes 
that each container makes to these files will _not_ be propogated back to your assembly directory, 
(c) changes that each container makes are stored separately, on the _host_ filesystem so that they
can easily be inspected. Each container's files are stored `./mounts/[1|2|3]/assembly` where 
[1|2|3] corresponds to the index of each container.

Three running (and empty) netvirt containers have been observed to occupy about 1.3GB of memory each.

Currently following projects are supported:
1. Netvirt
2. Genius
3. OVSDB Southbound
4. HWVTEP Southbound
5. Neutron

## What scripts are provided

Script Name         | Description
--------------------|------------
**build**           | builds the overlay mounts for each container and the Docker image
**up**              | configures the dedicated docker network used by the ODL containers (if it does not already exist) and launches the containers (but does not run ODL)
**start**           | starts the ODL instances inside the containers
**wait-for-active** | Wait for the cluster to be active
**wipe**            | completely deletes the docker containers
**diagstatus**      | Convenience script to check whether an ODL is up and running using the diagstatus URL
**shell**           | Convenience script to run commands or a shell on one of the containers
**karaf-client**    | Convenience script to run karaf commands or a karaf shell on one of the containers

## Understanding the Environment

These scripts will create and configure three containers:

Name           | IP         | Overlay Directory
---------------|------------|-------------------
odl_172.28.5.1 | 172.28.5.1 | ./mounts/1/assembly
odl_172.28.5.2 | 172.28.5.2 | ./mounts/2/assembly
odl_172.28.5.3 | 172.28.5.3 | ./mounts/3/assembly

The containers are networked together like this:

```
+----------------------------------------------------+
|                    HOST MACHINE                    |
|                                                    |
|    +------------+                                  |
|    | odl_       |                                  |
|    | 172.28.5.1 |----+                             |
|    +------------+    |                             |
|                      |                             |
|    +------------+    |                             |
|    | odl_       |----+--bridge: 172.28.5.254       |
|    | 172.28.5.2 |    |                             |
|    +------------+    |                             | 
|                      |                             |
|    +------------+    |                             |
|    | odl_       |----+                             |
|    | 172.28.5.1 |                                  |
|    +------------+                                  |
+----------------------------------------------------+
```

## How to...

### Before you start

1. You must have docker installed
2. pull the fedora image, `docker pull fedora:latest`
3. You must have your project cloned and project/karaf fully built (but not run)
4. Make sure selinux is temporarily disabled via `sudo setenforce 0` (check with `sestatus | grep mode`; re-enable later with `sudo setenforce 1`)

Note that all scripts must be run from the root directory of this project (where this README file is).

### Creating the containers

1. Build the overlay mounts and docker image: `./build <path to your project clone>`. For OVSDB Southbound or HWVTEP
   the path should be '<path to ovsdb clone>/southbound|hwvtepsouthbound'.
   
   N.B. that running this script will remove and erase any mount directories from previous runs. If you want to save logs, copy them aside.
   
2. Launch the docker containers: `./up`

### Running ODL
To start all ODLs running simply say:
  
  `./start`

Then just wait for `./wait-for-active` to exit.
  
**However**, since the initialization of ODL/karaf is extremely heavy it is best
to just bring up two containers at first and only once they're up and running
the third.

  `./start 1 2`

Then wait for diagstatus to be ACTIVE (this can take a while):

  `./diagstatus 1`

  `./diagstatus 2`

  N.B. that OVSDB projects currently don't support diagstatus, so you will have to check for OVSDB port [6640].

Only then should you

  `./start 3`

### Get into a container and debug stuff
You can enter the shell of a running container like this:

  `./shell 1` (or 2 or 3...you get the idea)

### Run a command on a container
Execute a command on a running container:

  `./shell 1 ps ax`

### Run a command on all three containers
to execute a command on all three containers use the letter 'a' instead of a container index:

  `./shell a find --name karaf.log

### Open a karaf client on one of the containers

  `./karaf-client 1` (or 2 or 3)

### Execute karaf commands on one of the containers

  `./karaf-client 1 feature:list`

### Execute a karaf command on all containers

  `./karaf-client a log:set DEBUG org.opendaylight.genius

### Forcefully remove the containers
To completely kill and wipe your running containers simply say `"./wipe"`
