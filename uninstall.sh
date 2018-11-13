#!/usr/bin/env bash

function uninstall()
{
    systemctl stop imu_reader.service
    systemctl stop imu_server.service
    systemctl disable imu_reader.service
    systemctl disable imu_server.service
    rm -f /usr/local/lib/libRTIMULib.so.8.0.0
    rm -f /usr/local/bin/RTIMULibCal
    rm -rf /data/imud
    rm -f /etc/systemd/system/imu_reader.service
    rm -f /etc/systemd/system/imu_server.service
    systemctl daemon-reload
}

uninstall

echo "uninstall complete";
