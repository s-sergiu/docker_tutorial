FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add gcc git make vim sudo gdb valgrind zsh musl-dev py3-pip python3 tzdata
RUN adduser --disabled-password -g "Sergiu Ster" ssergiu
RUN echo "ssergiu:parola" | chpasswd
RUN echo 'ssergiu ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
RUN su - ssergiu -c "pip install --user pygments norminette"
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
