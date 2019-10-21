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
    rev = "435eb82e7b7e8926a3675bac74713e7c6081f7db";
    sha256 = "13x9v67hb0zqq9y7mpcwrbc70jak9cxliwjqwmkjgjafasja77nb";
  };
})
