## Install Alpine Linux using docker

From what I've read so far, you can use Docker to create a Linux virtual environment from where you can mount your home directory (your Mac's home directory) and start working inside it (coding, debugging, valgrind leak checking and so on..).

If you don't have docker installed on your mac you just need to type `command + space`and type `"Managed Software Center"` and from there on just search for docker and click on the install button.

After that you need to clone the 42toolbox repository and run docker everytime you want to run it by executing the **init_docker.sh** file.
```git
git clone https://github.com/alexandregv/42toolbox.git ~/42toolbox
```

###Creating a linux image (Alpine):
To create a linux image in docker first we need to create a directory called **docker_image** and create a Dockerfile inside it.
Inside this dockerfile we will tell docker the instructions to build our linux image as follows:
```dockerfile
FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add gcc git make vim sudo gdb valgrind zsh musl-dev py3-pip python3 tzdata
RUN adduser --disabled-password -g "Name Surname" 42user
RUN echo "42user:42password" | chpasswd
RUN echo '42user ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
RUN su - 42user -c "pip install --user pygments norminette"
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```
The **FROM** instruction initializes a new build stage and sets the Base Image for subsequent instructions. As such, a valid Dockerfile must start with a FROM instruction. The image can be any valid image.  

`FROM alpine:latest`
basically pulls the latest alpine linux image so it can build from it;

```dockerfile
RUN apk update
RUN apk upgrade
RUN apk add gcc git make vim sudo gdb valgrind zsh musl-dev py3-pip python3 tzdata
```
these three commands updates alpine package manager repositories and updates available programs if needed
after that it installs the needed programs for you to be able to compile and check your executable for leaks with valgrind
you can also add whatever extra things you might want instead of installing manually after attaching to the docker container

```dockerfile
RUN adduser --disabled-password -g "Name Surname" 42user
RUN echo "42user:password" | chpasswd
RUN echo '42user ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
```
the first command adduser does exactly what it supposed to do, adds a user to your Alpine linux image (make sure you replace user with your username and add your name inbetween double quotes.
in the second line you just need to **replace **42use** with your username and add an easy to remember password instead of the word **42password** **
third line just adds the user to the sudoers group using echo piped to visudo

```dockerfile
RUN su - 42user -c "pip install --user pygments norminette"
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```
Last but not least this installs norminette and pygments for gdb syntax highlighting and sets your timezone to Berlin's timezone, so you'll have synced clock


After that you just make sure you're into your home directory (use cd) and type:
`docker build -t alpine:42 docker_image/`

Wait for docker to finish building your image.

###Running script to get inside the Linux container:
After docker succesfully built your Alpine Linux image, create a shell script and add the following to it:

```shell
#!/bin/zsh
#
docker run -it  --dns 8.8.8.8 --dns 8.8.4.4 --workdir="/home/42user" -e "OSTYPE=alpine" -e "SHELL=/bin/zsh" -e "TERM=xterm-256color" -e "HOSTNAME=alpine" --user=42user --privileged=true --hostname=alpine -v $PWD:/home/42user alpine:42user "/bin/zsh"
```


Make sure you have execute permission on it chmod +x and run it afterwads.

You are now logged in your docker Linux container and you've mounted the mac's home directory into the alpine linux's home directory.
