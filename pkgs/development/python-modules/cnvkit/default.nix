{ lib
, fetchFromGitHub
, rPackages
, buildPythonPackage
, biopython
, numpy
, scipy
, scikit-learn
, pandas
, matplotlib
, reportlab
, pysam
, future
, pillow
, pomegranate
, pyfaidx
, python
, R
, joblib
}:

buildPythonPackage rec {
  pname = "CNVkit";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "etal";
    repo = "cnvkit";
    rev = "v${version}";
    sha256 = "sha256-QT4SvznebJNzowyC1bkzk5YWNU9KJTusKiPMkKE8lOA=";
  };

  propagatedBuildInputs = [
    biopython
    numpy
    scipy
    scikit-learn
    pandas
    matplotlib
    reportlab
    pyfaidx
    pysam
    future
    pillow
    pomegranate
    rPackages.DNAcopy
    joblib
  ];

  checkInputs = [ R ];

  checkPhase = ''
    pushd test/
    ${python.interpreter} test_io.py
    ${python.interpreter} test_genome.py
    ${python.interpreter} test_cnvlib.py
    ${python.interpreter} test_commands.py
    ${python.interpreter} test_r.py
  '';

  meta = with lib; {
    homepage = "https://cnvkit.readthedocs.io";
    description = "A Python library and command-line software toolkit to infer and visualize copy number from high-throughput DNA sequencing data";
    license = licenses.asl20;
    maintainers = [ maintainers.jbedo ];
  };
}
