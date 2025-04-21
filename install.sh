#!/bin/bash

method_counter=0

function check_architecture() {
    if [ $(uname -m) != "x86_64" ]
    then
        echo "architecture check failed - this is not a x86_64 based system - aborting"
        exit 1
    fi
}

function constants() {
    REPO_URL="https://github.com/nicolai-6/batocera-bd-prochot/archive/refs/heads/main.zip"
    ARTIFACT_TMP_PATH=/tmp/batocera-bd-prochot.zip
    ARTIFACT_EXTRACTED_TMP_PATH="/tmp/batocera-bd-prochot-main"
    TARGET_BASEDIR="/userdata/roms/ports"
}

function download_artifact() {
    echo "############ Trying to download repo content ############"
    wget -q --no-check-certificate --no-cache --no-cookies -O "$ARTIFACT_TMP_PATH" "$REPO_URL"
    if [ $? -ne 0 ]
    then
        echo "Downloading repo content failed - aborting"
        exit 1
    fi

    echo "################ D O N E ################"
    echo ""
    sleep 1
}

function extract_artifact() {
    echo "############ Extracting zip archive ############"
    unzip -qq -o $ARTIFACT_TMP_PATH -d /tmp/
    if [ $? -ne 0 ]
    then
        echo "Extracting the archive went wrong - aborting"
        exit 1
    fi
    
    echo "################ D O N E ################"
    echo ""
    sleep 1
}

function setup() {
    # create dir
    echo "############ Creating $TARGET_BASEDIR/.data/bd_prochot dir ############"
    mkdir -p $TARGET_BASEDIR/.data/bd_prochot

    if [ $? -ne 0 ]
    then
        echo "Could not create $TARGET_BASEDIR/.data/bd_prochot dir - aborting"
        exit 1
    fi

    echo "################ D O N E ################"
    echo ""
    sleep 1

    echo "############ copying required files ############"
    # provide image
    cp $ARTIFACT_EXTRACTED_TMP_PATH/src/roms/ports/images/bd_prochot.png $TARGET_BASEDIR/images/

    if [ $? -ne 0 ]
    then
        echo "copying the image failed - trying to continue with installation anyway"
        exit 0
    fi

    # provide .data scripts
    cp $ARTIFACT_EXTRACTED_TMP_PATH/src/roms/ports/data/bd_prochot/config.sh $TARGET_BASEDIR/.data/bd_prochot/

    if [ $? -ne 0 ]
    then
        echo "copying the config file went wrong - aborting"
        exit 1
    fi

    cp $ARTIFACT_EXTRACTED_TMP_PATH/src/roms/ports/data/bd_prochot/bd_prochot.sh $TARGET_BASEDIR/.data/bd_prochot/

    if [ $? -ne 0 ]
    then
        echo "copying bd_prochot.sh went wrong - aborting"
        exit 1
    fi

    # provide rdmsr wrmsr
    cp $ARTIFACT_EXTRACTED_TMP_PATH/src/roms/ports/data/bd_prochot/rdmsr $TARGET_BASEDIR/.data/bd_prochot/

    if [ $? -ne 0 ]
    then
        echo "copying rdmsr failed - aborting"
        exit 1
    fi

    cp $ARTIFACT_EXTRACTED_TMP_PATH/src/roms/ports/data/bd_prochot/wrmsr $TARGET_BASEDIR/.data/bd_prochot/

    if [ $? -ne 0 ]
    then
        echo "copying wrmsr failed - aborting"
        exit 1
    fi

    # provide the ports runner script
    cp $ARTIFACT_EXTRACTED_TMP_PATH/src/roms/ports/bd_prochot_runner.sh $TARGET_BASEDIR/

    if [ $? -ne 0 ]
    then
        echo "copying runnerscript failed - aborting"
        exit 1
    fi

    echo "################ D O N E ################"
    echo ""
    sleep 1
}

function modify_gamelist() {
    python $ARTIFACT_EXTRACTED_TMP_PATH/gamelist.py
}

function cleanup() {
    echo "############ finally cleaning up ############"
    rm -rf $ARTIFACT_TMP_PATH
    if [ $? -ne 0 ]
    then
        echo "cleaning up resource went wrong - installation could be ok anyway"
        exit 1
    fi

    rm -rf ${ARTIFACT_TMP_PATH::-4}-main
    if [ $? -ne 0 ]
    then
        echo "cleaning up resource went wrong - installation could be ok anyway"
        exit 1
    fi

    echo "################ D O N E ################"
    echo ""
    sleep 1
}

function main() {

    for method in {check_architecture,constants,download_artifact,extract_artifact,setup,modify_gamelist,cleanup}
    do
        $method
        ((method_counter++))
    done

    if [[ $method_counter < 7 ]]
    then
        echo "not all required methods have been run - ABORTING"
        exit 1
    else
        echo "installation successful"
        sleep 2
        echo "Run GAME SETTINGS -> UPDATE GAMELISTS and run BD-Prochot from ports section"
        exit 0
    fi
}

main "$@"

