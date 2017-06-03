#!/data/data/com.termux/files/usr/bin/bash
folder=ubuntu
if [ -d "$folder" ]; then
    first=1
    echo "跳过下载..."
fi
if [ "$first" != 1 ];then
    if [ ! -f "ubuntu.tar.gz" ]; then
        echo "下载ubuntu镜像..."
        if [ "$(dpkg --print-architecture)" == "aarch64" ];then
            wget https://mirrors.tuna.tsinghua.edu.cn/lxc-images/images/ubuntu/yakkety/arm64/default/20170312_03%3A49/rootfs.tar.xz -O ubuntu.tar.gz
        elif [ "$(dpkg --print-architecture)" == "arm" ];then
            wget https://mirrors.tuna.tsinghua.edu.cn/lxc-images/images/ubuntu/yakkety/armhf/default/20170311_03%3A49/rootfs.tar.xz -O ubuntu.tar.gz
        else
            echo "unknown architecture"
            exit 1
        fi
    fi
    cur=`pwd`
    mkdir -p $folder
    cd $folder
    echo "解压ubuntu镜像..."
    proot --link2symlink tar -xf $cur/ubuntu.tar.gz||:
    echo "设置dns..."
    echo "nameserver 119.29.29.29" > etc/resolv.conf
    echo "修改源..."
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports yakkety main restricted universe multiverse" > etc/apt/sources.list
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports yakkety-updates main restricted universe multiverse" >> etc/apt/sources.list
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports yakkety-security main restricted universe multiversef" >> etc/apt/sources.list
    cd $cur
fi
bin=$PREFIX/bin/startubuntu
echo "写入启动脚本..."
cat > $bin <<- EOM
#!/bin/bash
cd `pwd`

command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
command+=" -b /system"
command+=" -b /dev/"
command+=" -b /sys/"
command+=" -b /proc/"
#uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/bin:/usr/bin:/sbin:/usr/sbin"
command+=" TERM=\$TERM"
command+=" /bin/bash --login"
export PROOT_NO_SECCOMP=1
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM
echo "fixing shebang of $bin"
termux-fix-shebang $bin
echo "设置 $bin 执行权限..."
chmod +x $bin
echo "你现在可以启动Ubuntu. 输入 startubuntu "
