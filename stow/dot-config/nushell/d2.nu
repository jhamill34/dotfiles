#!/opt/homebrew/bin/nu

def d2_list [] {
    glob **/*.d2
}

def d2_dev [
    diagram: string@d2_list
] {
    let name = ($diagram | path parse)
    let output_file = mktemp -t $"($name | get stem).XXXX" --suffix $".($name | get extension)"

    d2 $diagram $output_file -w 
}

def d2_gen [
    diagram: string@d2_list
] {
    let diagram_parts = $diagram | path parse

    let output_dir = pwd | path join "gen" ($diagram_parts | get parent | path relative-to (pwd))
    mkdir $output_dir

    let output_file = $output_dir | path join $"($diagram_parts | get stem).png"

    d2 $diagram - | rsvg-convert -o $output_file -
}
