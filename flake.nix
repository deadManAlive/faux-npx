{
  description = "Simple C program that prints command line arguments";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        npxBinary = pkgs.stdenv.mkDerivation {
          pname = "npx";
          version = "0.1.0";
          src = ./.;
          buildInputs = [ pkgs.gcc ];
          buildPhase = ''
            mkdir -p $out/bin
            gcc src/main.c -o $out/bin/npx
          '';
          installPhase = "true";
        };
      in
      {
        packages.default = npxBinary;

        apps.default = {
          type = "app";
          program = "${npxBinary}/bin/npx";  # ← use local variable
        };
      });

}
