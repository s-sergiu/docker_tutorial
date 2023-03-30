#!/bin/bash
me=`basename "$0"`
NEWVAR=${PWD#/Users/}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

VAR="/home/${NEWVAR}"

if grep -q "alias archlinux=" $HOME/.bashrc; then
    echo found
else
	echo "alias archlinux=${SCRIPTPATH}/${me}" >> $HOME/.bashrc 
fi

docker run -it  --dns 8.8.8.8 --dns 8.8.4.4 --workdir=$VAR -e "DEBUGINFOD_URLS=https://debuginfod.archlinux.org" -e "OSTYPE=archlinux" -e "SHELL=/bin/bash" -e "TERM=xterm-256color" -e "HOSTNAME=archlinux" --user=ssergiu --privileged=true --hostname=archlinux -v $HOME:/home/ssergiu archlinux:ssergiu 
