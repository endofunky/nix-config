with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "irssi-fish";

  src = fetchFromGitHub {
    owner  = "falsovsky";
    repo   = "FiSH-irssi";
    rev    = "1171606ef327246b7f1659c993811abe91d27871";
    sha256 = "1l09yr8iskgilj119i8ispkrd1qakipms5w78fg24688wxj6vl2q";
  };

  buildInputs = [ cmake openssl pcre glib irssi pkg-config ];

  cmakeFlags = [ "-DIRSSI_INCLUDE_DIR:PATH=${irssi}/include/irssi" ];
}
