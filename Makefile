##############################################################################################
## Tools Installation Makefile
##############################################################################################

# Analog tools links
ngspcie_version     = 35
ngspice_link        ="https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/$(ngspcie_version)/ngspice-$(ngspcie_version).tar.gz"
klayout_link        ="https://www.klayout.org/downloads/Ubuntu-20/klayout_0.27.3-1_amd64.deb"
magic_link	    ="https://github.com/RTimothyEdwards/magic.git"
xcircuit_link	    ="https://github.com/RTimothyEdwards/XCircuit.git"
netgen_link         ="https://github.com/RTimothyEdwards/netgen.git"
xschem-gaw_link     ="https://github.com/StefanSchippers/xschem-gaw.git"
xschem_link         ="https://github.com/StefanSchippers/xschem.git"
trilinos_link	    ="https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-12-12-1.tar.gz"
xyce_link           ="https://github.com/Xyce/Xyce.git"

# Digital tools links
yosys_link          ="https://github.com/YosysHQ/yosys.git"
graywolf_link       ="https://github.com/rubund/graywolf.git"
qrouter_link        ="https://github.com/RTimothyEdwards/qrouter"
qflow_link    	    ="https://github.com/RTimothyEdwards/qflow"
iverilog_link       ="https://github.com/steveicarus/iverilog.git"

# RF tools links
openems_link        ="https://github.com/thliebig/openEMS-Project.git"


.PHONY: all build_ngspice_lib temp
all: temp build_openems  build_xschem build_gaw3  build_qflow  build_qrouter build_graywolf build_yosys build_netgen install_klayout build_ngspice_lib

temp:
	@mkdir temp
	
.ONESHELL:
download_ngspice: temp
	@cd temp
	@wget -O ngspice-$(ngspcie_version).tar.gz $(ngspice_link)
	@tar zxvf ngspice-$(ngspcie_version).tar.gz

.ONESHELL:
build_ngspice_lib: download_ngspice temp/ngspice-$(ngspice_version)
	@mkdir temp/ngspice-34/build-lib
	@cd temp/ngspice-34/build-lib
	@../configure --with-x --enable-xspice --enable-cider --enable-openmp --disable-debug --with-ngshared
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_ngspice: download_ngspice temp/ngspice-$(ngspice_version)
	@mkdir temp/ngspice-34/release
	@cd  temp/ngspice-34/release
	@../configure --with-x --enable-xspice --enable-cider --enable-openmp --with-readlines=yes --disable-debug
	@make -j$$(nproc)
	@make install

.ONESHELL:
install_klayout: temp
	@cd temp
	@wget $(klayout_link)
	@sudo dpkg -i ./klayout_0.27.3-1_amd64.deb
	@sudo apt-get install -f -y

.ONESHELL:
build_magic: temp
	@cd temp
	@git clone $(magic_link)
	@cd magic
	@./configure
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_netgen: temp
	@cd temp
	@git clone $(netgen_link)
	@cd netgen
	@./configure
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_xcircuit: temp
	@cd temp
	@git clone $(xcircuit_link)
	@cd XCircuit
	@./configure
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_yosys: temp
	@cd temp
	@git clone $(yosys_link)
	@cd yosys
	@make config-gcc
	@make -j$$(nproc)
	@make install
	
.ONESHELL:
build_graywolf: temp
	@cd temp
	@git clone $(graywolf_link)
	@cd graywolf
	@mkdir build
	@cd build
	@cmake ..
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_qrouter: temp
	@cd temp
	@git clone $(qrouter_link)
	@cd qrouter
	@./configure
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_qflow: temp
	@cd temp
	@git clone $(qflow_link)
	@cd qflow
	@./configure
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_gaw3: temp
	@cd temp
	@git clone $(xschem-gaw_link)
	@cd xschem-gaw
	@./configure
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_xschem: temp
	@cd temp
	@git clone $(xschem_link)
	@cd xschem
	@./configure
	@make -j$$(nproc)
	@make install:
	
.ONESELL:
download_trilinos: temp
	@cd temp
	@wget https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-12-12-1.tar.gz
	@tar zxvf trilinos-release-12-12-1.tar.gz

.ONESELL
create_trilinos_build_file: temp temp/Trilinos-trilinos-release-12-12-1
	@cd Trilinos-trilinos-release-12-12-1
	@mkdir parallel_build
	@cd parallel_build
	@
	


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

