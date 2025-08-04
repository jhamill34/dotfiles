{ pkgs, ... }:

{
    home.packages = [
        pkgs.k3d
        pkgs.k9s
        pkgs.kubectl
        pkgs.kubectx
        pkgs.kubernetes-helm
        pkgs.tilt
    ];
}
