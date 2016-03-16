awful = require("awful")
local wibox = require("wibox")
local variables = require("config/variables")
local tags = require("config/tags")
local wibox = require("config/wibox")
local signals = require("config/signals")

globalkeys = awful.util.table.join(
    awful.key({ variables.modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ variables.modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ variables.modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ variables.modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ variables.modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ variables.modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ variables.modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ variables.modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ variables.modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ variables.modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ variables.modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

	-- Hide wibox
	awful.key({ variables.modkey            }, "b",     function ()  top_wibox[mouse.screen].visible = not top_wibox[mouse.screen].visible end),
	awful.key({ variables.modkey            }, "v",     function ()  bottom_wibox[mouse.screen].visible = not bottom_wibox[mouse.screen].visible end),

    -- Standard program
    awful.key({ variables.modkey,           }, "Return", function () awful.util.spawn(variables.terminal) end),
    awful.key({ variables.modkey, "Control" }, "r", awesome.restart),
    awful.key({ variables.modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ variables.modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ variables.modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ variables.modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ variables.modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ variables.modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ variables.modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ variables.modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ variables.modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ variables.modkey, "Control" }, "n", awful.client.restore),

	-- Application Shortcuts
	awful.key({ variables.modkey, }, "g", function () awful.util.spawn("lock_screen") end),
	awful.key({ variables.modkey, }, "F1", function () awful.util.spawn("chromium --scroll-pixels=400 --audio-buffer-size=4096") end),
	awful.key({ variables.modkey, }, "F2", function () awful.util.spawn(variables.terminal .. " -e ranger /mnt/storage1") end),
	awful.key({ variables.modkey, }, "F3", function () awful.util.spawn(variables.terminal .. " -e tmux attach") end),
	awful.key({ variables.modkey, }, "F4", function () awful.util.spawn(variables.terminal .. " -e ncmpcpp") end),
	
	-- Application Shortcuts

    -- Prompt
    awful.key({ variables.modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ variables.modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ variables.modkey,           }, "b",      function () top_wibox[mouse.screen].visible = not top_wibox[mouse.screen].visble end),
    awful.key({ variables.modkey,           }, "v",      function () bottom_wibox[mouse.screen].visible = not bottom_wibox[mouse.screen].visble end),
    awful.key({ variables.modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ variables.modkey, "Shift"   }, "f",      function (c) awful.client.floating.toggle(c) c:geometry({x = -1, y = -1, height = 1200, width = 5760}) end),
    awful.key({ variables.modkey, "Shift"   }, "c",      function (c) c:kill() end),
    awful.key({ variables.modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ variables.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ variables.modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ variables.modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ variables.modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ variables.modkey,           }, "m",
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
        awful.key({ variables.modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ variables.modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ variables.modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ variables.modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ variables.modkey }, 1, awful.mouse.client.move),
    awful.button({ variables.modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

return clientkeys
