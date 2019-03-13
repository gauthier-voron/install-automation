~/.automated_script.sh

if [ -e '/dev/vdb' ] ; then
    mount '/dev/vdb' '/mnt'
    cp --recursive --no-target-directory '/mnt' "/root"
    umount '/mnt'
    ./install-scripts/stage-1
fi
