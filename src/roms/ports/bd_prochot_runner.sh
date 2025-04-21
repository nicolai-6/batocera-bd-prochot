#!/bin/bash
function constants() {
    export DISPLAY=:0.0
    source /userdata/roms/ports/.data/bd_prochot/config.sh
}

# provide xterm copy in /tmp
prerequisites() {
    cp $(which xterm) $XTERM_TMP_FILE && chmod 777 $XTERM_TMP_FILE
}

function main() {
    constants
    prerequisites
    # export DISPLAY
    export DISPLAY=:0.0

    # open xterm with DISPLAY output and run bd_prochot.sh with according parameters
    DISPLAY=:0.0 $XTERM_TMP_FILE -fs 30 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c " \
    echo -e \"#################### ABOUT TO DISABLE BD PROCHOT ####################\"; \
    sleep 1; \

    echo -e \"\nCHECKING ARCHITECTURE:\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/bd_prochot.sh check_architecture)\";
    if [[ $? == 1 ]]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}ARCHITECTURE CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\nCHECKING CPU VENDOR:\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/bd_prochot.sh check_CPU_vendor)\";
    if [[ $? == 1 ]]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}CPU VENDOR CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\nCHECKING REQUIRED BINARIES:\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/bd_prochot.sh check_msr_bins)\";
    if [[ $? == 1 ]]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}BINARIES CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\nACTIVATING MSR MODULE:\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/bd_prochot.sh activate_msr_module)\";
    if [[ $? == 1 ]]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}MODULE ACTIVATED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\nREADING CURRENT CPU REGISTER VALUE:\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/bd_prochot.sh read_REG)\";
    if [[ $? == 1 ]]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}REGISTER CHECK PASSED \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\nWRITING DESIRED REGISTER VALUE:\"; \
    sleep 1; \
    echo -e \"$($BASEDIR/bd_prochot.sh write_REG)\";
    if [[ $? == 1 ]]; then echo -e \"${RED}A B O R T I N G . . .\"; sleep 5; exit 1; \
    else echo -e \"${WHITE}WRITING REGISTER SUCCESSFUL \xE2\x9C\x94\"; fi ; \
    sleep 3; \

    echo -e \"\n${WHITE}#################### DONE ####################\"
    sleep 5; \
    exit 0
    "
}