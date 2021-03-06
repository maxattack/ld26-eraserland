# entry-point function
doc = null

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
		doc.on 'keydown.debugPhysics', (e) -> 
			showPhysics = !showPhysics if e.which == 80
			true


	# init various globals
	time = rawMillis()
	new Pencil

	transition = 0
	timeout = 0
	totalLevels = 5
	currentLevel = -1

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
			currentLevel = 0
			beginGameplay()
		else
			world.draw()
			pencil.draw()
			queueFrame doStartScreen

	beginGameplay = ->
		switch currentLevel
			when 0 then new World1
			when 1 then new World2
			when 2 then new World3
			when 3 then new World4
			# when 4 then new World5
			when 4 then new World6
			else
				world?.onDestroy() 
				world = null
		if world?
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

		if transition >= 0.8
			hint = images["lose#{currentLevel+1}"]
			if hint?
				hintt = 5*(transition-0.8)
				g.drawImage(
					hint
					0.5 * (canvas.width - hint.width),
					500 - 50 * hintt * hintt
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
		duration = 4
		transition += 0.1 * (1.0 - transition)
		clearBackground()
		u = timeout/(0.25*duration)
		u = 1 if u > 1
		g.globalAlpha = (1-u)*(1-u)
		world.draw()
		g.globalAlpha = 1

		g.drawImage(
			images.winScreen,
			0.5 * (canvas.width - images.winScreen.width),
			175 * transition
		)
		pencil.draw()

		timeout += deltaSeconds()
		if timeout > duration
			if currentLevel < totalLevels-1
				currentLevel++
				beginGameplay()
			else
				doThankYou()
		else
			queueFrame doWinScreenIn

	lastMinuteBlash = 0
	doThankYou = ->
		lastMinuteBlash += 0.25 * (1 - lastMinuteBlash)
		if lastMinuteBlash > 0.999
			g.globalAlpha = 1
		else
			g.globalAlpha = lastMinuteBlash
		clearBackground()
		g.drawImage(
			images.winwinwin,
			0.5 * (canvas.width - images.winwinwin.width),
			0.5 * (canvas.height - images.winwinwin.height)
		)
		g.globalAlpha = 1
		pencil.draw()
		queueFrame doThankYou

	loadingImages.startLoading()
	if currentLevel == -1
		if (new Audio()).canPlayType('audio/ogg; codecs=vorbis') == 'probably'
			music = new Audio('audio/music.ogg')
			music.loop = true
			music.play()

	do ->
		if loadingImages.loading()
			if images.failed()
				alert "Eek! Failed to load Assets :*("
			else
				queueFrame arguments.callee
		else
			beginLoadingGame()

	progress = 0
	fakeTimer = 0

	beginLoadingGame = ->
		images.startLoading()
		doLoadGame()

	doLoadGame = ->
		clearBackground()
		# fakeTimer += deltaSeconds()
		# if fakeTimer < 3
		if images.loading()
			if images.failed()
				alert "Eek! Failed to load Assets :*("
			else
				# rawProgress = fakeTimer / 3
				rawProgress = images.progress()
				progress += 0.1 * (rawProgress - progress)
				i = Math.floor(progress * 9 + 0.5)
				i = Math.min(8, i)
				im = loadingImages["donutErase0#{9-i}"]
				g.drawImage(
					loadingImages.loadingText,
					0.5 * (canvas.width - loadingImages.loadingText.width),
					0.5 * (canvas.height - loadingImages.loadingText.height)
				)
				g.drawImage(
					im,
					0.5 * (canvas.width - im.width),
					0.5 * (canvas.height - im.height)+50
				)
				queueFrame doLoadGame
		else if currentLevel == -1
			beginStartScreen()
		else
			beginGameplay()

