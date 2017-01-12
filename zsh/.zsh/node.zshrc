path=("~/.node_modules/bin"  "$path[@]")

fn npm-update () {
    for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f4)
    do
        npm -g install "$package"
    done
}
update_commands=("$update_commands[@]" npm-update)
