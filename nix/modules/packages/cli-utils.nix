{ pkgs, ... }:

{
  home.packages = [
    pkgs.wget
    pkgs.yq
    pkgs.parallel
    pkgs.tlrc
  ];

  programs.jq = {
    enable = true;
    # colors = {
    #     null = "1;30";
    #     false = "0;31";
    #     true = "0;32";
    #     numbers = "0;36";
    #     strings = "0;33";
    #     arrays = "1;35";
    #     objects = "1;37";
    #     objectKeys = "1;34";
    # };
  };

  programs.fd = {
    enable = true;
    # extraOptions = [];
    # hidden = false;
    # ignores = [];
  };

  programs.ripgrep = {
    enable = true;
    # arguments = []
  };

  # programs.ripgrep-all = {
  #   enable = true;
  #   custom_adapters = [];
  # };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    colors = {
      "bg+" = "#313244";
      "bg" = "#1E1E2E";
      "spinner" = "#F5E0DC";
      "hl" = "#F38BA8";
      "fg" = "#CDD6F4";
      "header" = "#F38BA8";
      "info" = "#CBA6F7";
      "pointer" = "#F5E0DC";
      "marker" = "#B4BEFE";
      "fg+" = "#CDD6F4";
      "prompt" = "#CBA6F7";
      "hl+" = "#F38BA8";
      "selected-bg" = "#45475A";
      "border" = "#B4BEFE";
      "label" = "#CDD6F4";
    };

    # defaultCommand = "";
    defaultOptions = [
      "--border"
      "bold"
    ];
    # fileWidgetCommand = "";
    # fileWidgetOptions = [];
    # historyWidgetOptions = [];

    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd"
      "cd"
      "zsh"
    ];
  };

  programs.eza = {
    enable = true;
    icons = "always";
    colors = "always";
    git = true;
    enableZshIntegration = true;
    theme = {
      colourful = true;

      filekinds = {
        normal = { foreground = "#BAC2DE"; };
        directory = { foreground = "#89B4FA"; };
        symlink = { foreground = "#89DCEB"; };
        pipe = { foreground = "#7F849C"; };
        block_device = { foreground = "#EBA0AC"; };
        char_device = { foreground = "#EBA0AC"; };
        socket = { foreground = "#585B70"; };
        special = { foreground = "#CBA6F7"; };
        executable = { foreground = "#A6E3A1"; };
        mount_point = { foreground = "#74C7EC"; };
      };

      perms = {
        user_read = { foreground = "#CDD6F4"; };
        user_write = { foreground = "#F9E2AF"; };
        user_execute_file = { foreground = "#A6E3A1"; };
        user_execute_other = { foreground = "#A6E3A1"; };
        group_read = { foreground = "#BAC2DE"; };
        group_write = { foreground = "#F9E2AF"; };
        group_execute = { foreground = "#A6E3A1"; };
        other_read = { foreground = "#A6ADC8"; };
        other_write = { foreground = "#F9E2AF"; };
        other_execute = { foreground = "#A6E3A1"; };
        special_user_file = { foreground = "#CBA6F7"; };
        special_other = { foreground = "#585B70"; };
        attribute = { foreground = "#A6ADC8"; };
      };

      size = {
        major = { foreground = "#A6ADC8"; };
        minor = { foreground = "#89DCEB"; };
        number_byte = { foreground = "#CDD6F4"; };
        number_kilo = { foreground = "#BAC2DE"; };
        number_mega = { foreground = "#89B4FA"; };
        number_giga = { foreground = "#CBA6F7"; };
        number_huge = { foreground = "#CBA6F7"; };
        unit_byte = { foreground = "#A6ADC8"; };
        unit_kilo = { foreground = "#89B4FA"; };
        unit_mega = { foreground = "#CBA6F7"; };
        unit_giga = { foreground = "#CBA6F7"; };
        unit_huge = { foreground = "#74C7EC"; };
      };

      users = {
        user_you = { foreground = "#CDD6F4"; };
        user_root = { foreground = "#F38BA8"; };
        user_other = { foreground = "#CBA6F7"; };
        group_yours = { foreground = "#BAC2DE"; };
        group_other = { foreground = "#7F849C"; };
        group_root = { foreground = "#F38BA8"; };
      };

      links = {
        normal = { foreground = "#89DCEB"; };
        multi_link_file = { foreground = "#74C7EC"; };
      };

      git = {
        new = { foreground = "#A6E3A1"; };
        modified = { foreground = "#F9E2AF"; };
        deleted = { foreground = "#F38BA8"; };
        renamed = { foreground = "#94E2D5"; };
        typechange = { foreground = "#F5C2E7"; };
        ignored = { foreground = "#7F849C"; };
        conflicted = { foreground = "#EBA0AC"; };
      };

      git_repo = {
        branch_main = { foreground = "#CDD6F4"; };
        branch_other = { foreground = "#CBA6F7"; };
        git_clean = { foreground = "#A6E3A1"; };
        git_dirty = { foreground = "#F38BA8"; };
      };

      security_context = {
        colon = { foreground = "#7F849C"; };
        user = { foreground = "#BAC2DE"; };
        role = { foreground = "#CBA6F7"; };
        typ = { foreground = "#585B70"; };
        range = { foreground = "#CBA6F7"; };
      };

      file_type = {
        image = { foreground = "#F9E2AF"; };
        video = { foreground = "#F38BA8"; };
        music = { foreground = "#A6E3A1"; };
        lossless = { foreground = "#94E2D5"; };
        crypto = { foreground = "#585B70"; };
        document = { foreground = "#CDD6F4"; };
        compressed = { foreground = "#F5C2E7"; };
        temp = { foreground = "#EBA0AC"; };
        compiled = { foreground = "#74C7EC"; };
        build = { foreground = "#585B70"; };
        source = { foreground = "#89B4FA"; };
      };

      punctuation = { foreground = "#7F849C"; };
      date = { foreground = "#F9E2AF"; };
      inode = { foreground = "#A6ADC8"; };
      blocks = { foreground = "#9399B2"; };
      header = { foreground = "#CDD6F4"; };
      octal = { foreground = "#94E2D5"; };
      flags = { foreground = "#CBA6F7"; };

      symlink_path = { foreground = "#89DCEB"; };
      control_char = { foreground = "#74C7EC"; };
      broken_symlink = { foreground = "#F38BA8"; };
      broken_path_overlay = { foreground = "#585B70"; };
    };
  };
}

