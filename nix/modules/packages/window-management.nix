{ pkgs, lib, ... }:

{
  programs.sketchybar = {
    enable = true;

    config = {
      source = ../../home/sketchybar;
      recursive = true;
    };
    configType = "bash";

    # configType = "lua"; 
    # luaPackage = pkgs.lua5_4;
    # extraLuaPackages = [];
    # sbarLuaPackage = pkgs.sbarlua;

    extraPackages = [
      pkgs.aerospace
    ];
    includeSystemPath = true;

    service = {
      enable = true;
      outLogFile = "/tmp/sketchybar.out.log";
      errorLogFile = "/tmp/sketchybar.err.log";
    };
  };

  services.jankyborders = {
    enable = true;
    outLogFile = "/tmp/borders.out.log";
    errorLogFile = "/tmp/borders.err.log";

    # rosewater="0xfff5e0dc"
    # flamingo="0xfff2cdcd"

    settings = {
      style = "round";
      width = 6.0;
      hidpi = "off";
      active_color = "0xffb4befe";
      inactive_color = "0xff1e1e2e";
      blacklist = "Loom";
    };
  };

  programs.aerospace = {
    enable = true;

    launchd = {
      enable = true;
      keepAlive = true;
    };

    userSettings = {
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${lib.getExe pkgs.sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 150;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = [
        "move-mouse monitor-lazy-center"
      ];
      automatically-unhide-macos-hidden-apps = false;
      key-mapping.preset = "qwerty";
      gaps = {
        inner.horizontal = 16;
        inner.vertical = 16;
        outer.left = 16;
        outer.bottom = 16;
        outer.top = 58;
        outer.right = 16;
      };

      mode = {
        main.binding = {
          # See: https://nikitabobko.github.io/AeroSpace/commands#layout;
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          # See: https://nikitabobko.github.io/AeroSpace/commands#focus;
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#move;
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#resize;
          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace;
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";

          # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace;
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth;
          alt-tab = "workspace-back-and-forth";
          # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor;

          # See: https://nikitabobko.github.io/AeroSpace/commands#mode;
          alt-shift-semicolon = "mode service";
          alt-shift-comma = "mode launcher";
        };

        service.binding = {
          esc = [ "reload-config" "mode main" ];

          # reset layout
          r = [ "flatten-workspace-tree" "mode main" ];

          # Toggle between floating and tiling layout
          f = [ "layout floating tiling" "mode main" ];

          backspace = [ "close-all-windows-but-current" "mode main" ];

          alt-shift-h = [ "join-with left" "mode main" ];
          alt-shift-j = [ "join-with down" "mode main" ];
          alt-shift-k = [ "join-with up" "mode main" ];
          alt-shift-l = [ "join-with right" "mode main" ];

          alt-ctrl-shift-h = [ "move-workspace-to-monitor --wrap-around next" "mode main" ];
          alt-ctrl-shift-l = [ "move-workspace-to-monitor --wrap-around prev" "mode main" ];

          down = "volume down";
          up = "volume up";
          shift-down = [ "volume set 0" "mode main" ];
        };

        launcher.binding = {
          esc = [ "mode main" ];

          y = [ "exec-and-forget open -a zoom.us" "mode main" ];
          u = [ "exec-and-forget open -a Spark\\ Desktop" "mode main" ];
          i = [ "exec-and-forget open -a Slack" "mode main" ];
          o = [ "exec-and-forget open -a Brave\\ Work" "mode main" ];

          j = [ "exec-and-forget open -a IntelliJ\\ IDEA" "mode main" ];
          k = [ "exec-and-forget open -a kitty" "mode main" ];
          l = [ "exec-and-forget open -a Brave\\ Personal" "mode main" ];

          h = [ "exec-and-forget open -a Spotify" "mode main" ];
        };
      };
    };
  };
}
