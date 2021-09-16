##############################################################################################
## Tools Installation Makefile
##############################################################################################

# Analog tools links
ngspice_version     = 35
ngspice_link        ="https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/$(ngspice_version)/ngspice-$(ngspice_version).tar.gz"
klayout_version	    = "0.27.3-1"
klayout_link        ="https://www.klayout.org/downloads/Ubuntu-20/klayout_$(klayout_version)_amd64.deb"
magic_link          ="https://github.com/RTimothyEdwards/magic.git"
xcircuit_link       ="https://github.com/RTimothyEdwards/XCircuit.git"
netgen_link         ="https://github.com/RTimothyEdwards/netgen.git"
xschem-gaw_link     ="https://github.com/StefanSchippers/xschem-gaw.git"
xschem_link         ="https://github.com/StefanSchippers/xschem.git"
trilinos_link       ="https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-12-12-1.tar.gz"
xyce_link           ="https://github.com/Xyce/Xyce.git"

# Digital tools links
yosys_link          ="https://github.com/YosysHQ/yosys.git"
graywolf_link       ="https://github.com/rubund/graywolf.git"
qrouter_link        ="https://github.com/RTimothyEdwards/qrouter"
qflow_link          ="https://github.com/RTimothyEdwards/qflow"
iverilog_link       ="https://github.com/steveicarus/iverilog.git"

# RF tools links
openems_link        ="https://github.com/thliebig/openEMS-Project.git"


all: install_libraries all_analog all_digital 

all_analog: temp build_ngspice_lib build_ngspice install_klayout build_magic build_netgen build_xcircuit build_xschem build_xyce

all_digital: temp build_yosys build_graywolf build_qrouter build_qflow

.ONESHELL:
install_libraries:
	@apt update -y
	@apt upgrade -y
	@apt install wget
	@apt install -y vim htop build-essential git cmake autoconf automake flex bison texinfo libx11-dev libxaw7-dev libreadline-dev 
	@apt install -y tcl-dev tk-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev tcsh csh libcairo2-dev libncurses-dev libgsl-dev
	@apt install -y libgtk-3-dev clang gawk libffi-dev graphviz xdot pkg-config libboost-system-dev libboost-python-dev zlib1g-dev
	@apt install -y libboost-filesystem-dev gengetopt help2man groff pod2pdf libtool octave liboctave-dev epstool transfig paraview
	@apt install -y libhdf5-dev libvtk7-dev libboost-all-dev libcgal-dev libtinyxml-dev qtbase5-dev libvtk7-qt-dev libopenmpi-dev
	@apt install -y xterm graphicsmagick ghostscript libhdf5-serial-dev vtk7 cython3 python3 python3-pip python3-numpy gcc g++ 
	@apt install -y gfortran python3-matplotlib python3-scipy python3-h5py meld ffmpeg  make libfl-dev libfftw3-dev libsuitesparse-dev
	@apt install -y libblas-dev liblapack-dev uidmap apt-transport-https ca-certificates curl gnupg m4
	@apt autoremove
	@apt clean

temp:
	@mkdir temp
	
.ONESHELL:
download_ngspice: temp
	@cd temp
	@wget -O ngspice-$(ngspice_version).tar.gz $(ngspice_link)
	@tar zxvf ngspice-$(ngspice_version).tar.gz

.ONESHELL:
build_ngspice_lib: download_ngspice 
	@mkdir -p temp/ngspice-$(ngspice_version)/build-lib
	@cd temp/ngspice-$(ngspice_version)/build-lib
	@../configure --with-x --enable-xspice --enable-cider --enable-openmp --disable-debug --with-ngshared
	@make -j$$(nproc)
	@make install

.ONESHELL:
build_ngspice: download_ngspice 
	@mkdir -p temp/ngspice-$(ngspice_version)/release
	@cd  temp/ngspice-$(ngspice_version)/release
	@../configure --with-x --enable-xspice --enable-cider --enable-openmp --with-readlines=yes --disable-debug
	@make -j$$(nproc)
	@make install

.ONESHELL:
install_klayout: temp
	@cd temp
	@wget $(klayout_link)
	@dpkg -i ./klayout_$(klayout_version)_amd64.deb
	@apt-get install -f -y

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
build_xschem: temp build_gaw3
	@cd temp
	@git clone $(xschem_link)
	@cd xschem
	@./configure
	@make -j$$(nproc)
	@make install:
	
.ONESHELL:
download_trilinos: temp
	@cd temp
	@wget https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-12-12-1.tar.gz
	@tar zxvf trilinos-release-12-12-1.tar.gz

.ONESHELL:
build_trilinos: temp download_trilinos
	@mkdir -p temp/Trilinos-trilinos-release-12-12-1/parallel_build
	@cp cmake_init.sh temp/Trilinos-trilinos-release-12-12-1/parallel_build
	@cd temp/Trilinos-trilinos-release-12-12-1/parallel_build
	@chmod +x cmake_init.sh
	@make -j$$(nproc)
	@make install
	

.ONESHELL:
build_xyce: build_trilinos
	@cd temp
	@git clone $(xyce_link)
	@cd Xyce
	@./bootstrap
	@mkdir build_dir
	@cd build_dir
	@../configure CXXFLAGS="-O3" ARCHDIR="/opt/trilinos" CPPFLAGS="-I/usr/include/suitesparse" --enable-mpi CXX=mpicxx CC=mpicc F77=mpif77 --enable-stokhos --enable-amesos2 --prefix=/usr/local
	@make -j$$(nproc)
	@make install
	

.ONESHELL:
build_openems: temp
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

