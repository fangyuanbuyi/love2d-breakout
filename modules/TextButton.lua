TextButton = {
	position = {x = 0, y = 0},
	text = "",
}


function TextButton:draw(self, event)
	local font2 = love.graphics.newFont(hack_font_ttf_path, 16)
	local w = font2:getWidth(self.text)
	local h = font2:getHeight()
	local padding = 4

	love.graphics.setFont(font2)

	local points = {
		self.position.x - (w+padding)/2, 
		self.position.y - (h+padding)/2,
		self.position.x + (w+padding)/2, 
		self.position.y - (h+padding)/2,
		self.position.x + (w+padding)/2, 
		self.position.y + (h+padding)/2,
		self.position.x - (w+padding)/2, 
		self.position.y + (h+padding)/2
	}
	love.graphics.polygon(
		'fill',
		unpack(points)
	)
	love.graphics.print({{0.5,0.5,0.5}, self.text}, 
		self.position.x - w/2,
		self.position.y - h/2
	)
	if(love.mouse.isDown(1)) then
		local x,y = love.mouse.getPosition()
		if(x >= points[1]
		and x <= points[3]
		and y >= points[2]
		and y <= points[6]) then
			event()
		end
	end

end

