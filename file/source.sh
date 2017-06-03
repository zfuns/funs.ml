#!/system/bin/sh

ARCH_LIST=('aarch64' 'arm')
HOST_ARCH=$(uname -m)
if [ $HOST_ARCH == "aarch64" ]
then
    ARCH="aarch64"

elif [[ ${HOST_ARCH} =~ .*(arm).* ]]
then
	ARCH="arm"
fi
echo "修改termux源"

echo \
"# The tuna termux repository:
deb [arch=all,${ARCH}] http://mirrors.tuna.tsinghua.edu.cn/termux/ stable main \
" > ~/../usr/etc/apt/sources.list
sleep 2

echo "修改完成"
