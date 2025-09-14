{ config, pkgs, ... }:

let
  makeBraveApp = { name, profileName, displayName, userDataDir }: pkgs.stdenv.mkDerivation {
    pname = name;
    version = "1.0.0";

    buildCommand = ''
      mkdir -p "$out/Applications/${displayName}.app/Contents/MacOS"
      mkdir -p "$out/Applications/${displayName}.app/Contents/Resources"

      cat > "$out/Applications/${displayName}.app/Contents/Info.plist" << EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>${name}</string>
        <key>CFBundleIdentifier</key>
        <string>com.brave.${name}</string>
        <key>CFBundleName</key>
        <string>${displayName}</string>
        <key>CFBundleVersion</key>
        <string>1.0.0</string>
      </dict>
      </plist>
      EOF

      cat > "$out/Applications/${displayName}.app/Contents/MacOS/${name}" << 'EOF'
      #!/bin/bash
      exec ${pkgs.brave}/bin/brave \
        --user-data-dir="${userDataDir}" \
        --profile-directory="${profileName}" \
        --class="${displayName}" \
        --window-name="${displayName}" "$@"
      EOF

      chmod +x "$out/Applications/${displayName}.app/Contents/MacOS/${name}"
    '';
  };
in

{
  home.packages = [
    pkgs.brave
    (makeBraveApp {
      name = "brave-personal";
      profileName = "Personal";
      displayName = "Brave Personal";
      userDataDir = "${config.xdg.dataHome}/brave-personal";
    })
    (makeBraveApp {
      name = "brave-work";
      profileName = "Work";
      displayName = "Brave Work";
      userDataDir = "${config.xdg.dataHome}/brave-work";
    })
  ];
}
