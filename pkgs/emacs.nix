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
    rev = "b05aa8d742d80aeb692c54289e8ccb074a68bf51";
    sha256 = "1ypkwsgpl2g4w442kdlpx9rnw2mhfizi323jcpsm2v33j8zjx4r5";
  };
})
