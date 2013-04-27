
CUPCAKE_STATUS_IDLE = 0
CUPCAKE_STATUS_FALLING = 1

class CupcakeSprite
	constructor: ->
		@x = 0; @y = 0
		@vy = 0
		@status = CUPCAKE_STATUS_IDLE

	draw: ->
		frame = Math.floor(seconds() * 7.5) % 6
		w = images.cupcake.width
		h = images.cupcake.height / 6
		g.drawImage(images.cupcake, 0, frame * h, w, h, @x, @y+4, w, h)

	tick: ->
		switch @status
			when CUPCAKE_STATUS_IDLE then @tickIdle()
			when CUPCAKE_STATUS_FALLING then @tickFalling()

	tickIdle: ->
		x = pixToTile(@x)
		y = pixToTile(@y)
		unless world.getTile(x, y+2)?.isSolid() or world.getTile(x+1, y+2)?.isSolid()
			@vy = 128
			@status = CUPCAKE_STATUS_FALLING

	tickFalling: ->
		@vy += GRAVITY * deltaSeconds()
		@y += @vy * deltaSeconds()
		x = pixToTile(@x); y = pixToTile(@y)
		if world.getTile(x, y+2)?.isSolid() or world.getTile(x+1, y+2)?.isSolid()
			@vy = 0
			@y -= @y % TILE_SIZE
			@status = CUPCAKE_STATUS_IDLE

