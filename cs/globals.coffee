
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

randRange = (lo,hi) -> lo + Math.random() * (hi - lo)
expovariate = (duration) -> -Math.log(1.0 - Math.random()) * duration
scratchManifold = new WorldManifold

queueFrame = (state) ->
	# tick time
	dt = rawMillis() - time
	time = rawMillis()
	dt = Math.min(dt, 22)
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

GRAVITY = 32

TILE_TYPE_EMPTY = 0
TILE_TYPE_SOLID = 1
TILE_TYPE_DISTRACTION = 2

K = 1.0 / 32.0
pixToTile = (x) -> Math.floor(K*x)
tileId = (x,y) -> x + TILE_WIDTH * y

PIXELS_PER_METER = 32
MPP = 1.0/PIXELS_PER_METER

DEBUG_PHYSICS = yes
showPhysics = no

