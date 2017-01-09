alias nvim-update="nvim -c 'PlugUpgrade | PlugUpdate | PlugClean | silent UpdateRemotePlugins' -c 'qa'"
update_commands=("$update_commands[@]" nvim-update)
