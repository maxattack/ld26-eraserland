SCRIPTS = cs/util.coffee \
	cs/globals.coffee \
	cs/pencil.coffee \
	cs/world.coffee \
	cs/hero.coffee \
	cs/cupcake.coffee \
	cs/eraser.coffee

test:
	coffee -j eraser.js -c -o ./  $(SCRIPTS)
	mv eraser.js js/eraser.js
	open http://peapod.local/ld26/index.html
