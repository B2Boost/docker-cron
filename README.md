# Docker-Cron

Use [`Cron`](http://en.wikipedia.org/wiki/Cron) inside Docker. Looks for crontab at  `/cron/crontab`

**Note:** Does not use actual cron binary, as there are issues running it inside Docker.
Uses [devcron](https://bitbucket.org/dbenamy/devcron/src) instead. 

It is a fork of originally [hamiltont/docker-cron](https://github.com/hamiltont/docker-cron).
It has been first forked into [B2Boost/docker-cron](https://github.com/B2Boost/docker-cron)
Then I have set up a synchronization branch between github and Bitbucket:

    $ git clone git@github.com:B2Boost/docker-cron.git
    $ cd docker-cron
Create a synchrnonization branch `sync`. This branch will have remotes both on github and bitbucket.

    $ git checkout -b sync

Create a docker-cron repo on Bitbucket, and add it as origin for branch `sync`
    
    $ git remote add bitbucket ssh://git@bitbucket.org/B2Boost/docker-cron.git
    $ git remote -v                                                                                                        14:43  lmuniz@Chromos
    bitbucket       ssh://git@bitbucket.org/B2Boost/docker-cron.git (fetch)
    bitbucket       ssh://git@bitbucket.org/B2Boost/docker-cron.git (push)
    origin  https://github.com/B2Boost/docker-cron.git (fetch)
    origin  https://github.com/B2Boost/docker-cron.git (push)

Push sync branch to both remotes:

    $ git push -u bitbucket sync
    $ git push -u origin sync


This will allow us to track changes in the original repo through github's fork tracking, and through the sync branch, merge it into our bitbucket repo.

Finally add an automated build to create `b2boost/cron` from the Bitbucket `docker-cron` repository.

# Use

## Volumes
This example mounts the folder containing your crontab file. Presumably you would
put your scripts in the same file and reference them in your crontab as `/cron/myscript.sh`

    $ docker run -v /host/folder/containing/crontab:/cron -d hamiltont/docker-cron

This example mounts two folders, one with the crontab and one with the scripts. You need 
to use `/scripts/myscript.sh` in your `crontab`

    $ docker run -v /host/folder/containing/crontab:/cron -v /host/folder/scripts:/scripts -d hamiltont/docker-cron

##Dockerfile

You can also use a Dockerfile to include your own scripts without using volumes.
 
    FROM b2boost/cron
    
    ADD cron /cron
    ADD scripts /scripts
    
    RUN adduser --uid 1000 --gid 1000 --disabled-password --gecos "Cron user" --quiet my-cron-user
    USER my-cron-user

  
# Provided utilities

It contains a folder `/util`. It provides utility scripts. 

## `runEvery.sh`

Cron has a granularity of 1 minute. This script is intended to be used to run a cron task every `n` seconds. 

### Usage

* Echo Hello every 10 seconds, for one minute, then stop

    $ /util/runEvery.sh 10 "echo Hello"

* Run script `/scripts/task.sh` every second, for one minute, then stop

    $ /util/runEvery.sh 1 /scripts/task.sh


 
