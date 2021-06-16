{ lib, stdenv, fetchFromGitHub , gtk3, adwaita-icon-theme, breeze-icons, hicolor-icon-theme }:

stdenv.mkDerivation rec  {
  pname = "kora-icon-theme";
  version = "1.4.3";

  src = fetchFromGitHub  {
    owner = "bikass";
    repo = "kora";
    rev = "v${version}";
    sha256 = "sha256-tSkTwhhugvDTzzcxIln1xq3ZY6boHJR0LRGy20ONO5U=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    breeze-icons
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv kora* $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache -f $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "An SVG icon theme in four variants";
    homepage = "https://github.com/bikass/kora";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ bloomvdomino ];
  };
}
