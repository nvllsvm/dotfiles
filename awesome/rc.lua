local gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local string = { gsub = string.gsub, format = string.format }
local fullscreens = require("lua/fullscreens")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define
theme_path = awful.util.getdir("config") .. "/theme.lua"
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
--editor = "vim" 
--editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

blank_wallpaper = true

modkey = "Mod4"

hostname = io.popen("cat /etc/hostname"):read("*a"):gsub("^%s*(.-)%s*$", "%1")
battery = "BAT0"
wifi_interface = "wlp3s0"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Wallpaper

if blank_wallpaper == true then
	for s = 1, screen.count() do
		gears.wallpaper.set(beautiful.wallpaper_color)
	end
else
	os.execute("nitrogen --restore")
end

-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
local tags = {}
tags.setup = {
    { name = " c ",		layout = layouts[1]  },
    { name = " w ",		layout = layouts[1]  },
    { name = " d ",		layout = layouts[2]  },
    { name = " f ",		layout = layouts[3]  },
    { name = " v ",		layout = layouts[1]  },
    { name = " e ",		layout = layouts[1]  },
    { name = " g ",		layout = layouts[1]  },
    { name = " v ",		layout = layouts[1]  },
    { name = " m ",		layout = layouts[1]  }
}

local tags2 = {}
tags2.setup = {
    { name = "1",		layout = layouts[4]  },
    { name = "2",		layout = layouts[1]  },
    { name = "3",		layout = layouts[1]  },
    { name = "4",   	layout = layouts[5]  },
    { name = "5",   	layout = layouts[1]  },
    { name = "6",   	layout = layouts[1]  },
    { name = "7",   	layout = layouts[1]  },
    { name = "8",		layout = layouts[1]  },
    { name = "9",   	layout = layouts[1]  }
}
--for s = 1, screen.count() do
--	tags[s] = awful.tag({1,2,3,4,5,6,7,8,9,}, s, layouts[1]) 
--    tags[s] = awful.tag.new({"hi"}, s, layouts[1])
 --   tags[s] = awful.tag.new({"hey"}, s, layouts[1])
--end
tags[1] = {}
--for i, t in ipairs(tags.setup) do
	--tags[1] = awful.tag({"cli","web","dev","file","view","edit","game","vm","misc"}, 1, layouts[1]) 
	tags[1] = awful.tag({" c "," w "," d "," f "," v "," e "," m "," v "," u "}, 1, layouts[1]) 
	--tags[1] = awful.tag({"-","-","-","-","-","-","-","-","-"}, 1, layouts[1]) 
--end
tags[1][1].selected = true

for s = 2, screen.count() do
	tags[s] = awful.tag({1,2,3,4,5,6,7,8,9}, s, layouts[1]) 
	--for i, t in ipairs(tags.setup) do
   	--	tags[s] = awful.tag.new({t.name}, s, layouts[1])
	--end
    tags[s][1].selected = true
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
--myawesomemenu = {
--   { "manual", terminal .. " -e man awesome" },
--   { "edit config", editor_cmd .. " " .. awesome.conffile },
--   { "restart", awesome.restart },
--   { "quit", awesome.quit }
--}
--
--mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                    { "open terminal", terminal }
--                                  }
--                        })
--
--mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = mymainmenu })

-- Menubar configuration
--menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Widgets
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
	if fg_color == 0 then
		fg_color = beautiful.fg_normal
	end

	if bg_color == 0 then
		bg_color = beautiful.bg_normal
	end

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
	if fg_color == 0 then
		fg_color = beautiful.fg_normal
	end

	if bg_color == 0 then
		bg_color = beautiful.bg_normal
	end

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
mylayoutbox = {}
-- }}}
 
-- {{{ Taglist
mytaglist = wibox.widget.background() 
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
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
		awful.button({}, 1, function () awful.util.spawn(terminal .. " -e htop") end)
		))
	cpuwidget:set_widget(cpuwidget_textbox)
	cpuwidget:set_bg(beautiful.color_bg_cpu)
-- }}} 

-- {{{ Memory usage
memwidget = wibox.widget.background()
memwidget_textbox = wibox.widget.textbox()
memwidget_text = padding( set_color(beautiful.color_fg_mem, '$2MB') )
vicious.register(memwidget_textbox, vicious.widgets.mem, memwidget_text, 1)
	
	memwidget:buttons(awful.util.table.join(
		awful.button({}, 1, function () awful.util.spawn(terminal .. " -e htop") end)
		))
memwidget:set_widget(memwidget_textbox)
memwidget:set_bg(beautiful.color_bg_mem)
-- }}}

