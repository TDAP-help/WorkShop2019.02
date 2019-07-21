for j in `seq 70 20 150`
do
rm -r $j
mkdir $j
cat > input.fdf <<!
AtomicCoordinatesFormat   Fractional
LatticeConstant  1.0  Ang

NumberOfAtoms 2
NumberOfSpecies 1

%block LatticeVectors
2.715000 2.715000 0.000000
0.000000 2.715000 2.715000
2.715000 0.000000 2.715000
%endblock LatticeVectors

%block ChemicalSpeciesLabel
 1  14  Si
%endblock ChemicalSpeciesLabel

%block AtomicCoordinatesAndAtomicSpecies
    0.00  0.00  0.00   1  Si        1
    0.25  0.25  0.25   1  Si        2
%endblock AtomicCoordinatesAndAtomicSpecies

MD.UseSaveXV T

SolutionMethod      diagon
XML.Write False
MaxSCFIterations 200
DM.AllowExtrapolation .false.
DM.UseSaveDM
DM.NumberPulay        5
SCF.Pulay.Damping     0.5

MeshCutoff $j Ry

DM.MixingWeight       0.3         # New DM amount for next SCF cycle
DM.Tolerance     1.d-4

XC.functional GGA
XC.authors  PBE

SCFMustConverge T
#SlabDipoleCorrection True
SaveRho       F
WriteMDHistory .true.
LongOutput
#WriteDenchar T
#WriteHirshfeldPop T
#PartialChargesAtEveryGeometry T

MD.TypeOfRun         cg
MD.NumCGsteps        200
MD.MaxCGDispl         0.1  Ang
MD.MaxForceTol        0.01 eV/Ang

%block kgrid_Monkhorst_Pack #only gamma k point
7 0 0 0.0
0 7 0 0.0
0 0 7 0.0
%endblock kgrid_Monkhorst_Pack
!
cp input.fdf $j
cp *.psf $j
cp run-siesta.sh $j
cd $j
sbatch run-siesta.sh
cd ..
done
