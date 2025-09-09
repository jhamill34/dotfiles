{ pkgs, ... }:

{
  home.packages = [
    pkgs.aws-sam-cli
    pkgs.pulumi
    pkgs.pulumictl
  ];

  programs.awscli = {
    enable = true;

    credentials = { };
    settings = {
      "default" = {
        region = "us-east-2";
        output = "json";
      };
    };
  };
}
