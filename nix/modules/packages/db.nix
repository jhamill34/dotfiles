{ pkgs, ... }:

{
    imports = [
        ./custom/clickhouse.nix
    ];

    home.packages = [
        pkgs.postgresql
        pkgs.redis
    ];
}
