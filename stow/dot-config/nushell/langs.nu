#!/opt/homebrew/bin/nu

def java_versions_list [] {
    let java_root = ($env.LANGS_HOME | path join "java")

    ls $java_root | where type == "dir" | get name | path basename
}

def java_set_version [
    version: string@java_versions_list
] {
    let java_home_path = ($env.LANGS_HOME | path join "java" $version)
    let java_home_link = ($env.LANGS_HOME | path join "java" "current")

    ln -shF $java_home_path $java_home_link
}


def node_versions_list [] {
    let node_root = ($env.LANGS_HOME | path join "node")

    ls $node_root | where type == "dir" | get name | path basename
}

def node_set_version [
    version: string@node_versions_list
] {
    let node_home_path = ($env.LANGS_HOME | path join "node" $version)
    let node_home_link = ($env.LANGS_HOME | path join "node" "current")

    ln -shF $node_home_path $node_home_link
}

def python_versions_list [] {
    let python_root = ($env.LANGS_HOME | path join "python")

    ls $python_root | where type == "dir" | get name | path basename
}

def python_set_version [
    version: string@python_versions_list
] {
    let python_home_path = ($env.LANGS_HOME | path join "python" $version)
    let python_home_link = ($env.LANGS_HOME | path join "python" "current")

    ln -shF $python_home_path $python_home_link
}

def golang_versions_list [] {
    let golang_root = ($env.LANGS_HOME | path join "golang")

    ls $golang_root | where type == "dir" | get name | path basename
}

def golang_set_version [
    version: string@golang_versions_list
] {
    let golang_home_path = ($env.LANGS_HOME | path join "golang" $version)
    let golang_home_link = ($env.LANGS_HOME | path join "golang" "current")

    ln -shF $golang_home_path $golang_home_link
}

