#!/usr/bin/bash

sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp sources.list /etc/apt/sources.list

sudo apt update && sudo apt update && sudo apt upgrade && sudo apt autoremove
sudo apt install nano git zsh curl wget tree htop tmux screen can-utils net-tools openssh-server python3-pip
