
TILE_SIZE = 32
K = 1.0 / 32.0
TILE_WIDTH = 26
TILE_HEIGHT = 16
EMPTY = 0
WALL = 1

pixToTile = (x) -> Math.floor(K*x)

class Tile
	constructor: (i) ->
		@x = i % TILE_WIDTH
		@y = (i - @x) / TILE_WIDTH
		@type = EMPTY

	clear: -> @type = EMPTY

	isSolid: -> @type == WALL

	draw: ->
		if @type == WALL
			g.fillStyle = 'rgba(24, 24, 48, 1.0)'
			g.fillRect(@x*TILE_SIZE, @y*TILE_SIZE, TILE_SIZE-1, TILE_SIZE-1)

STATUS_WALKING = 0
STATUS_FALLING = 1

class HeroSprite
	constructor: ->
		@x = 0; @y = 0
		@vx = 0; @vy = 0
		@status = STATUS_WALKING

	tick: ->
		switch @status
			
			when STATUS_WALKING
				xprev = pixToTile(@x)
				@x += @vx * deltaSeconds()
				xnext = pixToTile(@x)
				# did we cross a tile boundary?
				unless xnext == xprev
					top = pixToTile(@y)
					if @vx > 0
						# did we fall right
						unless world.getTile(xnext, top+2)?.isSolid()
							@x = TILE_SIZE * xnext
							@vy = 128
							@status = STATUS_FALLING
						# did we collide right?
						else if world.getTile(xnext+1, top)?.isSolid() or world.getTile(xnext+1, top+1)?.isSolid()
							@vx = -@vx;
							@x = TILE_SIZE * xnext
					else
						# did we fall left?
						unless world.getTile(xnext+1, top+2)?.isSolid()
							@x = TILE_SIZE * (xnext+1)
							@vy = 128
							@status = STATUS_FALLING
						# did we collide left?
						else if world.getTile(xnext, top)?.isSolid() or world.getTile(xnext, top+1)?.isSolid()
							@vx = -@vx;
							@x = TILE_SIZE * (xnext+1)
			
			when STATUS_FALLING
				@vy += 1024 * deltaSeconds()
				@y += @vy * deltaSeconds()
				# did we hit the ground?
				x = pixToTile(@x)
				y = pixToTile(@y)+2
				if world.getTile(x, y)?.isSolid()
					@vy = 0
					@y -= @y % TILE_SIZE
					@status = STATUS_WALKING

	draw: ->
		frame = Math.floor(seconds() * 10) % 10
		w = images.walk.width
		h = images.walk.height / 10
		# g.fillStyle = 'rgba(255, 255, 0, 0.333)'
		# g.fillRect(@x, @y, 32, 64)
		if @vx < 0
			g.save()
			g.translate(@x-6, @y)
			g.translate(w/2, 0)
			g.scale(-1, 1)
			g.drawImage(images.walk, 0, frame * h, w, h, -w/2, 0, w, h)
			g.restore()
		else
			g.drawImage(images.walk, 0, frame * h, w, h, @x-6, @y, w, h)

class CupcakeSprite
	constructor: ->
		@x = 0; @y = 0

	draw: ->
		frame = Math.floor(seconds() * 7.5) % 6
		w = images.cupcake.width
		h = images.cupcake.height / 6
		g.drawImage(images.cupcake, 0, frame * h, w, h, @x, @y+5, w, h)


class World
	constructor: ->
		@offsetX = 0.5 * (canvas.width - TILE_SIZE * TILE_WIDTH) + 2
		@offsetY = 0.5 * (canvas.height - TILE_SIZE * TILE_HEIGHT) + 20
		@tiles = (new Tile(i) for i in [0..(TILE_WIDTH*TILE_HEIGHT-1)])

		@hero = new HeroSprite
		@cupcake = new CupcakeSprite


	tick: ->
		# erase tiles?
		if mouseDown
			tile = @tileUnder(mouseX, mouseY)
			tile.clear() if tile?
		
		@hero.tick()

	draw: ->
		g.save()
		g.translate(@offsetX, @offsetY)
		tile.draw() for tile in @tiles				
		@cupcake.draw()
		@hero.draw()
		g.restore()

	getTile: (x,y) -> 
		if x >= 0 and x < TILE_WIDTH and y >= 0 and y < TILE_HEIGHT then @tiles[Math.floor(x) + TILE_WIDTH * Math.floor(y)] else null
	tileUnder: (px, py) -> 
		@getTile(
			Math.floor((px - @offsetX) / TILE_SIZE), 
			Math.floor((py - @offsetY) / TILE_SIZE)
		)

setupTest = ->
	for i in [0..TILE_WIDTH-1]
		world.getTile(i, 15).type = WALL

	for i in [0..4]
		world.getTile(i, 11).type = WALL

	for i in [0..TILE_HEIGHT-1]
		world.getTile(0,i).type = WALL
		world.getTile(10,i).type = WALL
	world.hero.x = 32
	world.hero.y = 9*32
	world.hero.vx = 128

	world.cupcake.x = 20*32
	world.cupcake.y = 13*32
