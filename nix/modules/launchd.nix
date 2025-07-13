{ pkgs, ... }:

{
  launchd.agents.jankyBordersAgent = {
    enable = true;
    config = {
        EnvironmentVariables = {
            PATH = "${pkgs.jankyborders}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
        Label = "tech.jhamill.jankyborders";
        ProgramArguments = [
            "${pkgs.jankyborders}/bin/borders"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/borders.out.log";
        StandardErrorPath = "/tmp/borders.err.log";
        ProcessType = "Interactive";
        LimitLoadToSessionType = [
                "Aqua"
                "Background"
                "LoginWindow"
                "StandardIO"
                "System"
        ];
    };
  };

  launchd.agents.sketchybarAgent = {
    enable = true;
    config = {
        EnvironmentVariables = {
            PATH = "${pkgs.sketchybar}/bin:${pkgs.aerospace}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
        Label = "tech.jhamill.sketchybar";
        ProgramArguments = [
            "${pkgs.sketchybar}/bin/sketchybar"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/sketchybar.out.log";
        StandardErrorPath = "/tmp/sketchybar.err.log";
        ProcessType = "Interactive";
        LimitLoadToSessionType = [
                "Aqua"
                "Background"
                "LoginWindow"
                "StandardIO"
                "System"
        ];
    };
  };
}