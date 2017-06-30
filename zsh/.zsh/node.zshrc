path=("~/.node_modules/bin"  "$path[@]")

fn npm-update () {
    for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f4)
    do
        npm -g install "$package"
    done
}
full-update add npm-update
