with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "qodem";

  src = fetchFromGitHub {
    owner = "klamonte";
    repo = "qodem";
    rev = "0b95200f30efb4e29f646b9df1dd770b46ddd3c2";
    sha256 = "14yhwvpc47nzr7aw5pppd7acxg3a34gv48cx8fy4dsp0wkjvg2ll";
  };

  buildInputs = with pkgs; [
    ncurses
    gpm
    automake115x
    autoconf
  ];
}
