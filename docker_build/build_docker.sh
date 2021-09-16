#!/bin/bash -f

#Analog Design Environment tag
export OPEN_ANALOG_DESIGN_TAG="v0.1"
export OPEN_ANALOG_DESIGN_NAME="mabrains/open-analog-design"


docker build -t $OPEN_ANALOG_DESIGN_NAME:$OPEN_ANALOG_DESIGN_TAG .
#docker push $OPEN_ANALOG_DESIGN_NAME:$OPEN_ANALOG_DESIGN_TAG

