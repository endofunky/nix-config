with import <nixpkgs> {};

stdenv.lib.overrideDerivation (pkgs.emacs.override {
  srcRepo = true;
  withXwidgets = true;
}) (attrs: rec {
  name = "emacs-${version}${versionModifier}";
  version = "27.0";
  versionModifier = ".50";

  doCheck = false;

  patches = null;

  configureflags = attrs.configureFlags ++ [
    "--with-harfbuzz"
    "--with-json"
  ];

  buildInputs = attrs.buildInputs ++ [
    harfbuzz
    jansson
  ];

  src = fetchFromGitHub {
    owner = "emacs-mirror";
    repo = "emacs";
    rev = "af724ed5942fc7de431c8d169599e7b5456dff0b";
    sha256 = "1fjz4x9x0gjvcjr14gf58dmpbkf0cfma0svb12nnzgimf5wslvmv";
    # date = 2019-11-28T17:42:47+02:00;
  };
})