-- {{{ Microphone control
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
-- }}} 

-- {{{ Volume control
volwidget = wibox.widget.background()
volwidget_textbox = wibox.widget.textbox()
volwidget_text = padding( set_color(beautiful.color_fg_vol, string.format("%4s",'$1%') ) )
vicious.register(volwidget_textbox, vicious.widgets.volume, volwidget_text, 2, "Master")

vol_buttons_mars = {
					[1]="amixer -c 0 -q set 'Analog Output' Headphones"
				   ,[2]="amixer -c 0 -q set 'Analog Output' 'FP Headphones'"
				   ,[3]="amixer -c 0 -q set Master toggle"
				   ,[4]="amixer -c 0 -q set Master 2+ unmute"
				   ,[5]="amixer -c 0 -q set Master 2- unmute"}
				   
vol_buttons_phobos = {
					[1]="amixer -c 0 -q set Master toggle"
				   ,[2]="amixer -c 0 -q set Master toggle"
				   ,[3]="amixer -c 0 -q set Master toggle"
				   ,[4]="amixer -c 0 -q set Master 2+ unmute"
				   ,[5]="amixer -c 0 -q set Master 2- unmute"}


-- {{{ volwidget - mars
local function volwidget_mars ()
	volwidget:buttons(awful.util.table.join(
		awful.button({ }, 1, function () os.execute("amixer -c 0 -q set 'Analog Output' Headphones") end),
		awful.button({ }, 3, function () os.execute("amixer -c 0 -q set 'Analog Output' 'FP Headphones'") end),
		awful.button({ }, 2, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 4, function () os.execute("amixer -c 0 -q set Master 2+ unmute") end),
		awful.button({ }, 5, function () os.execute("amixer -c 0 -q set Master 2- unmute") end)
	))
end
-- }}} 
-- {{{ volwidget - phobos
local function volwidget_phobos ()
	volwidget:buttons(awful.util.table.join(
		awful.button({ }, 1, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 3, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 2, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 4, function () os.execute("amixer -c 0 -q set Master 2+ unmute") end),
		awful.button({ }, 5, function () os.execute("amixer -c 0 -q set Master 2- unmute") end)
	))
end
-- }}} 
-- {{{ volwidget - deimos
local function volwidget_phobos ()
	volwidget:buttons(awful.util.table.join(
		awful.button({ }, 1, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 3, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 2, function () os.execute("amixer -c 0 -q set Master toggle") end),
		awful.button({ }, 4, function () os.execute("amixer -c 0 -q set Master 2+ unmute") end),
		awful.button({ }, 5, function () os.execute("amixer -c 0 -q set Master 2- unmute") end)
	))
end
-- }}} 

if hostname == "mars" then 
	volwidget_mars()
elseif hostname == "phobos" then 
	volwidget_phobos()
else
	volwidget_default()
end

volwidget:set_widget(volwidget_textbox)
volwidget:set_bg(beautiful.color_bg_vol)

-- }}} 

-- {{{ Battery
	baticon = wibox.widget.imagebox(beautiful.widget_bat)

	batwidget = wibox.widget.textbox()
	vicious.register(batwidget, vicious.widgets.bat, " $2$1", 5, battery)
-- }}}

-- {{{ Wifi
	wifiicon = wibox.widget.imagebox(beautiful.widget_wifi)

	wifiwidget = wibox.widget.textbox()
	vicious.register(wifiwidget, vicious.widgets.wifi, " ${ssid} - ${linp}", 5, wifi_interface)

	wifiwidget:buttons(awful.util.table.join(
		awful.button({ }, 1, function () awful.util.spawn("cmst") end),
		awful.button({ }, 2, function () awful.util.spawn("cmst") end)
		))
-- }}}

-- }}}

