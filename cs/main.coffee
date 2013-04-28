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
		new World startScreen
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

	transition = 0
	timeout = 0

	beginGameplay = ->
		new World2
		transition = 0
		doGameplay()

	doGameplay = ->
		clearBackground()
		world.tick()
		transition += 0.1 * (1.0 - transition)
		g.globalAlpha = transition if transition < 0.99
		world.draw()
		g.globalAlpha = 1 if transition < 0.99
		pencil.draw()
		switch world.status
			when STATUS_LOSE then beginLose()
			when STATUS_WIN then beginWin()
			else queueFrame doGameplay

	beginLose = ->
		transition = 0
		timeout = 0
		queueFrame doLoseScreenIn

	doLoseScreenIn = ->
		duration = 4
		transition += 0.1 * (1.0 - transition)
		clearBackground()
		u = timeout/(0.25*duration)
		u = 1 if u > 1
		g.globalAlpha = (1-u)*(1-u)
		world.draw()
		g.globalAlpha = 1

		g.drawImage(
			images.loseScreen,
			0.5 * (canvas.width - images.loseScreen.width),
			175 * transition
		)
		pencil.draw()

		timeout += deltaSeconds()
		if timeout > duration
			beginGameplay()
		else
			queueFrame doLoseScreenIn

	beginWin = ->
		transition = 0
		timeout = 0
		queueFrame doWinScreenIn

	doWinScreenIn = ->
		transition += 0.1 * (1.0 - transition)
		clearBackground()
		world.draw()
		g.drawImage(images.heart1, canvas.width-200, canvas.height - 200)
		g.drawImage(
			images.winScreen,
			0.5 * (canvas.width - images.winScreen.width),
			125 * transition
		)
		pencil.draw()
		queueFrame doWinScreenIn


	do ->
		if images.loading()
			if images.failed()
				alert "Eek! Failed to load Assets :*("
			else
				queueFrame arguments.callee		
		else
			# beginStartScreen()
			beginGameplay()
