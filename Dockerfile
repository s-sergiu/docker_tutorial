FROM archlinux:latest

RUN pacman -Syy
RUN echo "Y" | pacman -Syu
RUN echo "Y" | pacman -S gcc git make vim sudo gdb valgrind zsh glibc python-pip python3 tzdata mariadb
RUN useradd -m -G users -s /bin/bash ssergiu
RUN echo "ssergiu:parola" | chpasswd
RUN echo 'ssergiu ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
RUN su - ssergiu -c "pip install --user pygments norminette"
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
