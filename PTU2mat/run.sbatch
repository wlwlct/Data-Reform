#!/bin/bash

#SBATCH -J P2M_1001
#SBATCH -p interactive
#SBATCH -t 4:00:00
#SBATCH --mem-per-cpu=32gb
#SBATCH --cpus-per-task=1
#SBATCH -e error.err
#SBATCH -o output.out
module load matlab
matlab -singleCompThread -nodisplay -nosplash -nojvm -r PTU32Mat
