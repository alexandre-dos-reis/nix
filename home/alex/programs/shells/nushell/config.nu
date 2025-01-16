let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans
  | from json
}

let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        kubens | kubectx | flux => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

mut current = (($env | default {} config).config | default {} completions)
$current.completions = ($current.completions | default {} external)
$current.completions.external = ($current.completions.external
| default true enable
| default $external_completer completer)

$env.config = $current


$env.PROMPT_INDICATOR_VI_NORMAL = "n "
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = "n "
$env.PROMPT_INDICATOR_VI_INSERT = "> "
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = "> "
$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "vi"
