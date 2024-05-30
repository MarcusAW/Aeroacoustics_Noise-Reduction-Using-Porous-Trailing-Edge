#!/bin/bash
#SBATCH --job-name=solidLES
#SBATCH --time=128:00:00
#SBATCH --ntasks=64
#SBATCH --nodes=2
#SBATCH --mem-per-cpu=2G

module load OpenFOAM/v2106-foss-2021a
. ${FOAM_BASH}

cp constant/turbulenceProperties_LES constant/turbulenceProperties
cp system/controlDict_LES system/controlDict
cp system/fvSchemes_LES system/fvSchemes
cp system/fvSolution_LES system/fvSolution
decomposePar
mpirun --mca btl ^openib -np 64 renumberMesh -overwrite -parallel
mpirun --mca btl ^openib -np 64 pimpleFoam -parallel



