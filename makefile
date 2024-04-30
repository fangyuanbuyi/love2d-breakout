run:
	love $(abspath ./)

package:
	zip -9 -q -r game.love ./modules ./conf.lua ./main.lua
