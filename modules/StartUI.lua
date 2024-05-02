require('modules.TextButton')

function start_ui_draw()
	local font = love.graphics.newFont(hack_font_ttf_path, 22)
	love.graphics.setFont(font)

	local btn = TextButton
	btn.position = {x=love.graphics.getWidth()/2, y=love.graphics.getHeight()/2}
	btn.text = 'start'
	TextButton:draw(btn, function() START_UI_DISPLAY=0 end)
	local btn = TextButton
	btn.position = {x=love.graphics.getWidth()/2, y=love.graphics.getHeight()/2 + 60}
	btn.text = 'quit'
	TextButton:draw(btn, function() love.event.quit() end)

	local text_width = font:getWidth('→ : move to right')
	local text_start_position = {x = (love.graphics.getWidth()-text_width)/2, y = 480}
	love.graphics.print('→ : move to right', 
		text_start_position.x, text_start_position.y)
	love.graphics.print('← : move to left', 
		text_start_position.x, text_start_position.y + font:getHeight())
	love.graphics.print('↑ : launch ball', 
		text_start_position.x, text_start_position.y + font:getHeight()*2)
end