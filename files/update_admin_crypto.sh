#!/bin/bash

ENC_PWD=``./cli.sh encrypt $2 | grep BEGIN -A11 | grep -v ENCRYPTED | tr '\n' ' '`
echo "UPDATE internaluser SET pwd = '${ENC_PWD}' WHERE objectid = 'openidm-admin';"