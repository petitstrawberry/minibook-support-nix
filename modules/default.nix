{ config, lib, pkgs, ... }:

let
  cfg = config.services.minibook-support;
in
{
  options.services.minibook-support = {
    enable = lib.mkEnableOption "Enable CHUWI MiniBook support";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.minibook-support ];

    # systemd.services.moused = {
    #   description = "Daemon for the mouse of the MiniBook";
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.minibook-support}/bin/moused";
    #   };
    # };

    # systemd.services.keyboardd = {
    #   description = "Daemon for the keyboard of the MiniBook";
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.minibook-support}/bin/keyboardd";
    #   };
    # };

    # systemd.services.tabletmoded = {
    #   description = "Daemon for the tablet mode of the MiniBook";
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.minibook-support}/bin/tabletmoded";
    #   };
    # };
  };
}
