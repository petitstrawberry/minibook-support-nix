{
  description = "Nix and NixOS module for minibook-support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    minibook-support-src.url = "github:petitstrawberry/minibook-support";
  };

  outputs = { self, nixpkgs, minibook-support-src, ... }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "minibook-support";
            version = "unstable-2025-04-20";
            src = minibook-support-src;

            buildInputs = [ pkgs.gcc pkgs.make ]; # 必要なビルドツールを指定

            buildPhase = ''
              make -C src
            '';

            installPhase = ''
              # バイナリを配置
              mkdir -p $out/bin
              cp src/moused/bin/moused $out/bin/
              cp src/keyboardd/bin/keyboardd $out/bin/
              cp src/tabletmoded/bin/tabletmoded $out/bin/

              # systemdサービスファイルを配置
              mkdir -p $out/lib/systemd/system
              cp src/moused/install/moused.service $out/lib/systemd/system/
              cp src/keyboardd/install/keyboardd.service $out/lib/systemd/system/
              cp src/tabletmoded/install/tabletmoded.service $out/lib/systemd/system/
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

      nixosModules.minibook-support = import ./modules;
    };
}
