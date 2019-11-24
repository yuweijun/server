#!/bin/bash

timedatectl set-timezone Asia/Shanghai

apt update
apt install -y git shadowsocks nginx imagemagick nodejs npm rsync zsh make

mkdir /data

if [ $# -eq 0 ]; then
    rsync -av -e ssh root@4e00.com:/root/ /root/
    rsync -av -e ssh root@4e00.com:/data/ /data/
    rsync -av -e ssh root@4e00.com:/etc/nginx/ /etc/nginx/
    rsync -av -e ssh root@4e00.com:/etc/shadowsocks/ /etc/shadowsocks/
fi

## git config

groupadd git
useradd -m --shell /bin/zsh -g git git
usermod --password $(openssl passwd -1 git@4e00.com) git

git config --global user.name yu
git config --global user.email test.yu@gmail.com
git config --global push.default simple
git config --global core.editor vim
git config --global core.quotepath false
git config --global color.ui auto
git config --global color.branch.current yellow reverse
git config --global color.branch.local yellow
git config --global color.branch.remote green
git config --global color.diff.meta yellow bold
git config --global color.diff.frag magenta bold
git config --global color.diff.old red bold
git config --global color.diff.new green bold
git config --global color.status.added yellow
git config --global color.status.changed green
git config --global color.status.untracked cyan
git config --global log.date iso
git config --global alias.ll "log --pretty=format:'%C(yellow)%h %C(green)| %C(white)%ad %C(green)| %C(blue)%>(15,trunc)%an %C(green)| %C(green)%d %C(reset)%s'"

## BBR

apt install -y --install-recommends linux-generic-hwe-18.04
lsmod | grep bbr

## nginx

systemctl restart nginx.service

## shadowsocks

### should update config.json using ip in /etc/shadowsocks/config.json

systemctl restart shadowsocks.service

## sites

npm install -g pm2 bower hexo

if [ $# -eq 0 ]; then
    cd /data/shufabeitie && pm2 start processes.json
    cd /data/hexo && pm2 start processes.json
    exit 0
fi

