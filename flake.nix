{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    pkgs =
      nixpkgs.legacyPackages.x86_64-linux.appendOverlays
      [
        (final: prev: {
          verible = prev.stdenv.mkDerivation rec {
            pname = "verible";
            version = "v0.0.4023";

            # GitHub release binary tarball
            src = prev.fetchurl {
              url = "https://github.com/chipsalliance/verible/releases/download/v0.0-4023-gc1271a00/verible-v0.0-4023-gc1271a00-linux-static-x86_64.tar.gz";
              sha256 = "sha256-MMIDhZVvUu+JLLWPf4Fvn5qdw3oEMoSKScbZqjpyqLc=";
            };

            nativeBuildInputs = [prev.autoPatchelfHook];

            # Required for patching dynamic binaries
            buildInputs = [prev.stdenv.cc.cc.lib];

            # Unpack the tarball (not a source build)
            dontBuild = true;

            installPhase = ''
              mkdir -p $out
              cp -r * $out/
            '';

            meta = with prev.lib; {
              description = "Verible is a suite of SystemVerilog developer tools";
              homepage = "https://github.com/chipsalliance/verible";
              license = licenses.asl20;
              platforms = platforms.linux;
            };
          };
        })
      ];
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [
        pkgs.gcc
        pkgs.clang-tools
        pkgs.pkg-config
        pkgs.gnumake
        pkgs.bear
        pkgs.gdb

        pkgs.verilator
        pkgs.python3

        pkgs.verible
      ];
    };
  };
}
