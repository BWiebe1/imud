#!/usr/bin/env bash

function neutis()
{
    cp imud/libs/neutis/lib/libRTIMULib.so.8.0.0 /usr/local/lib
    cp imud/libs/neutis/bin/RTIMULibCal /usr/local/bin
    cp imud/libs/neutis/python/RTIMU.cpython-35m-aarch64-linux-gnu.so /data/imud
    cp imud/libs/neutis/python/RTIMU.so /data/imud
}

function edison()
{
    cp imud/libs/edison/lib/libRTIMULib.so.8.0.0 /usr/local/lib
    cp imud/libs/edison/bin/RTIMULibCal /usr/local/bin
    #TODO: python libs
}

function common()
{
    echo "/usr/local/lib" >> /etc/ld.so.conf
    mkdir -p /usr/local/bin
    mkdir -p /usr/local/lib
    mkdir -p /data/imud
    cp imud/reader.py /data/imud
    cp imud/server.py /data/imud
    cp scripts/imu_reader.service /etc/systemd/system
    cp scripts/imu_server.service /etc/systemd/system
    systemctl daemon-reload
    systemctl enable imu_reader.service
    systemctl enable imu_server.service
}


case "$1" in
"edison")
    echo "installing imud on Edison platform"
    common
    edison
    ;;
*)
    echo "installing imud on Neutis platform"
    common
    neutis
    ;;
esac
echo "done, make sure you perform IMU calibration using RTIMULibCal"