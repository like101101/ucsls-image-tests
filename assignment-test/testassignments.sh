#! /bin/bash

set -e 


# Variables for color prints
Color_Off='\033[0m'       # Text Reset
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green

# Configuration
if [ -z $1 ]; then
    echo "  ---- Running inside test image ----"
    RUN_LOCALLY=false
    mkdir -p /autograder/source
    TESTING_LOC="/autograder/source"
else    
    echo "  ---- Running locally ----"
    RUN_LOCALLY=true
    mkdir -p tmp
    TESTING_LOC="tmp"
fi

# Iterating through all assignment directory
for PS_DIR in PS*; do
    echo "  ---- Testing ${PS_DIR} ----"

    # Ensure that the autograder scripts are executable
    chmod +x $PS_DIR/test.sh

    # copying the autograder scripts to the write place
    cp -r $PS_DIR/* $TESTING_LOC
    cp read_results.py $TESTING_LOC
    

    # Run the autograder scripts
    cd ${TESTING_LOC}
    ./test.sh > output.log 2>&1
    score=$(python read_results.py)

    # Check the results
    if [ $score -ne 80 ]; then
        cat output.log
        printf "${Red}  ---- Test Failed! ---- ${Color_Off}\n"
        exit 1
    fi

    
    # Clean Up
    rm -f output.log
    rm -rf ${TESTING_LOC}/*
    cd ..

done

echo 
printf "${Green}  ---- All Tests Passed! ---- ${Color_Off}\n"
echo
