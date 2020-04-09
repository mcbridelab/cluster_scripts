#!/bin/bash
#SBATCH -N1 -c1 -t2:00:00
#Usage hello.sh NAME
#by Noah Rose
echo "Hello $1"
