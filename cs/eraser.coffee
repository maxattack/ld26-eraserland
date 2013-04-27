

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
		mouseX = e.pageX - canvas.offsetLeft
		mouseY = e.pageY - canvas.offsetTop
		mouseDown = yes
		mousePressed = yes
		if mouseX >= 0 and mouseX < canvas.width and mouseY >= 0 and mouseY < canvas.height
			e.preventDefault()
	doc.mouseup (e) ->
		mouseX = e.pageX - canvas.offsetLeft
		mouseY = e.pageY - canvas.offsetTop
		mouseDown = no
		mouseReleased = yes
		if mouseX >= 0 and mouseX < canvas.width and mouseY >= 0 and mouseY < canvas.height
			e.preventDefault()

	# start music?
	# if (new Audio()).canPlayType('audio/ogg; codecs=vorbis') == 'probably'
	# 	music = new Audio('audio/music.ogg')
	# 	music.loop = true
	# 	music.play()

	# init various globals
	time = rawMillis()
	pencil = new Pencil
	world = new World

	setupTest()

	doGameplay = ->
		drawBackground()

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
			queueFrame doGameplay