## Clean up after Docker
After many build and run sessions with Dockerfiles, you’ll be mostly left with a few left-over containers, unneeded mounts and exited images. Especially if you don’t use the ‘rmi’ flag when running docker build.

### Find out how many images Docker has on a system

You can always inspect which images are currently clogging up your system by running ``docker images`` and ``docker ps -a`` for containers.

### Remove temporary built images

In order to quickly get rid of any images that aren’t needed anymore, simply run

``` bash
docker images -notrunc| grep none | awk '{print $3}' | xargs -r docker rmi
```

* This will print out all images docker has, without truncating their IDs.
* Filter through such that have the identifier ‘none’ in the output.
* Grab their IDs
* And run the docker ‘remove image’ command, if any such images were given out ( ``xargs -r`` only runs if output was passed along )

### Remove Docker containers with Exit status

The same counts for any left-over containers which already have the Exit status :

```
docker ps -a -notrunc | grep 'Exit' | awk '{print $1}' | xargs -r docker rm
```

### Reduce Googles’ and our pageload, save your time – create an alias

Now since we use those commands here very frequently, it’s best to simply add those as aliases to your ~/.bashrc. ( Or – even better! – to your dotfiles; so you have them handy on any server you’re working on )

```
alias dockercleancontainers="docker ps -a -notrunc| grep 'Exit' | awk '{print \$1}' | xargs -L 1 -r docker rm"
alias dockercleanimages="docker images -a -notrunc | grep none | awk '{print \$3}' | xargs -L 1 -r docker rmi"
alias dockerclean="dockercleancontainers && dockercleanimages"
```

Now every time you went through some longer build and run testing sessions, simply run dockerclean to get rid of the leftovers.

#### Reference:

* http://blog.stefanxo.com/2014/02/clean-up-after-docker/
