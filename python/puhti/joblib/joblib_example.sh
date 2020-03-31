#!/bin/bash
#SBATCH --job-name=JoblibTest
#SBATCH --account=<project>
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=test

module load geoconda
srun python joblib_example.py <INSERT-PATH-TO-SENTINEL-FOLDER>