dotfiles-update() {
    cd ~/Code/GitHub/nvllsvm/dotfiles
    git pull

    error_code=$?

    if [[ $error_code == 0 ]]; then
        git add -A
        git commit -m "dotfiles-update $(date +"%Y-%m-%d %H:%M:%S")"
        git push
        cd - > /dev/null
    else
        echo Unable to pull.
    fi
}
update_commands=("$update_commands[@]" dotfiles-update)
