## Install Alpine Linux using docker

From what I've read so far, you can use Docker to create a Linux virtual environment from where you can mount your home directory and start working inside it (coding, debugging, valgrind leak checking and so on..).

If you don't have docker installed on your mac you just need to type command + space and type "Managed Software Center" and from there on just search for docker and click on the install button.

After that you need to clone the 42toolbox repository and run docker everytime you want to run it by executing the init_docker.sh file.

To create a linux image in docker first we need to create a directory called **docker_image** and create a Dockerfile inside it.
Inside this dockerfile we will tell docker the instructions to build our linux image as follows:
```dockerfile
FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add gcc git make vim sudo gdb valgrind zsh musl-dev py3-pip python3 tzdata
RUN adduser --disabled-password -g "Sergiu Ster" ssergiu
RUN echo "ssergiu:parola" | chpasswd
RUN echo 'ssergiu ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
RUN su - ssergiu -c "pip install --user pygments norminette"
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```
>_The FROM instruction initializes a new build stage and sets the Base Image for subsequent instructions. As such, a valid Dockerfile must start with a FROM instruction. The image can be any valid image – it is especially easy to start by pulling an image from the Public Repositories._

After that you just make sure you're into your home directory (use cd) and type:
docker build -t alpine:42 docker_image/

Wait for docker to finish building your image.

After docker succesfully built your Alpine Linux image, create a shell script and add the following to it:

```shell
#!/bin/zsh
#
docker run -it  --dns 8.8.8.8 --dns 8.8.4.4 --workdir="/home/ssergiu" -e "OSTYPE=alpine" -e "SHELL=/bin/zsh" -e "TERM=xterm-256color" -e "HOSTNAME=alpine" --user=ssergiu --privileged=true --hostname=alpine -v $PWD:/home/ssergiu alpine:ssergiu "/bin/zsh"
```

Make sure you have execute permission on it chmod +x and run it afterwads.

You are now logged in your docker Linux container and you've mounted the mac's home directory into the alpine linux's home directory.
