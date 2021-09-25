###########################################################################################
# Makefile to control the Analog Design Environment
###########################################################################################
pdk_link = https://github.com/mabrains/open_pdks.git
sky130_klayout_pdk = https://github.com/mabrains/sky130_klayout_pdk.git

OPENAnalog_DIR ?= $(shell pwd)
PDK_ROOT       ?= $(shell pwd)/pdks
DESIGNS_ROOT   ?= $(shell pwd)/designs

CURRENT_TAG    ?= "v0.1"
IMAGE_NAME     ?= mabrains/open-analog-design:$(CURRENT_TAG)

DOCKER_MEMORY_OPTIONS :=
ifneq (,$(DOCKER_SWAP)) # Set to -1 for unlimited
DOCKER_MEMORY_OPTIONS +=  --memory-swap=$(DOCKER_SWAP)
endif
ifneq (,$(DOCKER_MEMORY))
DOCKER_MEMORY_OPTIONS += --memory=$(DOCKER_MEMORY)
# To verify: cat /sys/fs/cgroup/memory/memory.limit_in_bytes inside the container
endif

DOCKER_GUI_OPTIONS ?= --env=DISPLAY --volume=/tmp/.X11-unix:/tmp/.X11-unix --net=host
DOCKER_UID_OPTIONS ?= $(shell python3 ./scripts/get_docker_config.py)
DOCKER_OPTIONS ?= $(DOCKER_GUI_OPTIONS) $(DOCKER_MEMORY_OPTIONS) $(DOCKER_UID_OPTIONS)
DOCKER_MAPPING ?= -v $(PDK_ROOT):$(PDK_ROOT) -v $(DESIGNS_ROOT):/designs -v $(OPENAnalog_DIR):/open_analog_design -e PDK_ROOT=$(PDK_ROOT)

ENV_COMMAND ?= docker run --rm --name OpenAnlaog_container $(DOCKER_MAPPING) $(DOCKER_OPTIONS) $(IMAGE_NAME)

.DEFAULT_GOAL := all

.PHONY: all
all: open_Analog pdk

######################################################################## PDK Installation ########################################################################

$(PDK_ROOT)/:
	@mkdir -p $(PDK_ROOT)

.ONESHELL:
.PHONY: open_pdks		 
open_pdks:
	@cd $(OPENAnalog_DIR)
	@git clone $(pdk_link)

.ONESHELL:
.PHONY: clean_open_pdks
clean_open_pdks:
	@cd $(OPENAnalog_DIR)
	@rm -rf open_pdks

.ONESHELL:
.PHONY: skywater_pdk_klayout
skywater_pdk_klayout:
	$(ENV_COMMAND) sh -c "cd /root && klayout -e && \
							  mv ~/.klayout ~/.klayout_old && \
							  klayout -e && \
							  cd  ~/.klayout && \
							  mkdir tech && cd tech && \
							  git clone $(sky130_klayout_pdk) sky130 && \
							  pip install pandas"  
	$(ENV_COMMAND) klayout -e 
	
.PHONY: pdk_install
pdk_install: $(PDK_ROOT)/ open_pdks
	$(ENV_COMMAND) sh -c "cd /open_analog_design/open_pdks && \
	                      ./configure prefix=$(PDK_ROOT) --enable-sky130-pdk && \
	                      make && \
	                      make install"

.PHONY: pdk
pdk: pdk_install clean_open_pdks

########################################################################## OPEN_ANALOG_DESIN ######################################################################

.PHONY: open_analog
open_analog:
	docker pull $(IMAGE_NAME)

.PHONY: mount
mount:
	cd $(OPENAnalog_DIR) && \
	docker run -it --rm --name OpenAnlaog_container $(DOCKER_MAPPING) $(DOCKER_OPTIONS) $(IMAGE_NAME) 

########################################################### Building the folder structure folder of the desgin #####################################################

%-cell: 
	@$(ENV_COMMAND) sh -c "cd /designs && \
							if [ -d $* ]; then \
								echo '$* is already exists';\
							else \
								mkdir  $*		;\
								mkdir -p $*/schematic	;\
								mkdir -p $*/symbol	;\
								mkdir -p $*/layout	;\
								mkdir -p $*/netlist	;\
								mkdir -p $*/simulations; fi" 
								
############################################################################ Using Tools  ##########################################################################

%-schematic: %-cell
	@$(ENV_COMMAND) sh -c "cd /designs/$*/schematic && \
							if [ -f '$*.sch' ]; then \
								xschem $*.sch;\
							else \
								touch $*.sch ;\
								xschem $*.sch; fi"

%-xcircuit: %-cell
	@$(ENV_COMMAND) sh -c "cd /designs/$*/schematic && \
							if [ -f '$*.ps' ]; then \
								xcircuit $*.ps;\
							else \
								touch $*.ps ;\
								xcircuit $*.ps; fi"	

%-symbol: %-cell
	@$(ENV_COMMAND) sh -c "cd /designs/$*/symbol && \
							if [ -f $*.sym ]; then \
								xschem $*.sym;\
							else \
								touch $*.sym ;\
								xschem $*.sym; fi"

%-klayout: %-cell
	@$(ENV_COMMAND) sh -c "cd /designs/$*/layout && \
							if [ -f $*.gds ]; then \
								klayout -e $*.gds;\
							else \
								klayout -b  -rd design_name='$*.gds' -r '/open_analog_design/scripts/create_gds.rb' ;\
								klayout -e $*.gds; fi"
%-magic: %-cell
	@$(ENV_COMMAND) sh -c "cd /designs/$*/layout && \
							if [ -f $*.gds ]; then \
								magic $*.gds;\
							else \
								touch $*.gds ;\
								magic $*.gds; fi"
							
