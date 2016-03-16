local wibox = require("wibox")
local beautiful = require("beautiful")
local variables = require("config/variables")
local widgets = require("config/widgets")

beautiful.init(variables.theme_path)

top_wibox = {}
bottom_wibox = {}

for s = 1, screen.count() do
    top_wibox[s] = awful.wibox({ position = "top", height = beautiful.wibox_height, screen = s })

    mypromptbox[s] = widget_promptbox()

    local left_layout = wibox.layout.fixed.horizontal()
    local right_layout = wibox.layout.fixed.horizontal()

    if s == 1 then	 
        right_layout:add(wibox.widget.systray()) 
    end

    left_layout:add(widget_taglist(s))
    left_layout:add(mypromptbox[s])

    right_layout:add(widget_cpu())
    right_layout:add(widget_memory())
    --right_layout:add(widget_microphone())
    --right_layout:add(widget_volume())
    right_layout:add(widget_date(beautiful.fg_normal, beautiful.bg_normal))
    right_layout:add(widget_time(beautiful.fg_normal, beautiful.bg_normal))
    right_layout:add(widget_layoutbox(s)) 
			
    local top_layout = wibox.layout.align.horizontal()
    top_layout:set_left(left_layout)
    top_layout:set_right(right_layout)

    top_wibox[s]:set_widget(top_layout)

	if s ~= 1 then
		top_wibox[s].visible = false
	end

    bottom_wibox[s] = awful.wibox({ position = "bottom", height = "12", screen = s })

    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    local bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_middle(mytasklist[s])

	bottom_wibox[s].visible = false 
    bottom_wibox[s]:set_widget(bottom_layout)
end
