SCRIPTS = cs/util.coffee \
	cs/globals.coffee \
	cs/pencil.coffee \
	cs/content.coffee \
	cs/world.coffee \
	cs/world1.coffee \
	cs/world2.coffee \
	cs/world3.coffee \
	cs/world4.coffee \
	cs/world5.coffee \
	cs/world6.coffee \
	cs/main.coffee

test:
	coffee -j eraser.js -c -o ./  $(SCRIPTS)
	mv eraser.js js/eraser.js
	#open http://peapod.local/ld26/index.html
	open index.html
