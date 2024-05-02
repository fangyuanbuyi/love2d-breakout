require('modules.TextButton')
require('modules.Brick')
require('modules.StartUI')
require('test')


hack_font_ttf_path = "font/hack/Hack-Bold.ttf"

function init()
	platform.position.x, platform.position.y = 400, 600
	
	local x1 = love.graphics.getWidth()/2

	if(x1 < ball.r) then x1 = ball.r end
	if(x1 > love.graphics.getWidth()-ball.r) then x1 = love.graphics.getWidth()-ball.r end

	platform.width, platform.height, platform.position.x, 
		platform.position.y = 80, 20, 0, 600   
	ball.vx, ball.vy, ball.x, ball.y, ball.r  = 0, 0, x1, platform.position.y, 20
	platform.position.x = x1 - platform.width/2
	ball.y = ball.y - ball.r

	GAME_OVER = 0
	GAME_WIN = 0
	BALL_SEND = 0

	for i in ipairs(bricks) do
		bricks[i].visible = true
	end
end

function love.load()
	ball = {
		vx = 0,
		vy = 0,
		x = 0,
		y = 0,
		r = 0
	}
	platform = {
		width = 0,
		height = 0,
		position = {x = 0, y = 0}
	}
	bricks = {}
	bricks_init()
	START_UI_DISPLAY = 1
	init()
end

function get_input()
	-- base change velocity
	local vx = 20

	local px = platform.position.x
	-- normal input
	if(love.keyboard.isDown("left")) then
		platform.position.x = platform.position.x - vx
	elseif(love.keyboard.isDown("right")) then
		platform.position.x = platform.position.x + vx
	end

	if(love.keyboard.isDown('up') and BALL_SEND == 0) then
		ball.vx,ball.vy = 15, -8
		BALL_SEND = 1
	end

	-- test input 
	-- when game is finished, it will be hidden
	-- test_input(platform, ball)
	
	-- if input will make platform beyond the edge
	-- then adjust its position
	if(platform.position.x < 0) then
		platform.position.x = 0
	elseif (platform.position.x + platform.width > love.graphics.getWidth()) then
		platform.position.x = love.graphics.getWidth() - platform.width
	end

	if(not(px == platform.position.x) and BALL_SEND == 0) then
		ball.x = platform.position.x +  platform.width/2
	end
	
end

function love.update()
	-- if game is end, do not update
	if(GAME_OVER == 1 or GAME_WIN == 1) then
		return
	end
-- input
	get_input()
-- ball touch and change its position
	ball.vx, ball.vy = touch(ball, platform, bricks)
	ball.x = ball.vx + ball.x
	ball.y = ball.vy + ball.y
-- if there is no brick visible, set GAME_WIN = 1 
	GAME_WIN = 1
	for i in pairs(bricks) do
		if(bricks[i].visible == true) then
			GAME_WIN = 0
		end
	end

end

function love.draw()
	if(START_UI_DISPLAY == 1) then
		start_ui_draw()
		return 
	end
	if(GAME_OVER == 1) then
		gameover_draw()
		return 
	end
	if(GAME_WIN == 1) then
		gamewin_draw()
	return 
	end

	arr = {}
	for i=2, 20, 2
	do
		arr[i-1] = love.math.random() * 1000
		arr[i] = love.math.random() * 750
	end
	love.graphics.points(unpack(arr))

	bricks_draw()

	love.graphics.setColor(1,1,1)
	love.graphics.circle('fill', ball.x, ball.y, ball.r)
	love.graphics.polygon('fill', platform.position.x, platform.position.y, 
		platform.position.x+platform.width, platform.position.y, 
		platform.position.x+platform.width, platform.position.y+platform.height, 
		platform.position.x, platform.position.y+platform.height)
end


function touch(ball, platform, bricks)
	local vx, vy = ball.vx, ball.vy

	-- touch wall and change ball velocity
	-- if touch bottom, then gameover
	if(ball.x+vx > love.graphics.getWidth()-ball.r) then 
		vx = -vx
		ball.x = love.graphics.getWidth()-ball.r
	elseif( ball.x+vx < 0+ball.r) then
		vx = -vx
		ball.x = 0+ball.r
	end
	if(ball.y+vy > love.graphics.getHeight()-ball.r) then 
		gameover()
	elseif (ball.y+vy < 0+ball.r) then
		vy = -vy
		ball.y = 0+ball.r
	end

	vx,vy = touch_platform(ball, platform, vx, vy);
	vx,vy = touch_bricks(ball, bricks, vx, vy);
	return vx,vy
