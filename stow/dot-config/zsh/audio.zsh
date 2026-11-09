_audio_devices() { local -a d; d=("${(@f)$(SwitchAudioSource -a -t $1)}"); compadd -a d }

audio_switch() { SwitchAudioSource -s "$1" -t output }
audio_input_switch() { SwitchAudioSource -s "$1" -t input }
audio_current() {
    echo "output: $(SwitchAudioSource -c -t output)"
    echo "input:  $(SwitchAudioSource -c -t input)"
}
compdef '_audio_devices output' audio_switch
compdef '_audio_devices input' audio_input_switch
