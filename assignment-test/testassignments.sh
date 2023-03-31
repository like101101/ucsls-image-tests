#! /bin/bash

# Create Gradescope-like environment
echo 
echo "  ---- Building Gradescope-like environments ----"

mkdir -p /autograder/source

# Iterating through all assignment directory
for PS_DIR in assignment-*/; do
    echo
    echo "  ---- TESTING ${PS_DIR} ----"


    # copying the autograder scripts to the write place
    cp -r $PS_DIR/* /autograder/source
    cp /autograder/source/run_autograder /autograder/run_autograder
    chmod +x /autograder/run_autograder

    # Run the autograder scripts
    /autograder/source/run_autograder

    # Clean Up
    rm -rf /autograder/source/*

done

echo 
echo " ---- Assignment Tests Passed ---- "