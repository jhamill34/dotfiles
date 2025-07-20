{ pkgs, ... }:

{
  home.packages = [
    pkgs.aws-sam-cli
    pkgs.awscli2
    pkgs.confluent-platform
    pkgs.d2
    pkgs.eza
    pkgs.gh
    pkgs.git-spice
    pkgs.go
    pkgs.gradle
    pkgs.k3d
    pkgs.k9s
    pkgs.kafkactl
    pkgs.kind
    pkgs.kubectl
    pkgs.kubectx
    pkgs.kubernetes-helm
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.mkalias
    pkgs.mkcert
    pkgs.neovim
    pkgs.ngrok
    pkgs.nss
    pkgs.oh-my-posh
    pkgs.openapi-generator-cli
    pkgs.parallel
    pkgs.pokemon-colorscripts-mac
    pkgs.postgresql
    pkgs.pulumi
    pkgs.pulumictl
    pkgs.pyenv
    pkgs.rbenv
    pkgs.redis
    pkgs.ripgrep
    pkgs.rustup
    pkgs.typst
    pkgs.tlrc
    pkgs.tilt
    pkgs.zoxide

    # pkgs.clickhouse
    pkgs.dnsmasq
 
    # NOTE: 
    #  We'll use the homebrew cask for now, spent too much 
    #  time trying to get lima/colima working with test containers
    #
    pkgs.docker # <- just the docker cli
    pkgs.colima # <- keep for now, its a wrapper around lima

    pkgs.nodejs_22 # NodeJS
    # pkgs.claude-code

    pkgs._1password-cli
    pkgs.aerospace
    pkgs.jankyborders
    pkgs.jetbrains.idea-ultimate
    pkgs.kitty
    pkgs.sketchybar
    pkgs.slack
    pkgs.spotify
    pkgs.zoom-us
  ];
}
