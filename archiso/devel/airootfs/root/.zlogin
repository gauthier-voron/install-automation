~/.automated_script.sh

if [ -e '/dev/vdb' ] ; then
    tar -xzf '/dev/vdb'
    ./script/main
fi
