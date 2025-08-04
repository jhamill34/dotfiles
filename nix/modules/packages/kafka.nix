{ pkgs, ... }:

{
    home.packages = [
        pkgs.kafkactl
        pkgs.confluent-platform
    ];
}
