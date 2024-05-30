#!/bin/bash
#SBATCH --job-name=solidTE_Meshing
#SBATCH --time=2:00:00
#SBATCH --ntasks=36
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=2G

module load OpenFOAM/v2106-foss-2021a
. ${FOAM_BASH}

rm -r 0* 1* 2* 3* 4* 5* 6* 7* 8* 9* pro* post* acou*
cp -r C0.orig 0
cp constant/turbulenceProperties_RANS constant/turbulenceProperties
cp system/controlDict_RANS system/controlDict
cp system/fvSchemes_RANS system/fvSchemes
cp system/fvSolution_RANS system/fvSolution
cp system/decomposeParDict_Mesh system/decomposeParDict
blockMesh
surfaceFeatureExtract
cp system/meshQualityDict_snap system/meshQualityDict
snappyHexMesh -dict system/snappyHexMeshDict_Region -overwrite
decomposePar
mpirun --mca btl ^openib -np 36 snappyHexMesh -overwrite -parallel
reconstructParMesh -constant
rm -r pro*
checkMesh
cp system/meshQualityDict_BL system/meshQualityDict
rm constant/polyMesh/cellLevel
rm constant/polyMesh/pointLevel
decomposePar
mpirun --mca btl ^openib -np 36 snappyHexMesh -dict system/snappyHexMeshDict_BL -parallel -overwrite
reconstructParMesh -constant
rm -r pro*
createPatch -overwrite
checkMesh
