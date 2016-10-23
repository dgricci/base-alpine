% Image de base pour alpine 3.4.4
% Didier Richard
% rév. 0.0.1 du 22/10/2016

---

# Building #

```bash
$ docker build -t dgricci/alpine:3.4.4 .
```

## Behind a proxy (e.g. 10.0.4.2:3128) ##

```bash
$ docker build \
    --build-arg http_proxy=http://10.0.4.2:3128/ \
    --build-arg https_proxy=http://10.0.4.2:3128/ \
    -t dgricci/alpine:3.4.4 .
```     

## Build command with arguments default values : ##

```bash
$ docker build \
    --build-arg GOSU_VERSION=1.10 \
    --build-arg GOSU_DOWNLOAD_URL=https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64 \
    -t dgricci/alpine:3.4.4 .
``` 

# Use #

This image may use :

* USER_ID : the user identifier under which the container is launched. It is
assumed that the user's group is the same when USER_GP is not given. If not
given, root is used as usual when runnning the container ;
* USER_GP : the user's group identifier to which the user belongs. Defaults to
USER_ID ;
* USER_NAME : possibly, the name of this user ! Defaults to `xuser` when not
given.

The USER_ID argument allows files created in the container to belong to this
user (id) and not to root (by default) which can cause problems when sharing
volumes between user's space and the container.

## Tests ##

* No information about the user running the container :

```bash
$ docker run -it --rm dgricci/alpine /bin/sh
/ # whoami
root
/ # exit
```

* Just give the user's id (same as the current) :

```bash
$ docker run -it --rm -e USER_ID=`id -u` dgricci/alpine /bin/sh
/ $ whoami
xuser
/ $ tail -1 /etc/group
xuser:x:1000:
/ $ tail -1 /etc/passwd
xuser:x:1000:1000:Linux User,,,:/home/xuser:/bin/sh
/ $ exit
```

* Let's add the group's id :

```bash
$ docker run -it --rm -e USER_ID=`id -u` -e USER_GP=2000 dgricci/alpine /bin/sh
/ $ whoami
xuser
/ $ tail -1 /etc/group
xuser:x:2000:xuser
/ $ tail -1 /etc/passwd
xuser:x:1000:2000:Linux User,,,:/home/xuser:/bin/sh
/ $ exit
```

* Then we add the user's name :

```bash
$ docker run -it --rm -e USER_ID=`id -u` -e USER_GP=2000 -e USER_NAME=dgricci dgricci/alpine /bin/sh
/ $ whoami
dgricci
/ $ tail -1 /etc/group
dgricci:x:2000:dgricci
/ $ tail -1 /etc/passwd
dgricci:x:1000:2000:Linux User,,,:/home/xuser:/bin/sh
/ $ exit
```

* And finally, let's use the debug option :

```sh
$ docker run -it --rm -e USER_DEBUG=1 -e USER_ID=$UID -e USER_GP=`id -g` -e USER_NAME=$USER dgricci/alpine /bin/sh
Starting container as 'ricci' (1000:1000)
/ $ whoami
ricci
/ $ tail -1 /etc/group
ricci:x:1000:
/ $ tail -1 /etc/passwd
ricci:x:1000:1000:Linux User,,,:/home/ricci:/bin/sh
/ $ exit
```

__Et voilà !__


_fin du document[^pandoc_gen]_

[^pandoc_gen]: document généré via $ `pandoc -V fontsize=10pt -V geometry:"top=2cm, bottom=2cm, left=1cm, right=1cm" -s -N --toc -o base-alpine.pdf README.md`{.bash}

