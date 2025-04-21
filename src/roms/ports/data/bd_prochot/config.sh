#!/bin/bash

#### adjust values here ####
CPU_REG_ADDRESS="0x1FC"

#### colors
WHITE='\033[0;37m'
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'

#### dependencies
XTERM_TMP_FILE="/tmp/xterm_runner"
BASEDIR="/userdata/roms/ports/.data/bd_prochot"
RDMSR_BIN="$BASEDIR/rdmsr"
WRMSR_BIN="$BASEDIR/wrmsr"
