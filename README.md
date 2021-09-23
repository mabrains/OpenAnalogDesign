# OpenAnalogDesign

[<img src="https://raw.githubusercontent.com/mabrains/sky130_ubuntu_setup/main/logo.svg" width="150">](http://mabrains.com/)

Open Analog Design Environment that would encapsulate the following tools for Analog Design:

1. `Xschem` - A schematic editor for VLSI/Asic/Analog custom designs
2. `Xcircuit` - Drawing program [especially for circuit schematics]
3. `klayout` - Streams out the final layout file
4. `magic` - Streams out the final layout file
5. `netgen` Performs LVS Checks
6. `Xyce` - Analog circuit simulator
7. `ngspice` - Spice simulator for electric and electronic circuits.


PDKs Supported:
1. `Skywater 130nm` using open_pdk installation.

This Analog Design enviroment will support Skywater 130nm PDK similar to OpenLane.

# Installation
To be able to use OpenAnalogDesign environment, you will need to do the following:
```
make open_analog
make pdk
```

Note: OpenAnalogDesign docker image is about 9GB.

# Usage

The main intension behind creating this docker image is the following:
1. To allow the usage of the tools across different platforms. 
2. Standardize the process of design and make it easy to have uniqified framework for people and enabling them to productive.

We currently only support Linux. We have tested it on:
* Ubuntu 20.04

To be able to use OpenAnalogDesign environment, currently, we only support mounting:
```
make mount
```

# Suggestions

Do you want to package more, please create an issue here on this repo.

# External Links
* [OpenLane project](https://github.com/The-OpenROAD-Project/OpenLane).
* [Open_Pdks](https://github.com/RTimothyEdwards/open_pdks)
* [Xschem](https://github.com/StefanSchippers/xschem)
* [klayout](https://github.com/KLayout/klayout)
* [Magic](https://github.com/RTimothyEdwards/magic)
* [XCircuit](https://github.com/RTimothyEdwards/XCircuit)
* [Netgen](https://github.com/RTimothyEdwards/netgen)
* [Skywaters 130nm PDK](https://github.com/google/skywater-pdk)
* [Xyce](https://xyce.sandia.gov/)
* [Ng-spice](http://ngspice.sourceforge.net/)


