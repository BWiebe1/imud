# imud

## About
IMU Daemon is a package consisting of an IMU reader (based on RTIMULib2) and TCP server specifically designed to run on Emlid *Reach RS* and *Reach RS+* to extract IMU data.

## Installation
The repo provides binaries and libraries for both RS (based on [Intel Edison](https://en.wikipedia.org/wiki/Intel_Edison)) and RS+ (based on [Neutis](https://neutis.io/)) but you can compile *RTIMULib2* manually if you like.
To install the software just clone this repo and run the install script:  
```
git clone https://github.com/BWiebe1/imud
cd imud
./install.sh [board type]
```
If `board_type` is not specified it defaults to *neutis*; make sure you use `./install.sh edison` for the old Reach RS.
Also, for Reach RS make sure the `RTIMULib.ini` file from the `/data/imud` folder has these values:  
```
IMUType=7
BusISI2C=false
SPIBus=5
SPISelect=1
```
## Calibration
In order to retrieve *accurate IMU data* it is **imperative** to calibrate the sensor (*magnetometer* and *accelerometers*).  
To do so run the provided application and follow the on-screen instructions:
```
cd /data/imud
/usr/local/bin/RTIMULibCal
```
You need to perform steps *m* and *a*:
 ```
  m - calibrate magnetometer with min/max
  e - calibrate magnetometer with ellipsoid (do min/max first)
  a - calibrate accelerometers
```
After calibration, restart the *reader* service to load the calibration data:
```
systemctl restart imu_reader.service
```
## Manual compilation  
First install the `RTIMULib2` package from `https://github.com/richardstechnotes/RTIMULib2` (parts of these instructions are adjusted from [this](https://github.com/87yj/EmlidIMU/) repo): 
Edit */etc/ld.so.conf* using `nano /etc/ld.so.conf` and add the line `/usr/local/lib`  
```
opkg install cmake
mkdir /data/imud && cd /data/imud
git clone https://github.com/richardstechnotes/RTIMULib2
cd RTIMULib2/Linux/
```  
Edit *CMakeLists.txt* using `nano CMakeLists.txt` and set: `OPTION(BUILD_GL “Build RTIMULibGL”  OFF)`  
```
mkdir build && cd build
cmake ..
make -j 4
make install
ldconfig
cd ../python
python setup.py install
cd tests
/usr/local/bin/RTIMULibCal #this will generate the needed RTIMULib.ini file
```  
At this point you should be able to load the binaries and libraries generated to be used by `imud` (see `install.sh` for the files used).