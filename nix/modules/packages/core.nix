{ pkgs, ... }:

{
  home.packages = [
    pkgs.mkalias
    pkgs.stow
  ];

  programs.zsh = {
    enable = true;
    # initVariables = {};
    # initContent = "";
    antidote = {
      enable = true;
      # plugins = [];
    };
  };

  programs.kitty = {
    enable = true;
    # environment = {};
    # extraConfig = "";
    # keybindings = {};

    themeFile = "Catppuccin-Mocha";
    font = {
      package = pkgs.nerd-fonts.terminess-ttf;
      name = "Terminess Nerd Font Mono";
      size = 16.0;
    };
    shellIntegration.enableZshIntegration = true;
    settings = { };
  };

  programs.tmux = {
    enable = true;

    terminal = "tmux-256color";
    escapeTime = 500;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = true;
    prefix = "C-b";

    plugins = [
      {
        plugin = pkgs.tmuxPlugins.sensible;
        extraConfig = ''
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.yank;
        extraConfig = ''
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.cpu;
        extraConfig = ''
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.battery;
        extraConfig = ''
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
        '';
      }
    ];

    tmuxinator.enable = true;
  };

  programs.sesh = {
    enable = true;

    zoxidePackage = pkgs.zoxide;
    fzfPackage = pkgs.fzf;

    enableTmuxIntegration = true;
    tmuxKey = "o";

    settings = { };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # TODO: add config here...
    settings = { };
  };
}
