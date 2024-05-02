require('modules.TextButton')
require('modules.Brick')
require('test')

hack_font_ttf_path = "font/hack/Hack-Bold.ttf"



function love.load()
	ball = {
		vx = 15,
		vy = -8,
		x = 100,
		y = 600,
		r = 20
	}
	platform = {
		width = 120,
		height = 20,
		pos_x = 400,
		pos_y = 640
	}
	bricks = {}
	bricks_init()
	GAME_OVER = 1
	GAME_WIN = 0
end

function get_input()
	-- base change velocity
	local vx = 20

	-- normal input
	if(love.keyboard.isDown("left")) then
		platform.pos_x = platform.pos_x - vx
	elseif(love.keyboard.isDown("right")) then
		platform.pos_x = platform.pos_x + vx
	end

	-- test input 
	-- when game is finished, it will be hidden
	test_input(platform, ball)
	
	-- if input will make platform beyond the edge
	-- then adjust its position
	if(platform.pos_x < 0) then
		platform.pos_x = 0
	elseif (platform.pos_x + platform.width > love.graphics.getWidth()) then
		platform.pos_x = love.graphics.getWidth() - platform.width
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
	for i in ipairs(bricks) do
		if(bricks[i].visible == true) then
			GAME_WIN = 0
		end
	end

end

function love.draw()
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
	love.graphics.polygon('fill', platform.pos_x, platform.pos_y, 
		platform.pos_x+platform.width, platform.pos_y, 
		platform.pos_x+platform.width, platform.pos_y+platform.height, 
		platform.pos_x, platform.pos_y+platform.height)
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

function touch_bricks(ball, bricks, vx, vy)
	for i in ipairs(bricks) do
		vx, vy = touch_brick(ball, bricks[i], vx, vy)
	end
	return vx, vy
end

function touch_brick(ball, brick, vx, vy)
	if(brick.visible == false) then
		return vx,vy
	end

	if(ball.y + ball.r >= brick.position.y 
	and ball.y - ball.r <= brick.position.y + brick.height) then
		if(vx > 0 
		and ball.x + ball.r <= brick.position.x 
		and ball.x + ball.r + vx > brick.position.x) then
			vx = -vx
			ball.x = brick.position.x - ball.r
			brick.visible = false
		elseif(vx < 0 
		and ball.x - ball.r >= brick.position.x + brick.width
		and ball.x - ball.r + vx < brick.position.x + brick.width)  then
			vx = - vx
			ball.x = brick.position.x + brick.width + ball.r
			brick.visible = false
		end
	end
	if(ball.x + ball.r >= brick.position.x 
	and ball.x - ball.r <= brick.position.x + brick.width) then
		if(vy > 0
		and ball.y + ball.r <= brick.position.y	
		and ball.y + ball.r + vy > brick.position.y) then
			vy = -vy
			ball.y = brick.position.y - ball.r
			brick.visible = false
		elseif (vy < 0
		and ball.y - ball.r >= brick.position.y + brick.height
		and ball.y - ball.r + vy < brick.position.y + brick.height) then
			vy = -vy
			ball.y = brick.position.y + brick.height + ball.r
			brick.visible = false
		end
	end
	return vx, vy
end

-- ------------------

function start_ui_draw()
	-- unfinshed
end

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
	TextButton:draw(btn,restart)

end

function restart()
	platform.pos_x, platform.pos_y = 400, 600
	
	local x1 = love.math.random() * love.graphics.getWidth()

	if(x1 < ball.r) then x1 = ball.r end
	if(x1 > love.graphics.getWidth()-ball.r) then x1 = love.graphics.getWidth()-ball.r end

	ball.vx, ball.vy, ball.x, ball.y  = 15, 8, x1, 100

	GAME_OVER = 0
	GAME_WIN = 0

	for i in ipairs(bricks) do
		bricks[i].visible = true
	end
end

-- init bricks
function  bricks_init()
	for i = 0, 5 do
		local b = {
			color = {0.8,0.8,0},
			position = {x = 100 * i + 10, y = 100},
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