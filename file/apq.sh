#!/system/bin/sh
# Android Portable version of QEMU（简称APQ）安装脚本
# 作者：felonwan@gmail.com
# 修改：2014年12月20日

apt install wget
apt install tar
# 变量
PRJ=APQ
INS=/data/data/com.termux/files/home/${PRJ}

cd ~

#下载
echo "正在下载..."
wget http://funs.ml/file/APQ.tar.gz

#解压
echo "正在解压..."
tar xpf APQ.tar.gz

#设置权限
echo "设置文件权限……"
chmod 0755 $INS/bin/*
chmod 0777 $INS/etc/*
chmod 0755 $INS/lib/ld-linux-armhf.so.3
chmod 0755 $INS/libexec/*
echo "权限设置成功。"

#完成安装
echo "安装已完成！"
echo "退出……"
cd $HOME/APQ
