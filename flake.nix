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

              # # Copy systemd service files
              # mkdir -p $out/etc/systemd/system
              # install -Dm 0644 moused/install/moused.service $out/etc/systemd/system/moused.service
              # install -Dm 0644 keyboardd/install/keyboardd.service $out/etc/systemd/system/keyboardd.service
              # install -Dm 0644 tabletmoded/install/tabletmoded.service $out/etc/systemd/system/tabletmoded.service
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

      nixosModules.default = { config, pkgs, ... }: {
        # systemd.units = {
        #   "moused.service".enable = true;
        #   "keyboardd.service".enable = true;
        #   "tabletmoded.service".enable = true;
        # };
        systemd.services = {
          moused = {
            description = "Daemon for the mouse of the MiniBook";
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${self.packages.${pkgs.system}.default}/bin/moused";
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
            };
          };
        };

        environment.systemPackages = [ self.packages.${pkgs.system}.default ];
      };
    };
}