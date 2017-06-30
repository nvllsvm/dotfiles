full-update() {
    if [[ $1 == "add" ]]; then
        if [ -z $2 ]; then
            echo ERROR: No command specified
        else
            update_commands=("$update_commands[@]" "$2")
        fi
    else
        for command in "${update_commands[@]}"
        do
          echo -e "\033[1;33mNow running $command \033[0m..."
          eval $command
        done
    fi
}
