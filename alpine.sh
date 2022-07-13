#!/bin/zsh
#
docker run -it  --dns 8.8.8.8 --dns 8.8.4.4 --workdir="/home/ssergiu" -e "OSTYPE=alpine" -e "SHELL=/bin/zsh" -e "TERM=xterm-256color" -e "HOSTNAME=alpine" --user=ssergiu --privileged=true --hostname=alpine -v $PWD:/home/ssergiu alpine:ssergiu "/bin/zsh"
