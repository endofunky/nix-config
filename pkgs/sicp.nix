with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "sicp";

  src = fetchurl {
    url = "https://www.neilvandyke.org/sicp-texi/sicp.info.gz";
    sha256 = "0qqb5czb24l85n4niwdgcs6ixrcjghpgls0cxf4idpsc9n7cgdvs";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p "$out/share/info"
    cp -v $src $out/share/info/sicp.info.gz
  '';
}
