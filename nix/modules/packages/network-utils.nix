{ pkgs, ... }:

{
    home.packages = [
        pkgs.dnsmasq
        pkgs.mkcert
        pkgs.ngrok
        pkgs.nss
    ];
}