end

function touch_platform(ball, platform, vx, vy)
	return touch_alogrithm(ball, platform, vx, vy)
end

function touch_bricks(ball, bricks, vx, vy)
	-- find the nearest brick
	local _index, min_x, min_y = 1, love.graphics.getWidth(), love.graphics.getHeight()

	for i=1, #bricks do
		local x, y = math.abs(ball.x+vx - bricks[i].position.x - bricks[i].width/2 ), 
			math.abs(ball.y+vy - bricks[i].position.y - bricks[i].height/2 )
		if x <= min_x and y <= min_y and bricks[i].visible == true then
			min_x, min_y = x, y
			_index = i
		end
	end
	vx, vy = touch_brick(ball, bricks[_index], vx, vy)

	return vx, vy
end

function touch_brick(ball, brick, vx, vy)
	if(brick.visible == false) then
		return vx,vy
	end
	return touch_alogrithm(ball, brick, vx, vy, function () brick.visible = false end)
end

function touch_alogrithm(_ball, _square, vx, vy, add_event)
	if(not add_event) then
		add_event = function() end
	end

	if(not (_ball.x <= _square.position.x + _square.width + _ball.r 
	and _ball.x >= _square.position.x - _ball.r
	and _ball.y <= _square.position.y + _square.height + _ball.r
	and _ball.y >= _square.position.y - _ball.r)) then
		if(_ball.x + vx <= _square.position.x + _square.width + _ball.r 
		and _ball.x + vx >= _square.position.x - _ball.r
		and _ball.y + vy <= _square.position.y + _square.height + _ball.r
		and _ball.y + vy >= _square.position.y - _ball.r) then
			if(_ball.x > _square.position.x + _square.width + _ball.r 
			or _ball.x < _square.position.x - _ball.r) then
				vx = -vx
				add_event()
			elseif(_ball.y > _square.position.y + _square.height + _ball.r
			or _ball.y < _square.position.y - _ball.r) then
				vy = -vy
				add_event()
			else
				vx = -vx
				vy = -vy
				add_event()
			end
		end
	end

	return vx, vy
end

-- ------------------

function gamewin_draw()
	love.graphics.setColor(1,1,1)
	local font = love.graphics.newFont(hack_font_ttf_path, 40)
	love.graphics.setFont(font)
	local text = "You Win!"
	love.graphics.print(
		text, 
		(love.graphics.getWidth()- font:getWidth(text))/2, 
		(love.graphics.getHeight()- font:getHeight())/2
	)

	local offsetY = 100

	local btn = {}
	btn.position = {x = love.graphics.getWidth()/2,
		y = love.graphics.getHeight()/2 + offsetY}
	btn.text = 'restart'
	TextButton:draw(btn, restart)
end

function gameover()
	GAME_OVER = 1
end

function gameover_draw()
	love.graphics.setColor(1,1,1)
	local font = love.graphics.newFont(hack_font_ttf_path, 40)
	love.graphics.setFont(font)
	local text = "Game Over"
	love.graphics.print(
		text, 
		(love.graphics.getWidth()- font:getWidth(text))/2, 
		(love.graphics.getHeight()- font:getHeight())/2
	)

	local offsetY = 100
	local btn = {}
	btn.position = {x = love.graphics.getWidth()/2,
		y = love.graphics.getHeight()/2 + offsetY}
	btn.text = 'restart'
	TextButton:draw(btn,init)

end


-- init bricks
function  bricks_init()
	for i = 1, 10 do
		local b = {
			color = {0.8,0.8,0},
			position = {x = 100 * i - 90, y = 100},
			height = 40,
			width = 80,
			visible = true
		}
		table.insert(bricks, b)
	end
end

-- draw brick in bricks
function bricks_draw()
	for i in ipairs(bricks) do
		Brick:draw(bricks[i])
	end
end