{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    pkgs =
      nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [
        pkgs.ghdl # VHDL compiler studd
        pkgs.gtkwave # Waveform viewer
        pkgs.vhdl-ls # VHDL langserver
        pkgs.xxd # hex reader
        pkgs.hexedit # hex editor
        pkgs.python3

        pkgs.gcc
        pkgs.clang-tools
        pkgs.pkg-config
        pkgs.gnumake
        pkgs.bear
        pkgs.gdb
      ];
    };
  };
}
