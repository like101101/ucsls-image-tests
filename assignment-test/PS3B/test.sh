#!/bin/bash
#set -x

# This is a very minminal gradescope compatible run_autograder
#  expects submission make will produce BINARY
#  It then uses the autograders TESTSCRIPT to run test the binary
#  expects last line of TESTSCRIPT output to be "score: n/d"
#  then calculates a gradescope submission score as n/d * MAXSCORE
#  produces a gradescope compatible results.json using the above

MAXSCORE=80.0
BINARY=
GITLOGFILE=


#/autograder/source contains the extracted contents of your autograder zip file.
#/autograder/run_autograder is where your autograder script gets copied to during the Docker image build process.
#/autograder/results/results.json is where you put the test output that is uploaded to Gradescope. This must be produced as a result of executing run_autograder.
# /autograder/submission contains the student's submission, downloaded from Gradescope.
# /autograder/results/stdout captures the output of run_autograder, for displaying back to the instructor for debugging purposes. Any output you wish to show to students must be explicitly put in the JSON "output" field.
export subdir=${subdir:-/autograder/submission}
export rundir=${rundir:-/autograder/source}
export results=${results:-/autograder/results/results.json}
export msg="Thanks for your submission."

submission="$subdir/and.[sS] $subdir/or.[sS] $subdir/sum.[sS] $subdir/Makefile"

if [[ -n $rundir && -d $rundir ]]; then
    [[ -n $subdir && -d $subdir ]] && cp $submission $rundir
    cd $rundir
fi

if [[ ! -a $(dirname $results) ]]; then
    results=$(basename $results)
fi

if [[ -a $rundir/andtest.S && ! -a $rundir/andtest.s ]]; then
    ln  $rundir/andtest.S $rundir/andtest.s
fi

if [[ -a $rundir/ortest.S && ! -a $rundir/ortest.s ]]; then
    ln  $rundir/ortest.S $rundir/ortest.s
fi

if [[ -a $rundir/sumtest.S && ! -a $rundir/sumtest.s ]]; then
    ln  $rundir/sumtest.S $rundir/sumtest.s
fi

tests="andtest.sh ortest.sh sumtest.sh"

typeset -i n=0
typeset -i d=0

for ts in $tests
do
    echo "Running $ts"
    echo "================="
    out="$(./$ts)"
    echo "$out"
    raw=$(echo "$out" | tail -1)
    raw=${raw##* }
    ((n+=${raw%%/*}))
    ((d+=${raw##*/}))
done

score=$(python -c "print ((${n}.0/${d}.0) * $MAXSCORE)")
echo "Score: $score / $MAXSCORE"

cat <<ENDOFJSON >$results
{
	"score": $score,
	"output": "$msg",
	"stdout_visibility": "visible",
	"extra_data": {}
}
ENDOFJSON