-- {{{ Wibox
-- Create a wibox for each screen and add it
top_wibox = {}
bottom_wibox = {}

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
						   --
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	local ohmy = wibox.widget.background()
	ohmy:set_widget(mytaglist[s])
	ohmy:set_bg(beautiful.color_bg_tag)

    -- Create the wibox
    top_wibox[s] = awful.wibox({ position = "top", height = beautiful.wibox_height, screen = s })

    local left_layout = wibox.layout.fixed.horizontal()
    local right_layout = wibox.layout.fixed.horizontal()

-- {{{ wibox - mars
	local function wibox_mars()
   		 		if s == 1 then	 
					right_layout:add(wibox.widget.systray()) 
				end
			
--			    left_layout:add(mytaglist[s])
			    left_layout:add(ohmy)
			    left_layout:add(mypromptbox[s])
			
			    right_layout:add(cpuwidget)
			    right_layout:add(memwidget)
			    right_layout:add(micwidget)
			    right_layout:add(volwidget)
			    right_layout:add(widget_date(0,0))
			    right_layout:add(widget_time(0,0))
			    right_layout:add(mylayoutbox[s]) 
		end
-- }}}
-- {{{ wibox - phobos
	local function wibox_phobos()
   		 		if s == 1 then	 
					right_layout:add(wibox.widget.systray()) 
				end
			
			    left_layout:add(ohmy)
			    left_layout:add(mypromptbox[s])
			
			    right_layout:add(wifiwidget)
			    right_layout:add(batwidget)
			    right_layout:add(cpuwidget)
			    right_layout:add(memwidget)
			    right_layout:add(micwidget)
			    right_layout:add(volwidget)
			    right_layout:add(widget_date(0,0))
				right_layout:add(widget_time(0,0))
			    right_layout:add(mylayoutbox[s]) 
		end
-- }}}
-- {{{ wibox - default
	local function wibox_default()
   		 		if s == 1 then	 
					right_layout:add(wibox.widget.systray()) 
				end
			
			    left_layout:add(mytaglist[s])
			    left_layout:add(mypromptbox[s])
			
		    	right_layout:add(cpuicon)
			    right_layout:add(cpuwidget)
			    right_layout:add(memicon)
			    right_layout:add(memwidget)
			    right_layout:add(micicon)
			    right_layout:add(micwidget)
			    right_layout:add(volicon)
			    right_layout:add(volwidget)
			    right_layout:add(fucky)
			    right_layout:add(mylayoutbox[s]) 
	end
-- }}}

	if hostname == "mars" then 
		wibox_mars()
	elseif hostname == "phobos" then 
		wibox_phobos()
	else
		wibox_default()
	end
			
	-- top wibox
    local top_layout = wibox.layout.align.horizontal()
    top_layout:set_left(left_layout)
    top_layout:set_right(right_layout)

    top_wibox[s]:set_widget(top_layout)

	if s ~= 1 then
		top_wibox[s].visible = false
	end

	-- bottom wibox 
    bottom_wibox[s] = awful.wibox({ position = "bottom", height = "12", screen = s })

    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    local bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_middle(mytasklist[s])

	bottom_wibox[s].visible = false 
    bottom_wibox[s]:set_widget(bottom_layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
--    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

	-- Hide wibox
	awful.key({ modkey            }, "b",     function ()  top_wibox[mouse.screen].visible = not top_wibox[mouse.screen].visible end),
	awful.key({ modkey            }, "v",     function ()  bottom_wibox[mouse.screen].visible = not bottom_wibox[mouse.screen].visible end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- Application Shortcuts
	awful.key({ modkey, }, "g", function () awful.util.spawn("lock_screen") end),
--  awful.key({ modkey, }, "F1", function () awful.util.spawn("chromium --scroll-pixels=400 --audio-buffer-size=4096 --disable-gpu") end),
	awful.key({ modkey, }, "F1", function () awful.util.spawn("chromium --scroll-pixels=400 --audio-buffer-size=4096") end),
	awful.key({ modkey, }, "F2", function () awful.util.spawn(terminal .. " -e ranger /mnt/storage1") end),
	awful.key({ modkey, }, "F3", function () awful.util.spawn(terminal .. " -e tmux attach") end),
	awful.key({ modkey, }, "F4", function () awful.util.spawn(terminal .. " -e ncmpcpp") end),
	
	-- Application Shortcuts

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
    -- Menubar
    --awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "b",      function () top_wibox[mouse.screen].visible = not top_wibox[mouse.screen].visble end),
    awful.key({ modkey,           }, "v",      function () bottom_wibox[mouse.screen].visible = not bottom_wibox[mouse.screen].visble end),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "f",      function (c) awful.client.floating.toggle(c) c:geometry({x = -1, y = -1, height = 1200, width = 5760}) end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
					 buttons = clientbuttons } },

	{ rule = { class = "Firefox" },
		properties = { tag = tags[1][2] } },
	{ rule = { class = "luakit" },
		properties = { tag = tags[1][2] } },
	{ rule = { class = "Chromium" },
		properties = { tag = tags[1][2] } },
	{ rule = { class = "Chromium", role = "browser" },
		properties = { tag = tags[1][2] } },
	{ rule = { class = "chromium-dev" },
		properties = { tag = tags[1][2] } },
	{ rule = { class = "Google-chrome" },
		properties = { tag = tags[1][2] } },
	-- Fullscreen flash
	{ rule = { class = "Exe" },
		properties = { tag = tags[1][2], floating = true } },

    { rule = { class = "Gwenview" },
		properties = { tag = tags[1][5] } },
    { rule = { class = "Calibre-ebook-viewer" },
		properties = { tag = tags[1][5] } },
    { rule = { class = "Calibre-gui" },
		properties = { tag = tags[1][5] } },
    { rule = { class = "Okular" },
		properties = { tag = tags[1][5] } },
    { rule = { class = "qpdfview" },
		properties = { tag = tags[1][5] } },
    { rule = { class = "Zathura" },
		properties = { tag = tags[1][5] } },
    { rule = { class = "Mirage" },
		properties = { tag = tags[1][5] } },
    { rule = { class = "Digikam" },
		properties = { tag = tags[1][5] } },
    { rule = { class = "XMathematica" },
		properties = { tag = tags[1][5], floating = false } },
 
    { rule = { class = "Gimp" },
		properties = { tag = tags[1][6] } },
    { rule = { class = "libreoffice-writer" },
		properties = { tag = tags[1][6] } },
    { rule = { name = "LibreOffice" },
		properties = { tag = tags[1][6] } },

	{ rule = { name="Steam" },
		properties = { tag = tags[1][7], floating = true },
		callback = awful.placement.centered },
	{ rule = { class="Steam" },
		properties = { tag = tags[1][7], floating = true },
		callback = awful.placement.centered },
	{ rule = { class="uoc" },
		properties = { tag = tags[1][7], floating = false },
		callback = awful.placement.centered },
    { rule = { class = "steelstorm64" },
		properties = { tag = tags[1][7], },
		callback = awful.placement.centered },
    { rule = { class = "net-minecraft-LauncherFrame" },
		properties = { tag = tags[1][7] } },
	{ rule = { class="Dredmor-amd64" },
		properties = { tag = tags[1][7], },
		callback = awful.placement.centered },
	{ rule = { class="SuperMeatBoy-amd64" },
		properties = { tag = tags[1][7], },
		callback = awful.placement.centered },
	{ rule = { class="Torchlight.bin.x86_64" },
		properties = { tag = tags[1][7], },
		callback = awful.placement.centered },
	{ rule = { class="Hedgewars" },
		properties = { tag = tags[1][7], },
		callback = awful.placement.centered },
	{ rule = { class="FTL" },
		properties = { tag = tags[1][7], },
		callback = awful.placement.centered },

	{ rule = { class="Wine" },
		properties = { tag = tags[1][7], floating = true, },
		callback = awful.placement.centered },
	{ rule = { class="Closure.bin.x86" },
		properties = { tag = tags[1][7], floating = true, },
		callback = awful.placement.centered },
	{ rule = { class="eduke32" },
		properties = { tag = tags[1][7], floating = true, },
		callback = awful.placement.centered },
	{ rule = { class="zdoom" },
		properties = { tag = tags[1][7], floating = true, },
		callback = awful.placement.centered },
	{ rule = { class="chocolate-doom" },
		properties = { tag = tags[1][7], floating = true, },
		callback = awful.placement.centered },
	{ rule = { class="chocolate-heretic" },
		properties = { tag = tags[1][7], floating = true, },
		callback = awful.placement.centered },
	{ rule = { name="Neverwinter Nights Client" },
		properties = { tag = tags[1][7], floating = false, },
		callback = awful.placement.centered },
	{ rule = { class="binkplayer" },
		properties = { tag = tags[1][7], floating = true, },
		callback = awful.placement.centered },
	{ rule = { class="dosbox" },
		properties = { tag = tags[1][7], floating = true, },
		callback = awful.placement.centered },

    { rule = { class = "VirtualBox" },
		properties = { tag = tags[1][8] } },
    { rule = { class = "Vncviewer" },
		properties = { tag = tags[1][8] } },
    { rule = { class = "Wfica" },
		properties = { tag = tags[1][8] } },

	{ rule = { class = "Pidgin" },
		properties = { tag = tags[1][9], } },
    { rule = { class = "Transmission" },
		properties = { tag = tags[1][9] } },

	{ rule = { class="CMST - Connman System Tray" },
		properties = { floating = false, } },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

	-- Ignore size hints
	c.size_hints_honor = false

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- vim: set filetype=lua fdm=marker tabstop=4 shiftwidth=4:
