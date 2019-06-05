with import <nixpkgs> {};

stdenv.lib.overrideDerivation (pkgs.emacs.override {
  srcRepo = true;
  withGTK2 = false;
  withGTK3 = false;
  withCsrc = true;
}) (attrs: rec {
  name = "emacs-${version}${versionModifier}";
  version = "27.0";
  versionModifier = ".50";

  doCheck = false;

  patches = null;

  configureFlags = if stdenv.isDarwin then attrs.configureFlags else [
    "--disable-build-details"
    "--with-modules"
    "--with-x-toolkit=no"
    "--with-xft"
    "--with-imagemagick"
  ];

  src = fetchgit {
    url = https://git.savannah.gnu.org/git/emacs.git;
    rev = "7aaf500701be3b51c686b7d86c9b505ef5fa9b8f";
    sha256 = "03l7ffibsxbiyn0xdmc6888ichb2mkrdrl5migrzp478gxy6614w";
  };
})
