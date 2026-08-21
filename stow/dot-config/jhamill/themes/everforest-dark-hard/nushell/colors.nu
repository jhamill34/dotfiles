
$env.FZF_DEFAULT_OPTS = ([
    "--color=bg+:#414B50,bg:#272E33,spinner:#D3C6AA,hl:#E67E80"
    "--color=fg:#D3C6AA,header:#E67E80,info:#E69875,pointer:#D3C6AA"
    "--color=marker:#E69875,fg+:#D3C6AA,prompt:#E69875,hl+:#E67E80"
    "--color=selected-bg:#414B50"
    "--color=border:#E69875,label:#D3C6AA"
    "--border=bold"
] | str join ' ')

$env.JQ_COLORS = "1;30:0;37:0;37:0;37:0;32:1;37:1;37:1;34"

$env.LS_COLORS = ([
    "di=01;38;2;127;187;179:ln=01;38;2;131;192;146:so=38;2;73;81;86"
    "pi=38;2;122;132;120:ex=01;38;2;167;192;128:bd=38;2;230;152;117"
    "cd=38;2;230;152;117:su=38;2;219;188;127:sg=38;2;219;188;127"
    "tw=38;2;131;192;146:ow=38;2;131;192;146:st=38;2;127;187;179"
    "or=38;2;230;126;128:mi=38;2;230;126;128"
    "*.tar=38;2;214;153;182:*.tgz=38;2;214;153;182:*.gz=38;2;214;153;182"
    "*.zip=38;2;214;153;182:*.7z=38;2;214;153;182:*.rar=38;2;214;153;182"
    "*.bz2=38;2;214;153;182:*.xz=38;2;214;153;182:*.zst=38;2;214;153;182"
    "*.jpg=38;2;219;188;127:*.jpeg=38;2;219;188;127:*.png=38;2;219;188;127"
    "*.gif=38;2;219;188;127:*.bmp=38;2;219;188;127:*.svg=38;2;219;188;127"
    "*.webp=38;2;219;188;127:*.ico=38;2;219;188;127"
    "*.mp4=38;2;230;126;128:*.mkv=38;2;230;126;128:*.mov=38;2;230;126;128"
    "*.avi=38;2;230;126;128:*.webm=38;2;230;126;128:*.flv=38;2;230;126;128"
    "*.mp3=38;2;167;192;128:*.flac=38;2;167;192;128:*.wav=38;2;167;192;128"
    "*.ogg=38;2;167;192;128:*.m4a=38;2;167;192;128"
    "*.pdf=38;2;211;198;170:*.md=38;2;211;198;170:*.txt=38;2;211;198;170"
    "*.doc=38;2;211;198;170:*.docx=38;2;211;198;170:*.rtf=38;2;211;198;170"
] | str join ':')

let theme = {
  fg: "#d3c6aa"
  red: "#e67e80"
  orange: "#e69875"
  yellow: "#dbbc7f"
  green: "#a7c080"
  aqua: "#83c092"
  blue: "#7fbbb3"
  purple: "#d699b6"
  grey0: "#7a8478"
  grey1: "#859289"
  grey2: "#9da9a0"
  bg5: "#4f5b58"
  bg4: "#495156"
  bg3: "#414b50"
  bg2: "#374145"
  bg1: "#2e383c"
  bg0: "#272e33"
  bg_dim: "#1e2326"
}

let scheme = {
  recognized_command: $theme.blue
  unrecognized_command: $theme.fg
  constant: $theme.orange
  punctuation: $theme.grey1
  operator: $theme.aqua
  string: $theme.green
  virtual_text: $theme.bg4
  variable: { fg: $theme.purple attr: i }
  filepath: $theme.yellow
}

$env.config.color_config = {
  separator: { fg: $theme.bg4 attr: b }
  leading_trailing_space_bg: { fg: $theme.purple attr: u }
  header: { fg: $theme.fg attr: b }
  row_index: $scheme.virtual_text
  record: $theme.fg
  list: $theme.fg
  hints: $scheme.virtual_text
  search_result: { fg: $theme.bg0 bg: $theme.yellow }
  shape_closure: $theme.aqua
  closure: $theme.aqua
  shape_flag: { fg: $theme.orange attr: i }
  shape_matching_brackets: { attr: u }
  shape_garbage: $theme.red
  shape_keyword: $theme.purple
  shape_match_pattern: $theme.green
  shape_signature: $theme.aqua
  shape_table: $scheme.punctuation
  cell-path: $scheme.punctuation
  shape_list: $scheme.punctuation
  shape_record: $scheme.punctuation
  shape_vardecl: $scheme.variable
  shape_variable: $scheme.variable
  empty: { attr: n }
  filesize: {||
    if $in < 1kb {
      $theme.aqua
    } else if $in < 10kb {
      $theme.green
    } else if $in < 100kb {
      $theme.yellow
    } else if $in < 10mb {
      $theme.orange
    } else if $in < 100mb {
      $theme.orange
    } else if $in < 1gb {
      $theme.red
    } else {
      $theme.purple
    }
  }
  duration: {||
    if $in < 1day {
      $theme.aqua
    } else if $in < 1wk {
      $theme.green
    } else if $in < 4wk {
      $theme.yellow
    } else if $in < 12wk {
      $theme.orange
    } else if $in < 24wk {
      $theme.orange
    } else if $in < 52wk {
      $theme.red
    } else {
      $theme.purple
    }
  }
  datetime: {|| (date now) - $in |
    if $in < 1day {
      $theme.aqua
    } else if $in < 1wk {
      $theme.green
    } else if $in < 4wk {
      $theme.yellow
    } else if $in < 12wk {
      $theme.orange
    } else if $in < 24wk {
      $theme.orange
    } else if $in < 52wk {
      $theme.red
    } else {
      $theme.purple
    }
  }
  shape_external: $scheme.unrecognized_command
  shape_internalcall: $scheme.recognized_command
  shape_external_resolved: $scheme.recognized_command
  shape_block: $scheme.recognized_command
  block: $scheme.recognized_command
  shape_custom: $theme.purple
  custom: $theme.purple
  background: $theme.bg0
  foreground: $theme.fg
  cursor: { bg: $theme.fg fg: $theme.bg0 }
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
  shape_string_interpolation: $theme.orange
  shape_raw_string: $scheme.string
  shape_externalarg: $scheme.string
}
$env.config.highlight_resolved_externals = true
$env.config.explore = {
    status_bar_background: { fg: $theme.fg, bg: $theme.bg_dim },
    command_bar_text: { fg: $theme.fg },
    highlight: { fg: $theme.bg0, bg: $theme.yellow },
    status: {
        error: $theme.red,
        warn: $theme.yellow,
        info: $theme.blue,
    },
    selected_cell: { bg: $theme.blue fg: $theme.bg0 },
}
