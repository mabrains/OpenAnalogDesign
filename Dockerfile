# Copyright 2021 Mabrains
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# syntax = docker/dockerfile:1.0-experimental
FROM ubuntu:20.04 as build

# RUN useradd -m openlane
# RUN usermod -aG wheel openlane
# USER openlane

# install base dependencies
# including python 3.6

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y vim htop build-essential git cmake autoconf automake flex bison texinfo libx11-dev libxaw7-dev libreadline-dev m4 \
	tcl-dev tk-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev tcsh csh libx11-dev libcairo2-dev libncurses-dev \
	python3 python3-pip libgsl-dev libgtk-3-dev clang gawk libffi-dev graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev gengetopt help2man groff pod2pdf libtool octave liboctave-dev epstool transfig paraview \
	libhdf5-dev libvtk7-dev libboost-all-dev libcgal-dev libtinyxml-dev qtbase5-dev libvtk7-qt-dev libopenmpi-dev \
	xterm graphicsmagick ghostscript libtinyxml-dev libhdf5-serial-dev libcgal-dev vtk7 \
	cython3 build-essential cython3 python3-numpy python3-matplotlib python3-scipy python3-h5py meld \
  python3-pip ffmpeg gcc g++ gfortran make cmake bison flex libfl-dev libfftw3-dev libsuitesparse-dev \
  libblas-dev liblapack-dev libtool autoconf automake git \
  uidmap apt-transport-https     ca-certificates     curl     gnupg
  
RUN apt-get clean
ENV INSTALLATION_DIR=/installation_dir
RUN mkdir $INSTALLATION_DIR
COPY ./Makefile /installation_dir

RUN cd $INSTALLATION_DIR && make analog && make clean-install
