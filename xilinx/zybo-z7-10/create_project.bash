#!/bin/bash

if type vivado &> /dev/null; then
    vivado -mode batch -source create_project.tcl
else
    echo "vivado is not installed or setting.sh is not sourced"
fi
