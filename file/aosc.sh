#!/data/data/com.termux/files/usr/bin/bash
folder=aosc
if [ -d "$folder" ]; then
    first=1
    echo "跳过下载..."
fi
if [ "$first" != 1 ];then
    if [ ! -f "aosc.tar.gz" ]; then
        echo "下载aosc镜像..."
        if [ "$(dpkg --print-architecture)" == "aarch64" ];then
            wget https://mirrors.tuna.tsinghua.edu.cn/anthon/aosc-os/os-arm64/buildkit/aosc-os-buildkit_20170227_arm64.tar.xz -O aosc.tar.gz
        elif [ "$(dpkg --print-architecture)" == "arm" ];then
            wget https://mirrors.tuna.tsinghua.edu.cn/anthon/aosc-os/os-armel/buildkit/aosc-os-buildkit_20170227_armel.tar.xz -O aosc.tar.gz
        else
            echo "unknown architecture"
            exit 1
        fi
    fi
    cur=`pwd`
    mkdir -p $folder
    cd $folder
    echo "解压aosc镜像..."
    tar pxvf $cur/aosc.tar.gz||:
    echo "设置dns..."
    rm etc/resolv.conf
    echo "nameserver 119.29.29.29" > etc/resolv.conf
    cd $cur
fi
bin=$PREFIX/bin/startaosc
echo "写入启动脚本..."
cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash
cd ~/

command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r aosc"
#command+=" -b /system"
command+=" -b /dev/"
#command+=" -b /sys/"
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
echo "你现在可以启动aosc. 输入 startaosc "
