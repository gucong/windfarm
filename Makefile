combineMesh : bin rotorMesh statorMesh
	bin/combineMesh.sh

rotorMesh : rotor
	bin/meshRotor.sh

statorMesh : bin stator
	bin/meshStator.sh

bin : bin/parseDyM

bin/parseDyM : bin/parseDyMsrc/parseDyM.C
	cd bin/parseDyMsrc; wmake > log.wmake 2>&1

windFarmCase.tgz : combineMesh
	cd combineMesh; tar zcvf ../windFarmCase.tgz windFarmCase

cleanCase :
	-rm -rf combineMesh

cleanRotor :
	-rm -rf rotorMesh

cleanStator :
	-rm -rf statorMesh

cleanBin :
	-rm bin/parseDyM
	-cd bin/parseDyMsrc; wclean

cleanAll : cleanCase cleanRotor cleanStator cleanBin
