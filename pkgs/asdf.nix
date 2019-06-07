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
    mkdir -p $out/share/asdf
    ${pkgs.gnutar}/bin/tar xf $src --strip 1 -C $out/share/asdf

    mkdir -p $out/bin
    echo "#! ${stdenv.shell}" >> "$out/bin/asdf"
    echo "exec $out/share/asdf/bin/asdf \$*" >> "$out/bin/asdf"
    chmod +x $out/bin/asdf

    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d}
    cp $out/share/asdf/completions/asdf.bash "$out/share/bash-completion/completions/"
    cp $out/share/asdf/completions/asdf.fish "$out/share/fish/vendor_completions.d/"
  '';
}
