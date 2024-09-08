{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, nixpkgs, flake-utils, treefmt-nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        stdenv = pkgs.stdenv;
        zig = pkgs.zig_0_13;
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

        grep-zig = stdenv.mkDerivation {
          pname = "grep-zig";
          version = "dev";

          src = lib.cleanSource ./.;

          nativeBuildInputs = [
            zig.hook
          ];

          zigBuildInputs = [
            "-Doptimize=Debug"
          ];
        };
      in
      {
        packages = {
          inherit grep-zig;
          default = grep-zig;
        };

        formatter = treefmtEval.config.build.wrapper;

        checks = {
          inherit grep-zig;
          formatting = treefmtEval.config.build.check self;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            # Ziglang
            zig
            pkgs.zls

            # Nixlang
            pkgs.nil
          ];

          shellHook = ''
            export PS1="\n[nix-shell:\w]$ "
          '';
        };
      });
}
