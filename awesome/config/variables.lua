local variables = {}

variables.theme_path = awful.util.getdir("config") .. "/config/theme.lua"

variables.terminal = "urxvt"
variables.modkey = "Mod4"

variables.hostname = io.popen("cat /etc/hostname"):read("*a"):gsub("^%s*(.-)%s*$", "%1")

variables.battery = "BAT0"
variables.wifi_interface = "wlp3s0"

return variables
