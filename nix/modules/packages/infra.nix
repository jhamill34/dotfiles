{ pkgs, ... }:

{
  # TODO: update awscli
  home.packages = [
    pkgs.aws-sam-cli
    pkgs.awscli2
    pkgs.pulumi
    pkgs.pulumictl
  ];
}
