#!/bin/bash


OPENIDM_HOME=$1
cd $OPENIDM_HOME
./cli.sh encrypt $2 | grep BEGIN -A11 | grep -v ENCRYPTED | tr '\n' ' '