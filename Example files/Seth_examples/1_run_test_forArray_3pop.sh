#!/bin/sh
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array 1-40
#SBATCH --job-name="test_sim_array"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=NONE
#SBATCH --error=test_sim_%A_%a.err
#SBATCH --output=test_sim_%A_%a.out

## notes
## an array job needs to:
#1. make its own working_dir and copy the abctoolbox.input template there, then modify this such that we:
#2. print the msms output file ${ms_file} to the working_dir

module load compilers/gcc530

cd /scratch/mskset001/novogene/LSD/SIMULATE_3pop
#chmod +x lsd_low_3pop.sh
TID=${SLURM_ARRAY_TASK_ID}
JOBID=${SLURM_ARRAY_JOB_ID}

mkdir -p output_${JOBID}/${TID}
sed "s/SIMDATANAME/SIMDATANAME.${TID}/g" ABCSampler_lsd_low_3pop.TEMPLATE.input > output_${JOBID}/${TID}/ABCSampler_lsd_low_3pop.${TID}.input

#sed -i "s#WORKINGDIR#output_${JOBID}/${TID}#g" output_${JOBID}/${TID}/ABCSampler_lsd_low_3pop.${TID}.input
sed -i "s#LOGFILE#${TID}.log#g" output_${JOBID}/${TID}/ABCSampler_lsd_low_3pop.${TID}.input
sed -i "s#MYNAME#${JOBID}_${TID}#g" output_${JOBID}/${TID}/ABCSampler_lsd_low_3pop.${TID}.input

cd output_${JOBID}/${TID}

/home/mskset001/abctoolbox/ABCtoolbox ABCSampler_lsd_low_3pop.${TID}.input
