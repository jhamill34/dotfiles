{ pkgs, ... }:

{
  imports = [
    ./custom/clickhouse.nix
  ];

  home.packages = [
    pkgs.postgresql
    pkgs.redis
  ];

  programs.lazysql = {
    enable = true;
    settings = { };
  };

  # programs.pgcli = {
  #   enable = true;
  #   settings = { };
  # };
}
