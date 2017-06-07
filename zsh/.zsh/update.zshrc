update_commands=()

full-update() {
    for command in "${update_commands[@]}"
    do
      echo -e "\033[1;33mNow running $command \033[0m..."
      eval $command
    done
}
