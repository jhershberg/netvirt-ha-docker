# netvirt-ha-docker

Run an ODL cluster on a single machine with these scripts. 
Each ODL instance will run in its own docker containers and
the scripts will take care of configuring the clustering.

## Before you start

1. You must have docker installed
2. pull the fedora image, docker pull fedora:latest
3. You must have netvirt cloned and netvirt/karaf fully built (but not run)

## Creating the containers

1. Build the docker image: ./build \<path to your netvirt clone\>
2. Launch the docker containers: ./up \<path to your netvirt clone\>

## Running netvirt
Since the initialization of netvirt/karaf is extremely heavy it is best
to just bring up two containers at first and only once they're up and running 
the third.

  ./start 1 2

Then wait for diagstatus to be ACTIVE (this can take a while):

  ./diagstatus 1

  ./diagstatus 2

Only then should you

  ./start 3

You can enter the shell of a running container like this:

  ./shell 1 (or 2 or 3...you get the idea)

To completely kill and wipe your running containers simply say "./wipe"
