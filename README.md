# SteamCMD

This repository is actually for my personal use to create steam server using steamcmd in Docker, and also if you want to create the same thing like i do, you can use this repository too. 

This repository is almost same with the original **[steamcmd/docker](https://github.com/steamcmd/docker)** but this repo is more like what i need.

For detailed information about SteamCMD, see the official [wiki](https://developer.valvesoftware.com/wiki/SteamCMD). If you are looking for a programmatic way to retrieve information via SteamCMD, have a look at [steamcmd.net](https://www.steamcmd.net).

## Getting Started

### Prerequisite

**Required:**

1. `docker` >= 20.10.22
2. `docker-compose` >= 2.15.1

**Optional**

1. `node` >= 20.9.0
2. `yarn` >= 1.19.1

**note:** _`yarn` is used when building the custom image, you can also use `npm`, but i recommend you to use `yarn` because i use that when developing and using this repo_

### Using Default User and Group

#### Linux

First you'll need to create new user to prevent permission issue, i'll need you to create user and group with id: `2300` and name `steamcmd`, you can use following script to create new user and group :

```shell
# adding new group
$ sudo groupadd -g 2300 steamcmd; 

# adding new user and add user into the group
$ sudo -m -u $USER_ID -g steamcmd steamcmd;
```

#### Windows

```
N/A
```

### Using custom User and Group

You can build your own docker images using following command without change the `Dockerfile`:

```shell
# command:
$ docker build --build-arg="USER_ID=[user_id]" --build-arg="USER_NAME=[user_name]" --build-arg="GROUP_ID=[group_id]" --build-arg="GROUP_NAME=[group_name]" --file="Dockerfile" --tag="[docker_tag]:[version]" .

# example:
$ docker build --build-arg="USER_ID=2300" --build-arg="USER_NAME=steamcmd" --build-arg="GROUP_ID=2300" --build-arg="GROUP_NAME=steamcmd" --file="Dockerfile" --tag="fathalfath30/steamcmd:latest" .
```

or if you wanted to build using yarn (i recommend you to use this, so you don't need to change the Dockerfile) by editing the `package.json` and change the user and group value from `package.json`:

```json
{
    "config": {
      "docker": {
        "file": "./Dockerfile",
        "compose": "./docker-compose.yaml",
        "tag": "fathalfath30/steamcmd",
        "version": "latest",
        "user": {
            "id": "2300",
            "name": "steamcmd"
        },
        "group": {
            "id": "2300",
            "name": "steamcmd"
        }
      }
    }
}
```

If you are prefer use node to build docker image you can use this command
```shell
# linux 
$ yarn docker:linux:build

# windows
$ yarn docker:windows:build
```


## Contributing
```
TBA
```

## License

Distributed under the MIT License. See `LICENSE` for more information.