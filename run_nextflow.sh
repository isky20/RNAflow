#!/bin/bash
#SBATCH --job-name=nextflow_job           # Job name
#SBATCH --output=nextflow_job.out         # Output file
#SBATCH --error=nextflow_job.err          # Error file
#SBATCH --time=8:00:00                   # Time limit (hh:mm:ss)
#SBATCH --nodes=1                         # Number of nodes
#SBATCH --ntasks=1                        # Number of tasks
#SBATCH --cpus-per-task=8                 # Number of CPUs per task
#SBATCH --mem=10GB                        # Memory per node

module load nextflow                      # Load the Nextflow module if required
module load singularity                   # Load Singularity module if needed

nextflow run 00.main.nf -c nextflow.config --with-singularity
