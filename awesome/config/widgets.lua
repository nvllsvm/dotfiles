local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")
local variables = require("config/variables")

beautiful.init(variables.theme_path)

function set_color (color, text)
	return '<span color="' .. color .. '">' .. text .. '</span>'
end


function font_bold (text)
	return '<b>' .. text .. '</b>'
end


function padding (text)
	padding_text = '  '
	return padding_text .. text .. padding_text
end


-- {{{  Time
function widget_time (fg_color, bg_color)
	background = wibox.widget.background()
	textbox = wibox.widget.textbox()

	text = padding( set_color( fg_color, font_bold( '%R:%S' )))

	vicious.register(textbox, vicious.widgets.date, text, 1)

	background:buttons(awful.util.table.join(
		awful.button({ }, 1, function () naughty.notify({ text = io.popen("cal -3"):read("*a"), screen = mouse.screen, timeout = 5 }) end),
		awful.button({ }, 3, function () naughty.notify({ text = io.popen("cal -y"):read("*a"), screen = mouse.screen, timeout = 5 }) end)
		))

	calendar_tooltip = awful.tooltip({ objects = {textbox}, timeout = 240, timer_function = function() return io.popen("cal"):read("*a") end, })
		
	background:set_widget(textbox)
	background:set_bg(bg_color)

	return background
end
-- }}}

-- {{{ Date
function widget_date (fg_color, bg_color)
	background = wibox.widget.background()
	datewidget_textbox = wibox.widget.textbox()

	datewidget_text = padding( set_color(fg_color, '%Y-%m-%d') )

	vicious.register(datewidget_textbox, vicious.widgets.date, datewidget_text, 1)

	background:buttons(awful.util.table.join(
		awful.button({ }, 1, function () naughty.notify({ text = io.popen("cal -3"):read("*a"), screen = mouse.screen, timeout = 5 }) end),
		awful.button({ }, 3, function () naughty.notify({ text = io.popen("cal -y"):read("*a"), screen = mouse.screen, timeout = 5 }) end)
		))

	calendar_tooltip = awful.tooltip({ objects = {datewidget_textbox}, timeout = 240, timer_function = function() return io.popen("cal"):read("*a") end, })
		
	background:set_widget(datewidget_textbox)
	background:set_bg(bg_color)

	return background 
end
-- }}}

-- {{{ Prompt Box
mypromptbox = {}
-- }}}

-- {{{ Layout Box
-- }}}
 
-- {{{ Taglist
function widget_taglist (screen_num)
    mytaglist = wibox.widget.background() 
    mytaglist.buttons = awful.util.table.join(
                        awful.button({ }, 1, awful.tag.viewonly),
                        awful.button({ variables.modkey }, 1, awful.client.movetotag),
                        awful.button({ }, 3, awful.tag.viewtoggle),
                        awful.button({ variables.modkey }, 3, awful.client.toggletag),
                        awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                        awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                        )
    t = awful.widget.taglist(screen_num, awful.widget.taglist.filter.all, mytaglist.buttons)
	mytaglist:set_widget(mytaglist[screen_num])
	mytaglist:set_bg(beautiful.color_bg_tag)
    return t
end
-- }}}

-- {{{ Tasklist 
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))
-- }}}

-- {{{ CPU usage
function widget_cpu ()
    cpuwidget = wibox.widget.background()
    cpuwidget_textbox = wibox.widget.textbox()

    local num_cores = io.popen(awful.util.getdir("config") .. "/scripts/cores.sh"):read("*a") 
    local cpu_usage = "" 

    for c = 1,num_cores do
        current_core = string.format("%4s","$" .. c .. "%")
        cpu_usage = cpu_usage .. current_core
    end
    cpuwidget_text = padding( set_color(beautiful.color_fg_cpu, cpu_usage) )

    vicious.register(cpuwidget_textbox, vicious.widgets.cpu, cpuwidget_text)

    cpuwidget:buttons(awful.util.table.join(
        awful.button({}, 1, function () awful.util.spawn(variables.terminal .. " -e htop") end)
        ))
    cpuwidget:set_widget(cpuwidget_textbox)
    cpuwidget:set_bg(beautiful.color_bg_cpu)
    return cpuwidget
end
-- }}} 

