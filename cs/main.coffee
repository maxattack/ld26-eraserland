# entry-point function

$ ->
	# get canvas context
	canvas = $('canvas')[0]
	unless canvas?.getContext?
		alert 'HTML5 Required, Dude'
		return
	g = canvas.getContext('2d')

	# get mouse position
	doc = $(this)
	doc.mousemove (e) ->
		mouseX = e.pageX - canvas.offsetLeft
		mouseY = e.pageY - canvas.offsetTop
	doc.mousedown (e) ->
		return unless e.which == 1
		mouseX = e.pageX - canvas.offsetLeft
		mouseY = e.pageY - canvas.offsetTop
		mouseDown = yes
		mousePressed = yes
		if mouseX >= 0 and mouseX < canvas.width and mouseY >= 0 and mouseY < canvas.height
			e.preventDefault()
	doc.mouseup (e) ->
		return unless e.which == 1
		mouseX = e.pageX - canvas.offsetLeft
		mouseY = e.pageY - canvas.offsetTop
		mouseDown = no
		mouseReleased = yes
		if mouseX >= 0 and mouseX < canvas.width and mouseY >= 0 and mouseY < canvas.height
			e.preventDefault()

	if DEBUG_PHYSICS
		doc.keydown (e) -> showPhysics = !showPhysics if e.which == 80

	# start music?
	# if (new Audio()).canPlayType('audio/ogg; codecs=vorbis') == 'probably'
	# 	music = new Audio('audio/music.ogg')
	# 	music.loop = true
	# 	music.play()

	# init various globals
	time = rawMillis()
	new Pencil

	beginStartScreen = ->
		new World(startScreen)
		doStartScreen()

	doStartScreen = ->
		clearBackground()
		clearBackground()
		world.tick()

		# determine if there are not solid tiles
		anySolid = no
		for tile in world.tiles
			if tile.isSolid()
				anySolid = yes
				break

		unless anySolid
			beginGameplay()
		else
			world.draw()
			pencil.draw()
			queueFrame doStartScreen

	beginGameplay = ->
		new World(testLevel)
		doGameplay()

	doGameplay = ->
		clearBackground()
		world.tick()
		world.draw()
		pencil.draw()
		queueFrame doGameplay

	# wait for assets to load then GOOOOO
	do ->
		if images.loading()
			if images.failed()
				alert "Eek! Failed to load Assets :*("
			else
				queueFrame arguments.callee		
		else
			#beginStartScreen()
			beginGameplay()
