with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "asdf-0.7.2";

  src = fetchurl {
    url = "https://github.com/asdf-vm/asdf/archive/v0.7.2.tar.gz";
    sha256 = "1c53c1dfabfdbdee3c9b34e396655d963aeb362a8173e956233ac2689d696a34";
  };

  phases = "installPhase fixupPhase";

  buildInputs = [ gnutar ];

  installPhase = ''
    PATH=~/.asdf/shims:$PATH

    mkdir -p $out/asdf
    mkdir -p $out/bin
    ${pkgs.gnutar}/bin/tar xf $src --strip 1 -C $out/asdf
    echo "#! ${stdenv.shell}" >> "$out/bin/asdf"
    echo "exec $out/asdf/bin/asdf \$*" >> "$out/bin/asdf"
    chmod +x $out/bin/asdf

    mkdir -p $out/share/bash-completion/completions/
    ln -s $out/asdf/completions/asdf/bash/asdf.bash $out/share/bash-completion/asdf.bash
  '';

  shellHook = ''
    export PATH="$PWD/node_modules/.bin/:$PATH"
  '';
}
