
HERO_STATUS_WALKING = 0
HERO_STATUS_FALLING = 1

class HeroSprite
	constructor: ->
		@x = 0; @y = 0
		@vx = 0; @vy = 0
		@status = HERO_STATUS_WALKING

	tick: ->
		switch @status
			when HERO_STATUS_WALKING then @tickWalking()
			when HERO_STATUS_FALLING then @tickFalling()

	tickWalking: ->
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
					@status = HERO_STATUS_FALLING
				# did we collide right?
				else if world.getTile(xnext+1, top)?.isSolid() or world.getTile(xnext+1, top+1)?.isSolid()
					@vx = -@vx;
					@x = TILE_SIZE * xnext
			else
				# did we fall left?
				unless world.getTile(xnext+1, top+2)?.isSolid()
					@x = TILE_SIZE * (xnext+1)
					@vy = 128
					@status = HERO_STATUS_FALLING
				# did we collide left?
				else if world.getTile(xnext, top)?.isSolid() or world.getTile(xnext, top+1)?.isSolid()
					@vx = -@vx;
					@x = TILE_SIZE * (xnext+1)
	
	tickFalling: ->
		@vy += GRAVITY * deltaSeconds()
		@y += @vy * deltaSeconds()
		# did we hit the ground?
		x = pixToTile(@x)
		y = pixToTile(@y)+2
		if world.getTile(x, y)?.isSolid()
			@vy = 0
			@y -= @y % TILE_SIZE
			@status = HERO_STATUS_WALKING

	draw: ->
		frame = Math.floor(seconds() * 10) % 10
		w = images.walk.width; h = images.walk.height / 10
		# g.fillStyle = 'rgba(255, 255, 0, 0.333)'
		# g.fillRect(@x, @y, 32, 64)
		if @vx < 0
			g.save()
			g.translate(@x-6, @y)
			g.translate(w/2, 0)
			g.scale(-1, 1)
			g.drawImage(images.walk, 0, frame * h, w, h, -w/2, 0, w, h+2)
			g.restore()
		else
			g.drawImage(images.walk, 0, frame * h, w, h, @x-6, @y, w, h+2)
