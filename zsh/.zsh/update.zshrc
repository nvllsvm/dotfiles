update_commands=()

full-update() {
	for command in "${update_commands[@]}"
	do
	  eval $command
	done
}
