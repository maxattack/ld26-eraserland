TAU = Math.PI + Math.PI

setMessage = (msg) ->
	$('#logger').html(msg)


canvas = null
g = null
mouseX = 0
mouseY = 0
mousePressed = no
mouseReleased = no
mouseDown = no

rawMillis = -> new Date().getTime()
dt = 0
time = 0
seconds = -> 0.001 * time
deltaSeconds = -> 0.001 * dt 

images = new ImageGroup [
	'images/pencil.png'
	'images/background.jpg'
	'images/walk.png'
	'images/cupcake.png'
]

pencil = null
world = null

queueFrame = (state) ->
	# tick time
	dt = rawMillis() - time
	time = rawMillis()
	dt = Math.min(dt, 33)
	# clear frame events
	mousePressed = no
	mouseReleased = no
	# enqueue next frame
	requestAnimationFrame state

drawBackground = -> 
	#g.clearRect(0, 0, canvas.width, canvas.height)
	g.drawImage images.background, 0, 0
