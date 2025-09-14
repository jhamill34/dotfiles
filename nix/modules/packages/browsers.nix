{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--user-data-dir=\"${config.xdg.dataHome}/personal-data\""
      "--profile-directory=\"Personal\""
    ];
    # extensions = [ ];
  };
}
