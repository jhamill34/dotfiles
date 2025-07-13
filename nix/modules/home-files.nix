{ ... }:

{
  home.file = {
    ".zshrc".source = ../home/dot-zshrc;
    ".tmux.conf".source = ../home/dot-tmux.conf;
    ".aerospace.toml".source = ../home/dot-aerospace.toml;
    ".gitconfig".source = ../home/dot-gitconfig;
    ".config" = {
        source = ../home/dot-config;
        recursive = true;
     };

    "Code/Personal/README.md".text = ''
      # Personal Work
      This directory is intended to be used for personal projects. 
    '';
    "Code/Work/README.md".text = ''
      # Work
      This directory is intended to be used for work projects only. 
    '';
  };
}