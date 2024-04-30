require("modules.cube")

function love.load()
	obj = {
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
end

function love.draw()
	arr = {}
	for i=2, 20, 2
	do
		arr[i-1] = love.math.random() * 1000
		arr[i] = love.math.random() * 750
	end
	love.graphics.points(unpack(arr))

	love.graphics.circle('fill', obj.x, obj.y, obj.r)

	obj.vx, obj.vy = touch(obj, platform)
	obj.x = obj.vx + obj.x
	obj.y = obj.vy + obj.y
	

	love.graphics.polygon('fill', platform.pos_x, platform.pos_y, 
		platform.pos_x+platform.width, platform.pos_y, 
		platform.pos_x+platform.width, platform.pos_y+platform.height, 
		platform.pos_x, platform.pos_y+platform.height)
end


function touch(ball,platform)
	vx, vy = ball.vx, ball.vy
	
	if(ball.x >= love.graphics.getWidth()-ball.r or ball.x <= 0+ball.r) then 
		vx = -vx
	end
	if(ball.y >= love.graphics.getHeight()-ball.r or ball.y <= 0+ball.r) then 
		vy = -vy
	end

	if(ball.x >= platform.pos_x and ball.x <= platform.pos_x + platform.width) then
		if(ball.y+ball.r >= platform.pos_y and ball.y <= platform.pos_y+platform.height
			and ball.vy > 0) then
			vy = -vy
		elseif(ball.y >= platform.pos_y and ball.y - ball.r <= platform.pos_y+platform.height
			and ball.vy < 0) then
			vy = -vy
		end
	elseif(ball.y >= platform.pos_y and ball.y <= platform.pos_y + platform.height) then
		if(ball.x+ball.r >= platform.pos_x and 
			ball.x<= platform.pos_x + platform.width and
			ball.vx > 0) then
			vx = -vx
		elseif(ball.x >= platform.pos_x and 
			ball.x-ball.r <= platform.pos_x + platform.width and
			ball.vx < 0) then
			vx = -vx
		end
	end

	return vx, vy
end

function random_ball_speed(ball)
	vx = ball.vx + (love.math.random() * 10) % 10
	vy = ball.vy + (love.math.random() * 10) % 10
	return vx, vy
end