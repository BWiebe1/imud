#!/usr/bin/env bash

function pre()
{
    echo "/usr/local/lib" > /etc/ld.so.conf
    mkdir -p /usr/local/bin
    mkdir -p /usr/local/lib
    mkdir -p /data/imud
    cp imud/reader.py /data/imud
    cp imud/server.py /data/imud
}

function post()
{
    ldconfig
    cp scripts/imu_reader.service /etc/systemd/system
    cp scripts/imu_server.service /etc/systemd/system
    systemctl daemon-reload
    systemctl enable imu_reader.service
    systemctl enable imu_server.service
    systemctl start imu_reader.service
    systemctl start imu_server.service
}

function neutis()
{
    echo "installing imud on Neutis platform"
    pre
    cp imud/libs/neutis/lib/libRTIMULib.so.8.0.0 /usr/local/lib
    cp imud/libs/neutis/bin/RTIMULibCal /usr/local/bin
    cp imud/libs/neutis/python/RTIMU.so /data/imud
    post
}

function edison()
{
    echo "installing imud on Edison platform"
    pre
    cp imud/libs/edison/lib/libRTIMULib.so.8.0.0 /usr/local/lib
    cp imud/libs/edison/bin/RTIMULibCal /usr/local/bin
    cp imud/libs/edison/python/RTIMU.so /data/imud
    post
}


case "$1" in
    "edison")
        edison
        ;;
    "neutis")
        neutis
        ;;
    *)
        cpu_count=$(getconf _NPROCESSORS_ONLN)
        case $cpu_count in
            "edison")
                edison
                ;;
            "neutis")
                neutis
                ;;
            *)
            echo "cannot detect system, exiting"
        esac
esac

echo "done, make sure you perform IMU calibration using RTIMULibCal";
