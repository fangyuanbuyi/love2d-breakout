TextButton = {
	position = {x = 0, y = 0},
	text = "",
}


function TextButton:draw(self, event)
	-- set font
	local font2 = love.graphics.newFont(hack_font_ttf_path, 24)
	love.graphics.setFont(font2)

	local w = font2:getWidth(self.text)
	local h = font2:getHeight()
	local padding = 4
	local padding2 = 12
	
	love.graphics.setColor(0.6,0.6,0.6)
	love.graphics.rectangle('fill', self.position.x-(w+padding2)/2, 
		self.position.y-(h+padding2)/2, w+padding2, h+padding2)

	love.graphics.setColor(1,1,1)
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
			love.graphics.setColor(0.6,0.6,0.6)
			love.graphics.polygon(
				'fill',
				unpack(points)
			)
			event()
		end
	end

end

