##############################################################################################
## Tools Installation Makefile
##############################################################################################

temp:
    mkdir -p temp
    cd temp
    
download_ngspice: temp
    wget -O ngspice-34.tar.gz https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/34/ngspice-34.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fngspice%2Ffiles%2Fng-spice-rework%2F34%2Fngspice-34.tar.gz%2Fdownload&ts=1612217502
    tar zxvf ngspice-34.tar.gz

build_ngspice: download_ngspice
    cd ngspice-34
    mkdir release
    cd release
    ../configure --with-x --enable-xspice --enable-cider --enable-openmp --with-readlines=yes --disable-debug
    make
    make install

build_ngspice_lib: build_ngspice
    mkdir build-lib
    cd build-lib
    ../configure --with-x --enable-xspice --enable-cider --enable-openmp --disable-debug --with-ngshared
    make
    make install


download_magic: temp
    git clone https://github.com/RTimothyEdwards/magic

build_magic: download_magic
    cd magic
    ./configure
    make
    make install

download_klayout: temp
    wget https://www.klayout.org/downloads/Ubuntu-20/klayout_0.26.11-1_amd64.deb

install_klayout: download_klayout
    dpkg -i ./klayout_0.26.8-1_amd64.deb
    apt-get install -f -y

download_netgen: temp
    git clone https://github.com/RTimothyEdwards/netgen

build_netgen: download_netgen
    ./configure
    make
    make install

download_yosys: temp
    git clone https://github.com/YosysHQ/yosys.git

build_yosys: download_yosys
    make config-gcc
    make
    make install


download_graywolf: temp
    git clone https://github.com/rubund/graywolf.git

build_graywolf:
    cd graywolf
    mkdir build
    cd build
    cmake ..
    make
    make install

download_qrouter: temp
    git clone https://github.com/RTimothyEdwards/qrouter 

build_qrouter: download_qrouter
    cd qrouter
    ./configure
    make
    make install

download_qflow: temp
    git clone https://github.com/RTimothyEdwards/qflow 

build_qflow: download_qflow
    cd qflow
    ./configure
    make
    make install

download_gaw3: temp
    git clone https://github.com/StefanSchippers/xschem-gaw.git

build_gaw3: download_gaw3
    cd xschem-gaw
    ./configure
    make -j$(nproc)
    make install

download_xschem: temp
    git clone https://github.com/StefanSchippers/xschem.git
    
build_xschem: download_xschem
    cd xschem
    ./configure
    make -j$(nproc)
    make install

download_openems: temp
    git clone https://github.com/thliebig/openEMS-Project.git
    cd openEMS-Project
    git submodule init
    git submodule update

build_openems: download_openems:
    export OPENEMS=/opt/openems
    ./update_openEMS.sh $OPENEMS
    cd CSXCAD/python; python3 setup.py build_ext -I$OPENEMS/include -L$OPENEMS/lib -R$OPENEMS/lib; sudo python3 setup.py install; cd ../..
    cd openEMS/python; python3 setup.py build_ext -I$OPENEMS/include -L$OPENEMS/lib -R$OPENEMS/lib; sudo python3 setup.py install; cd ../..
