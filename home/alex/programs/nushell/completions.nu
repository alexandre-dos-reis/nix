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
    | get --optional 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        kubens | kubectx | flux | nix | nh | zig => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

mut current = (($env | default {} config).config | default {} completions)
$current.completions = ($current.completions | default {} external)
$current.completions.external = ($current.completions.external
| default true enable
| default { $external_completer } completer)

$env.config = $current
