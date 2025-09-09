{ pkgs, ... }:

{
  imports = [
    ./custom/clickhouse.nix
  ];

  # TODO: update lazysql
  home.packages = [
    # TODO: pgcli
    pkgs.postgresql
    pkgs.redis

    # pkgs.lazysql
  ];
}
