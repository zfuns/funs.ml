#!/data/data/com.termux/files/usr/bin/bash

# input validator and help

case "$1" in
	f24_arm)
	    DOCKERIMAGE=http://download.fedoraproject.org/pub/fedora/linux/releases/24/Docker/armhfp/images/Fedora-Docker-Base-24-1.2.armhfp.tar.xz
	    ;;
	f25beta_arm)
	    DOCKERIMAGE=http://dl.fedoraproject.org/pub/fedora/linux/releases/test/25_Beta/Docker/armhfp/images/Fedora-Docker-Base-25_Beta-1.1.armhfp.tar.xz
            ;;
	f25beta_arm64)
	    DOCKERIMAGE=http://download.fedoraproject.org/pub/fedora-secondary/releases/25/Docker/aarch64/images/Fedora-Docker-Base-25-1.3.aarch64.tar.xz
	    ;;
	卸载)
	    chmod -R 0755 ~/fedora
	    rm -rf ~/fedora
	    rm -f ~/termu-fedora.sh
	    rm -f /data/data/com.termux/files/usr/bin/startfedora
	    exit 0
            ;;
	*)
	    apt install toilet
	    toilet -f mono12 -F metal Fedora
	    echo -e "\033[33m用法:\033[32m $0 {f24_arm|f25beta_arm|f25beta_arm64|卸载}\033[0m"
	    exit 2
esac


# install necessary packages

apt update && apt install proot tar -y

# get the docker image

mkdir ~/fedora
cd ~/fedora
echo -e "\033[32m 下载镜像中... \033[0m"
wget $DOCKERIMAGE -O fedora.tar.xz

# extract the Docker image

tar xvf fedora.tar.xz --strip-components=1 --exclude json --exclude VERSION

# extract the rootfs

tar xpf layer.tar

# cleanup

chmod +w .
rm layer.tar
rm fedora.tar.xz

# 设置 DNS

echo "nameserver 119.29.29.29" >> ~/fedora/etc/resolv.conf
echo "nameserver 182.254.116.116" >> ~/fedora/etc/resolv.conf
echo "nameserver 123.207.137.88" >> ~/fedora/etc/resolv.conf
echo "nameserver 74.125.41.5" >> ~/fedora/etc/resolv.conf
echo "nameserver 8.8.8.8" >> ~/fedora/etc/resolv.conf
echo "nameserver 8.8.4.4" >> ~/fedora/etc/resolv.conf
echo "nameserver 114.114.114.114" >> ~/fedora/etc/resolv.conf
echo "nameserver 114.114.114.115" >> ~/fedora/etc/resolv.conf

# make a shortcut

cat > /data/data/com.termux/files/usr/bin/startfedora <<- EOM
#!/data/data/com.termux/files/usr/bin/bash
proot --link2symlink -0 -r ~/fedora -b /dev/ -b /sys/ -b /proc/ -b $HOME /bin/env -i HOME=/root TERM="$TERM" PS1='[termux@fedora \W]\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
EOM

chmod +x /data/data/com.termux/files/usr/bin/startfedora

# all done

echo -e "\033[32m 全部完成 \033[0m"
echo -e "\033[32m 启动fedora的命令'startfedora'. 获取更新的命令 'dnf update' \033[0m"
