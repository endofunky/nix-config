{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  haskell = haskellPackages.ghcWithPackages (ps: with ps; [
    hlint
    hasktags
    xmonad
    xmonad-contrib
    xmonad-extras
  ]);
in
mkShell {
  buildInputs = with pkgs; [ haskell ];
}
