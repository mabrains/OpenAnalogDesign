##############################################################################################
## Tools Installation Makefile
##############################################################################################

# required links
ngspice_link        ="https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/34/ngspice-34.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fngspice%2Ffiles%2Fng-spice-rework%2F34%2Fngspice-34.tar.gz%2Fdownload&ts=1612217502"
klayout_link        ="https://www.klayout.org/downloads/Ubuntu-20/klayout_0.26.11-1_amd64.deb"
netgen_link         ="https://github.com/RTimothyEdwards/netgen"
yosys_link          ="https://github.com/YosysHQ/yosys.git"
graywolf_link       ="https://github.com/rubund/graywolf.git"
qrouter_link        ="https://github.com/RTimothyEdwards/qrouter"
qflow_link    	    ="https://github.com/RTimothyEdwards/qflow"
xschem-gaw_link     ="https://github.com/StefanSchippers/xschem-gaw.git"
xschem_link         ="https://github.com/StefanSchippers/xschem.git"
openems_link        ="https://github.com/thliebig/openEMS-Project.git"


.PHONY: all build_ngspice_lib temp
all: temp build_openems  build_xschem build_gaw3  build_qflow  build_qrouter build_graywolf build_yosys build_netgen install_klayout build_ngspice_lib

temp:
	@mkdir temp

build_ngspice_lib: build_ngspice
	@mkdir temp/ngspice-34/build-lib
	@cd temp/ngspice-34/build-lib
	@../configure --with-x --enable-xspice --enable-cider --enable-openmp --disable-debug --with-ngshared
	@make
	@make install

.ONESHELL:
build_ngspice: download_ngspice
	@mkdir temp/ngspice-34/release
	@cd  temp/ngspice-34/release
	@../configure --with-x --enable-xspice --enable-cider --enable-openmp --with-readlines=yes --disable-debug
	@make
	@make install

.ONESHELL:
download_ngspice:
	@cd temp
	@wget -O ngspice-34.tar.gz $(ngspice_link)
	@tar zxvf ngspice-34.tar.gz

.ONESHELL:
install_klayout:
	@cd temp
	@wget $(klayout_link)
	@sudo dpkg -i ./klayout_0.26.8-1_amd64.deb
	@sudo apt-get install -f -y

.ONESHELL:
build_netgen:
	@cd temp
	@git clone $(netgen_link)
	@cd netgen
	@./configure
	@make
	@make install

.ONESHELL:
build_yosys:
	@cd temp
	@git clone $(yosys_link)
	@cd yosys
	@make config-gcc
	@make
	@make install
.ONESHELL:
build_graywolf:
	@cd temp
	@git clone $(graywolf_link)
	@cd graywolf
	@mkdir build
	@cd build
	@cmake ..
	@make
	@make install

.ONESHELL:
build_qrouter:
	@cd temp
	@git clone $(qrouter_link)
	@cd qrouter
	@./configure
	@make
	@make install

.ONESHELL:
build_qflow:
	@cd temp
	@git clone $(qflow_link)
	@cd qflow
	@./configure
	@make
	@make install

.ONESHELL:
build_gaw3:
	@cd temp
	@git clone $(xschem-gaw_link)
	@cd xschem-gaw
	@./configure
	@make -j$(nproc)
	@make install

.ONESHELL:
build_xschem:
	@cd temp
	@git clone $(xschem_link)
	@cd xschem
	@./configure
	@make -j$(nproc)
	@make install:

.ONESHELL:
build_openems:
	@cd temp
	@git clone $(openems_link)
	@cd openEMS-Project
	@git submodule init
	@git submodule update
	@export OPENEMS=/opt/openems
	@./update_openEMS.sh $OPENEMS
	@cd CSXCAD/python
	@python3 setup.py build_ext -I$OPENEMS/include -L$OPENEMS/lib -R$OPENEMS/lib
	@sudo python3 setup.py install
	@cd ../..
	@cd openEMS/python
	@python3 setup.py build_ext -I$OPENEMS/include -L$OPENEMS/lib -R$OPENEMS/lib
	@sudo python3 setup.py install
	@cd ../..
clean:
	rm -rf temp

