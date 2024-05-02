Brick = {
	position = {x = 0, y = 0},
	width = 0,
	height = 0,
	color = {r = 0, g = 0, b = 0},
	visible = true
}

function Brick:draw(brick)
	if(brick.visible == false) then
		return
	end

	love.graphics.setColor(unpack(brick.color))
	love.graphics.polygon(
		'fill',
		brick.position.x,
		brick.position.y,
		brick.position.x+brick.width,
		brick.position.y,
		brick.position.x+brick.width,
		brick.position.y+brick.height,
		brick.position.x,
		brick.position.y+brick.height
	)
end

