#!/bin/bash
CONFIG_FILE=/userdata/roms/ports/.data/bd_prochot/config.sh

# source config
function constants() {
    if [[ -e $CONFIG_FILE ]]
    then
        source $CONFIG_FILE
        return 0
    else
        echo -e "${RED}$CONFIG_FILE does not exist"
        sleep 2
        return 1
    fi
}

# only x86_64 is supported
function check_architecture() {
    if [[ $(uname -m) != "x86_64" ]]
    then
        echo -e "${RED}Architecture check failed - this is not a x86_64 based system"
        sleep 2
        return 1
    else
        echo -e "${GREEN}Platform type is x86_64"
        sleep 2
        return 0
    fi
}

# check if Intel CPU
function check_CPU_vendor() {
    CPU_VENDOR=$(cat /proc/cpuinfo | grep vendor_id | sort --unique | awk '{print $3}')
    if [[ $CPU_VENDOR == "GenuineIntel" ]]
    then
        echo -e "${GREEN}CPU type is GenuineIntel"
        sleep 2
        return 0
    else
        echo -e "${RED}CPU type is NOT GenuineIntel"
        sleep 2
        return 1
    fi
}

# check if msr binaries exist
function check_msr_bins() {
    success_counter=0
    for binary in $RDMSR_BIN $WRMSR_BIN
    do
        if [[ -e $binary ]]
        then
            echo -e "${GREEN}$binary found"
            ((success_counter++))
            sleep 2
        else
            echo -e "${RED}$binary not found"
            sleep 2
        fi
    done

    if [[ success_counter == 2 ]]
    then
        return 1
    else
        return 0
    fi
}

# modprobe msr
function activate_msr_module() {
    modprobe msr
}

# read initial CPU REG value
function read_REG() {
    CPU_REG_VALUE=$($RDMSR_BIN -a -d $CPU_REG_ADDRESS | sort --unique)
    if [[ $(wc -l <<< $CPU_REG_VALUE) -eq 1 && -n $CPU_REG_VALUE ]];
    then
        echo -e "${GREEN}Detected value: $CPU_REG_VALUE"
        return 0
    else
        echo -e "${RED}Could not read CPU Register at: $CPU_REG_ADDRESS"
        echo -e "${RED}Either register returned multiple values or it is not implemented"
        return 1
    fi
    # do we need log files?
}

# write desired value to disable bd-prochot
function write_REG() {
    CPU_REG_VALUE=$($RDMSR_BIN -a -d $CPU_REG_ADDRESS | sort --unique)
    let "DESIRED_CPU_VALUE=$CPU_REG_VALUE - 1"
    echo -e "${WHITE}Desired Value is: $DESIRED_CPU_VALUE"
    $WRMSR_BIN $CPU_REG_ADDRESS $DESIRED_CPU_VALUE

    # verify it worked
    if [[ $($RDMSR_BIN -a -d $CPU_REG_ADDRESS | sort --unique) == $DESIRED_CPU_VALUE ]]
    then
        echo -e "${GREEN}Desired value: $DEISRED_VALUE set successfully"
        return 0
    else
        echo -e "${RED}Desired value: $DEISRED_VALUE NOT set successfully"
        return 1
    fi
}

function main() {
    # if script is run without parameter we quit
    if [[ $# -eq 0 ]]
    then
        echo "something went wront - missing parameter?"
        return 1
    fi

    # constants is always run
    constants

    # catch parameter and run according function only
    if [[ $1 == "check_architecture" ]]
    then
        check_architecture
    elif [[ $1 == "check_CPU_vendor" ]]
    then
        check_CPU_vendor
    elif [[ $1 == "check_msr_bins" ]]
    then
        check_msr_bins
    elif [[ $1 == "activate_msr_module" ]]
    then
        activate_msr_module
    elif [[ $1 == "read_REG" ]]
    then
        read_REG
    elif [[ $1 == "write_REG" ]]
    then
        write_REG
    else
        echo "wrong parameter"
        return 1
    fi
}

main "$@"
