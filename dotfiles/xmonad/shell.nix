{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

haskell.lib.buildStackProject {
  inherit ghc;
  name = "xmonad-ef";
  buildInputs = [
    alsaLib
    pkg-config
    x11
    xmonad-spotify
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXext
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
  ];
}
