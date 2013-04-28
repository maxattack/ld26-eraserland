
TAU = Math.PI + Math.PI

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
	'images/first_baked.png'
	'images/startScreen_baked.png'
	'images/loseScreen.png'
	'images/winScreen.png'
	'images/heart1.png'
]

pencil = null
world = null
scratchManifold = new WorldManifold

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

clearBackground = -> 
	g.clearRect(0, 0, canvas.width, canvas.height)
	#g.drawImage images.background, 0, 0

TILE_SIZE = 32
TILE_WIDTH = 26
TILE_HEIGHT = 16
WORLD_WIDTH = TILE_SIZE * TILE_WIDTH
WORLD_HEIGHT = TILE_SIZE * TILE_HEIGHT


GRAVITY = 1024

TILE_TYPE_EMPTY = 0
TILE_TYPE_SOLID = 1
TILE_TYPE_DISTRACTION = 2

K = 1.0 / 32.0
pixToTile = (x) -> Math.floor(K*x)
tileId = (x,y) -> x + TILE_WIDTH * y

PIXELS_PER_METER = 32

DEBUG_PHYSICS = yes
showPhysics = no

