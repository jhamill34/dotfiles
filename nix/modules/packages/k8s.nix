{ pkgs, ... }:

{
  # TODO: Update k9s
  home.packages = [
    pkgs.k3d
    pkgs.k9s
    pkgs.kubectl

    # TODO: Kubeswitch?
    pkgs.kubectx
    pkgs.kubernetes-helm
    pkgs.tilt
  ];
}
