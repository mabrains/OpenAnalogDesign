###########################################################################################
# Makefile to control the Analog Design Environment
###########################################################################################

CURRENT_TAG   ?= v0.1
IMAGE_NAME    ?= mabrains/open-analog-design:$(CURRENT_TAG)
DOCKER_OPTIONS = "--env=DISPLAY --volume=/tmp/.X11-unix:/tmp/.X11-unix --net=host"


### OPEN_ANALOG_DESIN

.PHONY: all
all: openlane

.PHONY: open_Analog
open_Analog:
  docker pull $(IMAGE_NAME)

.PHONY: mount
mount:
  docker run -it --rm --name OpenAnlaog_container $(DOCKER_OPTIONS) $(IMAGE_NAME)