-- {{{ Memory usage
function widget_memory ()
    memwidget = wibox.widget.background()
    memwidget_textbox = wibox.widget.textbox()
    memwidget_text = padding( set_color(beautiful.color_fg_mem, '$2MB') )
    vicious.register(memwidget_textbox, vicious.widgets.mem, memwidget_text, 1)
        
        memwidget:buttons(awful.util.table.join(
            awful.button({}, 1, function () awful.util.spawn(variables.terminal .. " -e htop") end)
            ))
    memwidget:set_widget(memwidget_textbox)
    memwidget:set_bg(beautiful.color_bg_mem)
    return memwidget
end
-- }}}

-- {{{ Microphone control
function widget_microphone ()
    micwidget = wibox.widget.background()
    micwidget_textbox = wibox.widget.textbox()
    micwidget_text = padding( set_color(beautiful.color_fg_mic, string.format("%4s",'$1%')) )
    vicious.register(micwidget_textbox, vicious.widgets.volume, micwidget_text, 2, "Mic")

    micwidget:buttons(awful.util.table.join(
        awful.button({ }, 1, function () os.execute("amixer -c 0 -q set 'Mic' nocap && amixer -c 0 -q set 'Mic' 0") end),
        awful.button({ }, 3, function () os.execute("amixer -c 0 -q set 'Mic' cap && amixer -c 0 -q set 'Mic' 100") end),
        awful.button({ }, 4, function () os.execute("amixer -c 0 -q set 'Mic' 2+") end),
        awful.button({ }, 5, function () os.execute("amixer -c 0 -q set 'Mic' 2-") end)
    ))

    micwidget:set_widget(micwidget_textbox)
    micwidget:set_bg(beautiful.color_bg_mic)
    return micwidget
end
-- }}} 

-- {{{ Volume control
function widget_volume ()
    volwidget = wibox.widget.background()
    volwidget_textbox = wibox.widget.textbox()
    volwidget_text = padding( set_color(beautiful.color_fg_vol, string.format("%4s",'$1%') ) )
    vicious.register(volwidget_textbox, vicious.widgets.volume, volwidget_text, 2, "Master")
	volwidget:buttons(awful.util.table.join(
		awful.button({ }, 1, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 3, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 2, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 4, function () os.execute("amixer -c 0 -q set Master 2+ unmute") end),
		awful.button({ }, 5, function () os.execute("amixer -c 0 -q set Master 2- unmute") end)
	))
    volwidget:set_widget(volwidget_textbox)
    volwidget:set_bg(beautiful.color_bg_vol)
    return volwidget
end
-- }}} 

-- {{{ Battery
function battery ()
	baticon = wibox.widget.imagebox(beautiful.widget_bat)

	batwidget = wibox.widget.textbox()
	vicious.register(batwidget, vicious.widgets.bat, " $2$1", 5, variables.battery)
end
-- }}}

-- {{{ Wifi
function wifi ()
	wifiicon = wibox.widget.imagebox(beautiful.widget_wifi)

	wifiwidget = wibox.widget.textbox()
	vicious.register(wifiwidget, vicious.widgets.wifi, " ${ssid} - ${linp}", 5, variables.wifi_interface)

	wifiwidget:buttons(awful.util.table.join(
		awful.button({ }, 1, function () awful.util.spawn("cmst") end),
		awful.button({ }, 2, function () awful.util.spawn("cmst") end)
		))
end
-- }}}

-- {{{ layoutbox
function widget_layoutbox (screen_num)
    lb = awful.widget.layoutbox(screen_num)
    lb:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    return lb
end
-- }}}

mypromptbox = {}
function widget_promptbox ()
    return awful.widget.prompt()
end
