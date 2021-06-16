{ mkDerivation
, alsa-lib
, autoPatchelfHook
, fetchurl
, flac
, lib
, libmicrohttpd
, llvmPackages_10
, qtcharts
, qtdeclarative
, qtquickcontrols2
, qtwebengine
, qtwebview
, rpmextract
, wavpack
}:

mkDerivation rec {
  pname = "hqplayer-desktop";
  version = "4.12.0-34";

  src = fetchurl {
    url = "https://www.signalyst.eu/bins/hqplayer/fc33/hqplayer4desktop-${version}.fc33.x86_64.rpm";
    sha256 = "sha256-9kLKmi5lNtnRm9b4HnO01cO/C+Sg0DcKD64N5WBbYOE=";
  };

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract $src
  '';

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];

  buildInputs = [
    alsa-lib
    flac
    libmicrohttpd
    llvmPackages_10.openmp
    qtquickcontrols2
    qtcharts
    qtdeclarative
    qtwebengine
    qtwebview
    wavpack
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    # main executable
    mkdir -p $out/bin
    cp ./usr/bin/* $out/bin

    # desktop files
    mkdir -p $out/share/applications
    cp ./usr/share/applications/* $out/share/applications

    # documentation
    mkdir -p $out/share/doc/${pname}
    cp ./usr/share/doc/hqplayer4desktop/* $out/share/doc/${pname}

    # pixmaps
    mkdir -p $out/share/pixmaps
    cp ./usr/share/pixmaps/* $out/share/pixmaps
  '';

  postInstall = ''
    for desktopFile in $out/share/applications/*; do
      substituteInPlace "$desktopFile" \
        --replace '/usr/bin/' '$out/bin/' \
        --replace '/usr/share/doc/' '$out/share/doc/'
    done

    gunzip $out/share/doc/${pname}/*.gz
  '';

  postFixup = ''
    patchelf --replace-needed libomp.so.5 libomp.so $out/bin/.hqplayer4desktop-wrapped
  '';

  meta = with lib; {
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software HD-audio player";
    changelog = "https://www.signalyst.eu/bins/${pname}/fc33/hqplayer4desktop-${version}fc33.x86_64.changes";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
