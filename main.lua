function love.load()
	ball = {
		vx = 15,
		vy = 8,
		x = 100,
		y = 100,
		r = 20
	}
	platform = {
		width = 120,
		height = 20,
		pos_x = 400,
		pos_y = 640
	}
	GAME_OVER = 0
end

function love.update()

	local vx = 20
	if(love.keyboard.isDown("left")) then
		platform.pos_x = platform.pos_x - vx
	elseif(love.keyboard.isDown("right")) then
		platform.pos_x = platform.pos_x + vx
	end
	
	if(platform.pos_x < 0) then
		platform.pos_x = 0
	elseif (platform.pos_x + platform.width > love.graphics.getWidth()) then
		platform.pos_x = love.graphics.getWidth() - platform.width
	end

	ball.vx, ball.vy = touch(ball, platform)
	ball.x = ball.vx + ball.x
	ball.y = ball.vy + ball.y

end

function love.draw()
	if(GAME_OVER == 1) then
		gameover_draw()
		return
	end

	arr = {}
	for i=2, 20, 2
	do
		arr[i-1] = love.math.random() * 1000
		arr[i] = love.math.random() * 750
	end
	love.graphics.points(unpack(arr))

	love.graphics.circle('fill', ball.x, ball.y, ball.r)
	love.graphics.polygon('fill', platform.pos_x, platform.pos_y, 
		platform.pos_x+platform.width, platform.pos_y, 
		platform.pos_x+platform.width, platform.pos_y+platform.height, 
		platform.pos_x, platform.pos_y+platform.height)
end


function touch(ball,platform)
	local vx, vy = ball.vx, ball.vy
	
	if(ball.x+vx > love.graphics.getWidth()-ball.r or ball.x+vx < 0+ball.r) then 
		vx = -vx
	end
	if(ball.y+vy > love.graphics.getHeight()-ball.r) then 
		gameover()
	elseif (ball.y+ball.vy < 0+ball.r) then
		vy = -vy
	end

	vx,vy = touch_platform(ball, platform, vx, vy);
	return vx,vy
end

function touch_platform(ball, platform, vx, vy)
	if(ball.y + ball.r >= platform.pos_y 
	and ball.y - ball.r <= platform.pos_y + platform.height) then
		if(vx > 0 
		and ball.x + ball.r <= platform.pos_x 
		and ball.x + ball.r + vx >= platform.pos_x) then
			vx = -vx
			ball.x = platform.pos_x - ball.r
		elseif(vx < 0 
		and ball.x - ball.r >= platform.pos_x + platform.width
		and ball.x - ball.r + vx <= platform.pos_x + platform.width)  then
			vx = - vx
			ball.x = platform.pos_x + platform.width + ball.r
		end
	end
	if(ball.x + ball.r >= platform.pos_x 
	and ball.x - ball.r <= platform.pos_x + platform.width) then
		if(vy > 0
		and ball.y + ball.r <= platform.pos_y	
		and ball.y + ball.r + vy >= platform.pos_y) then
			vy = -vy
			ball.y = platform.pos_y - ball.r
		elseif (vy < 0
		and ball.y - ball.r >= platform.pos_y + platform.height
		and ball.y - ball.r + vy <= platform.pos_y + platform.height) then
			vy = -vy
			ball.y = platform.pos_y + platform.height + ball.r
		end
	end
	return vx, vy
end

-- ------------------

function start_ui_draw()
	-- unfinshed
end

function gameover()
	GAME_OVER = 1
end

function gameover_draw()
	local font = love.graphics.newFont("test/ttf/Hack-Bold.ttf", 40)
	love.graphics.setFont(font)
	local text = "Game Over"
	love.graphics.print(
		text, 
		(love.graphics.getWidth()- font:getWidth(text))/2, 
		(love.graphics.getHeight()- font:getHeight())/2
	)

	local offsetY = 100
	local cubeHW = 40
	local cubeHH = 22

	love.graphics.polygon(
		'fill',
		love.graphics.getWidth()/2 - cubeHW,
		love.graphics.getHeight()/2 + offsetY - cubeHH,

		love.graphics.getWidth()/2 + cubeHW,
		love.graphics.getHeight()/2 + offsetY - cubeHH,

		love.graphics.getWidth()/2 + cubeHW,
		love.graphics.getHeight()/2 + offsetY + cubeHH,

		love.graphics.getWidth()/2 - cubeHW,
		love.graphics.getHeight()/2 + offsetY + cubeHH
	)

	local font2 = love.graphics.newFont("test/ttf/Hack-Bold.ttf", 16)
	love.graphics.setFont(font2)
	love.graphics.print({{0,0,0}, 'restart'}, 
		love.graphics.getWidth()/2 - font2:getWidth('restart')/2,
		love.graphics.getHeight()/2 + offsetY - font2:getHeight()/2
	)

	if(love.mouse.isDown(1)) then
		local x,y = love.mouse.getPosition()
		if(x >= love.graphics.getWidth()/2 - cubeHW 
		and x <= love.graphics.getWidth()/2 + cubeHW 
		and y >= love.graphics.getHeight()/2 + offsetY - cubeHH
		and y <= love.graphics.getHeight()/2 + offsetY + cubeHH) then
			restart()
		end
	end
end

function restart()
	platform.pos_x, platform.pos_y = 400, 600
	
	local x1 = love.math.random() * love.graphics.getWidth()

	if(x1 < ball.r) then x1 = ball.r end
	if(x1 > love.graphics.getWidth()-ball.r) then x1 = love.graphics.getWidth()-ball.r end

	ball.vx, ball.vy, ball.x, ball.y  = 15, 8, x1, 100
	GAME_OVER = 0
end

