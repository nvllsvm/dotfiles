function fullscreens(c)
	awful.client.floating.toggle(c)
	if awful.client.floating.get(c) then
		local clientX = screen[1].workarea.x
		local clientY = screen[1].workarea.y
		local clientWidth = 0
		local clientHeight = 2147483640
		for s = 1, screen.count() do
			clientHeight = math.min(clientHeight, screen[s].workarea.height)
			clientWidth = clientWidth + screen[s].workarea.width
		end
		local t = c:geometry({x = clientX, y = clientY, width = clientWidth, height = clientHeight})
	else
		awful.rules.apply(c)
	end
	client.focus = c
end
