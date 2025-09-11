{ pkgs, lib, ... }:

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
    extraConfig = ''
      macos_titlebar_color background
    '';
    # keybindings = {};

    themeFile = "Catppuccin-Mocha";
    font = {
      package = pkgs.nerd-fonts.terminess-ttf;
      name = "Terminess Nerd Font Mono";
      size = 16.0;
    };
    shellIntegration = {
      enableZshIntegration = true;
      mode = "no-cursor";
    };
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
    newSession = true;
    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = ''
      bind | split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'

      bind-key m resize-pane -Z 

      set -g renumber-windows on
    '';

    plugins = [
      # tmuxPlugins.sidebar;
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.yank
      pkgs.tmuxPlugins.cpu
      pkgs.tmuxPlugins.battery
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          setw -g mode-style "reverse" #!important
          set-option -g status-position top
          set -gF "status-format[1]" ""
          set -g status 2

          # Configure the catppuccin plugin
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_default_text "#{b:pane_current_path}"
          set -g @catppuccin_window_text "#{b:pane_current_path}"
          set -g @catppuccin_window_current_text "#{b:pane_current_path}#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"

          setw -g @catppuccin_pane_active_border_style "##{?pane_in_mode,fg=#{@thm_lavender},##{?pane_synchronized,fg=#{@thm_mauve},fg=#{@thm_lavender}}}"
          setw -g @catppuccin_pane_background_color "#{@thm_surface_0}"
          setw -g @catppuccin_pane_border_status "yes"
          setw -g @catppuccin_pane_border_style "fg=#{@thm_surface_0},bg=#{@thm_mantle}"
          setw -g @catppuccin_pane_color "#{@thm_green}"
          setw -g @catppuccin_pane_default_fill "number"
          setw -g @catppuccin_pane_default_text "##{b:pane_current_command}"
          setw -g @catppuccin_pane_color "#{@thm_teal}"
          setw -g @catppuccin_pane_left_separator  " "
          setw -g @catppuccin_pane_number_position "left"
          setw -g @catppuccin_pane_middle_separator  ""
          setw -g @catppuccin_pane_right_separator " "
          setw -g @catppuccin_pane_status_enabled "yes"

          setw -g pane-border-lines heavy
          setw -g pane-border-status top

          # Make the status line pretty and add some modules
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left "#{E:@catppuccin_status_session}"

          set -g status-right "#{E:@catppuccin_status_application}"
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          set -agF status-right "#{E:@catppuccin_status_battery}"

          set -g window-style "bg=#{@thm_mantle}"
          set -g window-active-style "bg=#{@thm_bg}"
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

    settings = {
      format = lib.concatStrings [
        "[](red)"
        "$os"
        "$username"
        "[](bg:peach fg:red)"
        "$directory"
        "[](bg:yellow fg:peach)"
        "$git_branch"
        "$git_status"
        "[](fg:yellow bg:green)"
        "$c"
        "$rust"
        "$golang"
        "$nodejs"
        "$php"
        "$java"
        "$kotlin"
        "$haskell"
        "$python"
        "[](fg:green bg:sapphire)"
        "$conda"
        "[](fg:sapphire bg:lavender)"
        "$time"
        "[ ](fg:lavender)"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      palette = "catppuccin_mocha";
      os = {
        disabled = false;
        style = "bg:red fg:crust";
        symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:red fg:crust";
        style_root = "bg:red fg:crust";
        format = "[ $user]($style)";
      };

      directory = {
        style = "bg:peach fg:crust";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:yellow";
        format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)";
      };

      git_status = {
        style = "bg:yellow";
        format = "[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol ($version) ](fg:crust bg:green)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol ($version) ](fg:crust bg:green)]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:green";
        format = "[[ $symbol ($version) ](fg:crust bg:green)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol ($version) ](fg:crust bg:green)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol ($version) ](fg:crust bg:green)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol ($version) (\( #$virtualenv\)) ](fg:crust bg:green)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:sapphire";
        format = "[[ $symbol ($context) ](fg:crust bg:sapphire)]($style)";
      };

      conda = {
        symbol = "  ";
        style = "fg:crust bg:sapphire";
        format = "[ $symbol$environment ] ($style)";
        ignore_base = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:lavender";
        format = "[[  $time ](fg:crust bg:lavender)]($style)";
      };

      line_break = {
        disabled = true;
      };

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:green)";
        error_symbol = "[❯](bold fg:red)";
        vimcmd_symbol = "[❮](bold fg:green)";
        vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
        vimcmd_replace_symbol = "[❮](bold fg:lavender)";
        vimcmd_visual_symbol = "[❮](bold fg:yellow)";
      };

      cmd_duration = {
        show_milliseconds = true;
        format = " in $duration ";
        style = "bg:lavender";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };

      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    };
  };
}

