#!/bin/bash
HOME_DIRS="/home"
echo $HOME_DIRS
for i in $HOME_DIRS/*; do
        cp /etc/skel/.bashrc "$i"/
done
cp /etc/skel/.bashrc /root/
