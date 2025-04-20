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

            runtimeDependencies = [ pkgs.kmod ];

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
              license = pkgs.lib.licenses.mit;
              platforms = [ "x86_64-linux" ];
            };
          };
        }
      );

      nixosModules.default = { config, lib, pkgs, ... }: {
        options.services.minibook-support = {
          enable = lib.mkEnableOption "Enable CHUWI MiniBook support (moused, keyboardd, tabletmoded)";
        };

        config = lib.mkIf config.services.minibook-support.enable {
          environment.systemPackages = [ self.packages.${pkgs.system}.default ];

          systemd.services = {
            moused = {
              description = "Daemon for the mouse of the MiniBook";
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                ExecStart = "${self.packages.${pkgs.system}.default}/bin/moused -c";
              };
            };

            keyboardd = {
              description = "Daemon for the keyboard of the MiniBook";
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                ExecStart = "${self.packages.${pkgs.system}.default}/bin/keyboardd";
              };
            };

            tabletmoded = {
              description = "Daemon for the tablet mode of the MiniBook";
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                ExecStart = "${self.packages.${pkgs.system}.default}/bin/tabletmoded";
                Environment = [ "PATH=/run/current-system/sw/bin:/sbin:/usr/sbin:/bin:/usr/bin" ];
              };
            };
          };
        };
      };
    };
}