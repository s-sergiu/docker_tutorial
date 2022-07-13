## Install Alpine Linux using docker

From what I've read so far, you can use Docker to create a Linux virtual environment from where you can mount your home directory and start working inside it (coding, debugging, valgrind leak checking and so on..).

If you don't have docker installed on your mac you just need to type command + space and type "Managed Software Center" and from there on just search for docker and click on the install button.

After that you need to clone the 42toolbox repository and run docker everytime you want to run it by executing the init_docker.sh file.

To create a linux image in docker first we need to create a directory called whatever you want to call it and create a Dockerfile inside it.
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
