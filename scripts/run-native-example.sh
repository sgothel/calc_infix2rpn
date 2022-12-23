#!/bin/bash

script_args="$@"

sdir=`dirname $(readlink -f $0)`
rootdir=`dirname $sdir`
bname=`basename $0 .sh`

. $rootdir/scripts/setup-machine-arch.sh "-quiet"

dist_dir=$rootdir/"dist-$os_name-$archabi"
build_dir=$rootdir/"build-$os_name-$archabi"
echo dist_dir $dist_dir
echo build_dir $build_dir

if [ ! -e $dist_dir/bin/$bname ] ; then
    echo "Not existing $dist_dir/bin/$bname"
    exit 1
fi

if [ ! -e $dist_dir/lib/libinfix_calc1.so ] ; then
    echo "Not existing $dist_dir/lib/libinfix_calc1.so"
    exit 1
fi

logbasename=$bname-$os_name-$archabi
logfile=$rootdir/$logbasename.log
rm -f $logfile

ulimit -c unlimited

# run as root 'dpkg-reconfigure locales' enable 'en_US.UTF-8'
# perhaps run as root 'update-locale LC_MEASUREMENT=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8'
export LC_MEASUREMENT=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

runit() {
    echo "script invocation: $0 ${script_args}"
    echo ${bname} commandline "$@"
    echo logfile $logfile

    LD_LIBRARY_PATH=$dist_dir/lib $EXE_WRAPPER $dist_dir/bin/${bname} $*
    exit $?
}

runit $* 2>&1 | tee $logfile

