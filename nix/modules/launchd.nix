{ pkgs, ... }:

{
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
