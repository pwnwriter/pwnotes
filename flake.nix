{
  description = "pwnwriter's random notes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.mdbook
          ];
        };

        packages.mdbookBuild = pkgs.stdenv.mkDerivation {
          name = "mdbook-build";
          src = ./.;
          buildInputs = [ pkgs.mdbook ];
          buildPhase = ''
            mdbook build
          '';
          installPhase = ''
            mkdir -p $out
            cp -r book/* $out/
          '';
        };
      }
    );
}

