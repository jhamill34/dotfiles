# java_set_version / node_set_version / python_set_version / golang_set_version <version>
for lang in java node python golang; do
    eval "${lang}_set_version() { ln -shF \"\$LANGS_HOME/$lang/\$1\" \"\$LANGS_HOME/$lang/current\" }"
    compdef "_files -W $LANGS_HOME/$lang -/" ${lang}_set_version
done
unset lang
