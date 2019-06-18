with import <nixpkgs> {};

stdenv.lib.overrideDerivation (pkgs.emacs.override {
  srcRepo = true;
}) (attrs: rec {
  name = "emacs-${version}${versionModifier}";
  version = "27.0";
  versionModifier = ".50";

  doCheck = false;

  patches = null;

  src = fetchFromGitHub {
    owner = "emacs-mirror";
    repo = "emacs";
    rev = "7aaf500701be3b51c686b7d86c9b505ef5fa9b8f";
    sha256 = "03l7ffibsxbiyn0xdmc6888ichb2mkrdrl5migrzp478gxy6614w";
  };
})
