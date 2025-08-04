{ pkgs, ... }:

{
    home.packages = [
        pkgs.jq
        pkgs.fd
        pkgs.fzf
        pkgs.wget
        pkgs.yq
        pkgs.eza
        pkgs.parallel
        pkgs.ripgrep
        pkgs.tlrc
        pkgs.zoxide
    ];
}
