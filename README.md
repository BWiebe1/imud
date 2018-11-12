# imud

## About
IMU Daemon is a TCP server specifically designed to run on Emlid *Reach RS* and *Reach RS+* to extract IMU data.

## Installation
The repo provides binaries and libraries for both RS (based on [Intel Edison](https://en.wikipedia.org/wiki/Intel_Edison)) and RS+ (based on [Neutis](https://neutis.io/)).
To install the software just clone this repo and run the install script:  
```
git clone https://github.com/BWiebe1/imud
cd imud
./install 
```
## Manual compilation  
First install the `RTIMULib2` package from `https://github.com/richardstechnotes/RTIMULib2` (parts of these instructions are adjusted from [this](https://github.com/87yj/EmlidIMU/) repo): 
Edit */etc/ld.so.conf* using `nano /etc/ld.so.conf` and add the line `/usr/local/lib`  
```
opkg install cmake
mkdir /imu && cd /imu
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
/usr/local/bin/RTIMULibCal
cd ../python
python setup.py install
cd tests
/usr/local/bin/RTIMULibCal #this will generate the needed RTIMULib.ini file
```  
Edit RTIMULib.ini using `nano RTIMULib.ini` and set:  
```
IMUType=7
BusISI2C=false
SPIBus=5
SPISelect=1
```
You can now test if the IMU data is being correctly read by running: `python Fusion.py`.  
A very important step in order to get correct IMU data is ***calibration***. At the very least, magnetometer calibration must be performed; run `/usr/local/bin/RTIMULibCal` and follow the on-screen instructions - this will update RTIMULib.ini with calibration data.   
Afterwards copy the Python scripts (`imu_reader.py` and `imu_server.py`) into the destination folder  
```
cd /imu/RTIMULib2/Linux/python/tests
nano imu_reader.py #paste content here
nano imu_server.py #paste content here
```
and copy the systemd service definitions (`imu_reader.service` and `imu_server.service`) to 
```
cd /etc/systemd/system/`
nano imu_reader.service #paste content here
nano imu_server.service #paste content here
```
You can now enable and start the services
``` 
sudo systemctl daemon-reload  
sudo systemctl enable imu_reader && sudo systemctl start imu_reader
sudo systemctl enable imu_server && sudo systemctl start imu_server
```
after which you should see IMU data (roll, pitch and yaw) in the web application (make sure the IMU host and port settings in the web application point to the correct host).