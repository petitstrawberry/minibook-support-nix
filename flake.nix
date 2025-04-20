{
  description = "Nix and NixOS module for minibook-support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          minibook-support-src = pkgs.fetchFromGitHub {
            owner = "petitstrawberry";
            repo = "minibook-support";
            rev = "1.3.1";
            sha256 = "sha256-kg4s9J+YtszrUsCR0nEzHFSAoInecmDmTefcsOZr02c=";
          };
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "minibook-support";
            version = "1.3.1";
            src = minibook-support-src;

            buildPhase = ''
              make
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp moused/bin/moused $out/bin/
              cp keyboardd/bin/keyboardd $out/bin/
              cp tabletmoded/bin/tabletmoded $out/bin/
            '';

            meta = {
              description = "Support package for CHUWI MiniBook";
              homepage = "https://github.com/petitstrawberry/minibook-support";
              license = "MIT";
              platforms = [ "x86_64-linux" ];
            };
          };
        }
      );

      overlays.default = final: prev: {
        minibook-support = self.packages.${prev.system}.default;
      };

      nixosModules.minibook-support = {
        imports = [ ./modules/default.nix ];
      };
    };
}
