# Install Alpine Linux using docker

* [1. Getting docker up and running](#1getting-docker-up-and-running)
* [2. Creating a linux image (Alpine) using dockerfile:](#2creating-a-linux-image-alpine-using-dockerfile)
  * [a.Building a docker image with the Dockerfile:](#a-building-a-docker-image-with-the-dockerfile)
* [3. Running the script to get inside the linux container](#2running-the-script-to-get-inside-the-linux-container)

From what I've read so far, you can use Docker to create a Linux virtual environment from where you can mount your home directory (your Mac's home directory) and start working inside it (coding, debugging, valgrind leak checking and so on..).

## 1.Getting docker up and running:
If you don't have docker installed on your mac you just need to type `command + space`and type `"Managed Software Center"` and from there on just search for docker and click on the install button.

After that you need to clone the 42toolbox repository and start docker everytime by executing the **init_docker.sh** file.
```git
git clone https://github.com/alexandregv/42toolbox.git ~/42toolbox
```
```shell
bash ~/42toolbox/init_docker.sh
```

 * #### After you execute the init_docker.sh just press enter and you will get a message saying that docker is now starting.  

![bash_docker_run](/images/docker_init.png)
![bash_docker_done](/images/docker_init_after.png)


 * Make sure you click on remind me later if you're using 42Macs, you don't want to install updates for docker, **click remind me later**.  


![docker_update_reminder](/images/docker_update_reminder.png)


 * After that you can go to your docker icon in the top right corner of your screen and you can click it to see if docker is running or not.  


![docker_icon_starting](/images/docker_icon_starting.png)



 * A green circle with the message "Docker is running" should appear, meaning that docker is now up and running.  


![docker_icon_running](/images/docker_icon_running.png)


 * After that just type `docker images` in your console to see if you already have the images installed.   
 * If so just skip to chapter 2 of this tutorial ["Running script to get inside linux container:"](#2running-the-script-to-get-inside-the-linux-container).   


![docker_images_full](/images/docker_images_full.png)


## 2.Creating a linux image (Alpine) using dockerfile:

To create a linux image in docker first we need to create a directory called **docker_image** and create a Dockerfile inside it.
Inside this dockerfile we will tell docker the instructions to build our linux image as follows:



```dockerfile
FROM archlinux:latest

RUN pacman -Syy
RUN echo "Y" | pacman -Syu
RUN echo "Y" | pacman -S gcc git make vim sudo gdb valgrind zsh glibc python-pip python3 tzdata mariadb
RUN useradd -m -G users -s /bin/bash ssergiu
RUN echo "ssergiu:parola" | chpasswd
RUN echo 'ssergiu ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
RUN su - ssergiu -c "pip install --user pygments norminette"
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```


>The **FROM** instruction initializes a new build stage and sets the Base Image for subsequent instructions. As such, a valid Dockerfile must start with a FROM instruction. The image can be any valid image.  

`FROM alpine:latest`
basically pulls the latest alpine linux image so it can build from it;



```dockerfile
RUN apk update
RUN apk upgrade
RUN apk add gcc git make vim sudo gdb valgrind zsh musl-dev py3-pip python3 tzdata
```

 * the first two commands updates alpine package manager repositories and updates available programs if needed
 * after that it installs the needed programs for you to be able to compile and check your executable for leaks with valgrind
 * you can also add whatever extra things you might want instead of installing manually after attaching to the docker container



```dockerfile
RUN adduser --disabled-password -g "Name Surname" 42user
RUN echo "42user:password" | chpasswd
RUN echo '42user ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
```
 * the first command adduser does exactly what it supposed to do, adds a user to your Alpine linux image (make sure you replace 42user with your username and add your name inbetween double quotes.   

 * in the second line you just need to replace **42user** with your username and add an easy to remember password instead of the word **42password**  

 * third line just adds the user to the sudoers group using echo piped to visudo    




```dockerfile
RUN su - 42user -c "pip install --user pygments norminette"
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```
 * Last but not least this installs norminette and pygments for gdb syntax highlighting and sets your timezone to Berlin's timezone, so you'll have synced clock


After that you just make sure you're into your home directory (use cd) and type:

### a. Building a docker image with the Dockerfile:



```shell
docker build -t alpine:42 docker_image/
```

Wait for docker to finish building your image.



## 2.Running the script to get inside the Linux container: 

After docker succesfully built your Alpine Linux image, create a shell script and add the following to it:



```shell
#!/bin/zsh
#
docker run -it  --dns 8.8.8.8 --dns 8.8.4.4 --workdir="/home/ssergiu" -e "DEBUGINFOD_URLS=https://debuginfod.archlinux.org" -e "OSTYPE=archlinux" -e "SHELL=/bin/bash" -e "TERM=xterm-256color" -e "HOSTNAME=archlinux" --user=ssergiu --privileged=true --hostname=archlinux -v $PWD:/home/ssergiu archlinux:ssergiu "/bin/bash"
```


Make sure you have execute permission on it chmod +x and run it afterwads.

You are now logged in your docker Linux container and you've mounted the mac's home directory into the alpine linux's home directory.
