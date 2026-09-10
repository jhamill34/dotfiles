#!/opt/homebrew/bin/nu

def quote-if-needed [value: string] {
    if ($value | str contains " ") { $"`($value)`" } else { $value }
}

def audio_list [] {
    SwitchAudioSource -a -t output | lines | each { |d| quote-if-needed $d }
}

def audio_input_list [] {
    SwitchAudioSource -a -t input | lines | each { |d| quote-if-needed $d }
}

def audio_switch [
    device: string@audio_list
] {
    SwitchAudioSource -s $device -t output
}

def audio_input_switch [
    device: string@audio_input_list
] {
    SwitchAudioSource -s $device -t input
}

def audio_current [] {
    {
        output: (SwitchAudioSource -c -t output),
        input: (SwitchAudioSource -c -t input),
    }
}
