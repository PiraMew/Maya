#!/bin/bash
#SBATCH --partition normal
#SBATCH --mem-per-cpu 4G
#SBATCH -c 1
#SBATCH --time 2-0

../../beast/bin/beast no_gdis_concat.xml