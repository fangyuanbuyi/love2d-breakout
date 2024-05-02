run:
	love $(abspath ./)

package:
	zip -9 -q -r game.love ./modules ./conf.lua ./main.lua ./font

export_for_win:
	rm -rf love/
	unzip -u love/love-11.5-win64.zip -d love/
	mkdir -p love/game
	cat love/love-11.5-win64/love.exe game.love > love/game/game.exe
	cp love/love-11.5-win64/license.txt love/love-11.5-win64/*.dll \
		love/game