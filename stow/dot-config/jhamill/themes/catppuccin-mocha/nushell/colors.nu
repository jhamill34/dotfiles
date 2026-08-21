
$env.FZF_DEFAULT_OPTS = ([
    "--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8"
    "--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC"
    "--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8"
    "--color=selected-bg:#45475A"
    "--color=border:#B4BEFE,label:#CDD6F4"
    "--border=bold"
] | str join ' ')

$env.JQ_COLORS = "1;30:0;37:0;37:0;37:0;32:1;37:1;37:1;34"

$env.LS_COLORS = ([
    "di=01;38;2;137;180;250:ln=01;38;2;137;220;235:so=38;2;88;91;112"
    "pi=38;2;127;132;156:ex=01;38;2;166;227;161:bd=38;2;235;160;172"
    "cd=38;2;235;160;172:su=38;2;249;226;175:sg=38;2;249;226;175"
    "tw=38;2;148;226;213:ow=38;2;148;226;213:st=38;2;116;199;236"
    "or=38;2;243;139;168:mi=38;2;243;139;168"
    "*.tar=38;2;203;166;247:*.tgz=38;2;203;166;247:*.gz=38;2;203;166;247"
    "*.zip=38;2;203;166;247:*.7z=38;2;203;166;247:*.rar=38;2;203;166;247"
    "*.bz2=38;2;203;166;247:*.xz=38;2;203;166;247:*.zst=38;2;203;166;247"
    "*.jpg=38;2;249;226;175:*.jpeg=38;2;249;226;175:*.png=38;2;249;226;175"
    "*.gif=38;2;249;226;175:*.bmp=38;2;249;226;175:*.svg=38;2;249;226;175"
    "*.webp=38;2;249;226;175:*.ico=38;2;249;226;175"
    "*.mp4=38;2;243;139;168:*.mkv=38;2;243;139;168:*.mov=38;2;243;139;168"
    "*.avi=38;2;243;139;168:*.webm=38;2;243;139;168:*.flv=38;2;243;139;168"
    "*.mp3=38;2;166;227;161:*.flac=38;2;166;227;161:*.wav=38;2;166;227;161"
    "*.ogg=38;2;166;227;161:*.m4a=38;2;166;227;161"
    "*.pdf=38;2;205;214;244:*.md=38;2;205;214;244:*.txt=38;2;205;214;244"
    "*.doc=38;2;205;214;244:*.docx=38;2;205;214;244:*.rtf=38;2;205;214;244"
] | str join ':')

let theme = {
  rosewater: "#f5e0dc"
  flamingo: "#f2cdcd"
  pink: "#f5c2e7"
  mauve: "#cba6f7"
  red: "#f38ba8"
  maroon: "#eba0ac"
  peach: "#fab387"
  yellow: "#f9e2af"
  green: "#a6e3a1"
  teal: "#94e2d5"
  sky: "#89dceb"
  sapphire: "#74c7ec"
  blue: "#89b4fa"
  lavender: "#b4befe"
  text: "#cdd6f4"
  subtext1: "#bac2de"
  subtext0: "#a6adc8"
  overlay2: "#9399b2"
  overlay1: "#7f849c"
  overlay0: "#6c7086"
  surface2: "#585b70"
  surface1: "#45475a"
  surface0: "#313244"
  base: "#1e1e2e"
  mantle: "#181825"
  crust: "#11111b"
}

let scheme = {
  recognized_command: $theme.blue
  unrecognized_command: $theme.text
  constant: $theme.peach
  punctuation: $theme.overlay2
  operator: $theme.sky
  string: $theme.green
  virtual_text: $theme.surface2
  variable: { fg: $theme.flamingo attr: i }
  filepath: $theme.yellow
}

$env.config.color_config = {
  separator: { fg: $theme.surface2 attr: b }
  leading_trailing_space_bg: { fg: $theme.lavender attr: u }
  header: { fg: $theme.text attr: b }
  row_index: $scheme.virtual_text
  record: $theme.text
  list: $theme.text
  hints: $scheme.virtual_text
  search_result: { fg: $theme.base bg: $theme.yellow }
  shape_closure: $theme.teal
  closure: $theme.teal
  shape_flag: { fg: $theme.maroon attr: i }
  shape_matching_brackets: { attr: u }
  shape_garbage: $theme.red
  shape_keyword: $theme.mauve
  shape_match_pattern: $theme.green
  shape_signature: $theme.teal
  shape_table: $scheme.punctuation
  cell-path: $scheme.punctuation
  shape_list: $scheme.punctuation
  shape_record: $scheme.punctuation
  shape_vardecl: $scheme.variable
  shape_variable: $scheme.variable
  empty: { attr: n }
  filesize: {||
    if $in < 1kb {
      $theme.teal
    } else if $in < 10kb {
      $theme.green
    } else if $in < 100kb {
      $theme.yellow
    } else if $in < 10mb {
      $theme.peach
    } else if $in < 100mb {
      $theme.maroon
    } else if $in < 1gb {
      $theme.red
    } else {
      $theme.mauve
    }
  }
  duration: {||
    if $in < 1day {
      $theme.teal
    } else if $in < 1wk {
      $theme.green
    } else if $in < 4wk {
      $theme.yellow
    } else if $in < 12wk {
      $theme.peach
    } else if $in < 24wk {
      $theme.maroon
    } else if $in < 52wk {
      $theme.red
    } else {
      $theme.mauve
    }
  }
  datetime: {|| (date now) - $in |
    if $in < 1day {
      $theme.teal
    } else if $in < 1wk {
      $theme.green
    } else if $in < 4wk {
      $theme.yellow
    } else if $in < 12wk {
      $theme.peach
    } else if $in < 24wk {
      $theme.maroon
    } else if $in < 52wk {
      $theme.red
    } else {
      $theme.mauve
    }
  }
  shape_external: $scheme.unrecognized_command
  shape_internalcall: $scheme.recognized_command
  shape_external_resolved: $scheme.recognized_command
  shape_block: $scheme.recognized_command
  block: $scheme.recognized_command
  shape_custom: $theme.pink
  custom: $theme.pink
  background: $theme.base
  foreground: $theme.text
  cursor: { bg: $theme.rosewater fg: $theme.base }
  shape_range: $scheme.operator
  range: $scheme.operator
  shape_pipe: $scheme.operator
  shape_operator: $scheme.operator
  shape_redirection: $scheme.operator
  glob: $scheme.filepath
  shape_directory: $scheme.filepath
  shape_filepath: $scheme.filepath
  shape_glob_interpolation: $scheme.filepath
  shape_globpattern: $scheme.filepath
  shape_int: $scheme.constant
  int: $scheme.constant
  bool: $scheme.constant
  float: $scheme.constant
  nothing: $scheme.constant
  binary: $scheme.constant
  shape_nothing: $scheme.constant
  shape_bool: $scheme.constant
  shape_float: $scheme.constant
  shape_binary: $scheme.constant
  shape_datetime: $scheme.constant
  shape_literal: $scheme.constant
  string: $scheme.string
  shape_string: $scheme.string
  shape_string_interpolation: $theme.flamingo
  shape_raw_string: $scheme.string
  shape_externalarg: $scheme.string
}
$env.config.highlight_resolved_externals = true
$env.config.explore = {
    status_bar_background: { fg: $theme.text, bg: $theme.mantle },
    command_bar_text: { fg: $theme.text },
    highlight: { fg: $theme.base, bg: $theme.yellow },
    status: {
        error: $theme.red,
        warn: $theme.yellow,
        info: $theme.blue,
    },
    selected_cell: { bg: $theme.blue fg: $theme.base },
}
