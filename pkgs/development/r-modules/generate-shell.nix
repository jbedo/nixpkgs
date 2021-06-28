with import ../../.. {};

stdenv.mkDerivation {
  name = "generate-r-packages-shell";

  buildCommand = "exit 1";

  buildInputs = [ wget ];

  nativeBuildInputs = [
    nix
    git
    (rWrapper.override {
      packages = with rPackages; [
        data_table
        parallel
        BiocManager
      ];
    })
  ];
}
