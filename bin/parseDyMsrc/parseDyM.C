#include "argList.H"
#include "IOobjectList.H"
#include "volFields.H"
#include "timeSelector.H"
#include "OFstream.H"

using namespace Foam;

int main(int argc, char *argv[])
{
#   include "setRootCase.H"
#   include "createTime.H"

    IOobject dictIO
    (
        "dynamicMeshDict",
        runTime.constant(),
        runTime,
        IOobject::MUST_READ_IF_MODIFIED,
        IOobject::NO_WRITE
    );

    IOdictionary dict(dictIO);

    const dictionary& motionDicts = dict.subDict("multiSolidBodyMotionFvMeshCoeffs");
    Info<< "Read dictionary " << dict.name()  << endl;


    forAllConstIter(dictionary, motionDicts, zoneIter)
    {
        const word& name = zoneIter().keyword();
        const dictionary& coeffs = zoneIter().dict().subDict("rotatingMotionCoeffs");
        point CofG = coeffs.lookup("CofG");
        vector radialVelocity = coeffs.lookup("radialVelocity");
        OFstream writeCSV(name+".csv");

        Info<< "reading cellZone " << name << endl;

        // set reflection flag to 1 if radialVelocity.y() is positive
        writeCSV<< name << ","
                << (radialVelocity.y() > 0 ? "1," : "0,")
                << CofG << "," << radialVelocity << endl;
    }

    Info<< endl;

    Info<< "End\n" << endl;

    return 0;
}


// ************************************************************************* //
