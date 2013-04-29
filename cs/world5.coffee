
# class World5
# 	constructor: ->
# 		world.onDestroy() if world?
# 		world = this
# 		@tilemap = null
# 		@tilemaps = fifthLevel.tilemaps
# 		@offsetX = 0.5 * (canvas.width - WORLD_WIDTH) + 2
# 		@offsetY = 0.5 * (canvas.height - WORLD_HEIGHT) + 20
# 		@physics = setupPhysics(GRAVITY, no)
# 		@mPhysicsMouse = Vec2.Make(0,0)		
# 		@tiles = [
# 			(new Tile(i) for i in [0..(TILE_WIDTH*TILE_HEIGHT-1)])
# 			(new Tile(i) for i in [0..(TILE_WIDTH*TILE_HEIGHT-1)])
# 			(new Tile(i) for i in [0..(TILE_WIDTH*TILE_HEIGHT-1)])
# 		]
# 		for li in @tiles
# 			tile.setDistracting() for tile in li
		
# 		@status = STATUS_ACTIVE

# 	onTick: ->
# 	onDraw: ->
# 	onDestroy: ->

# 	physicsMouse: ->
# 		@mPhysicsMouse.Set(
# 			(mouseX - @offsetX)/PIXELS_PER_METER,
# 			(mouseY - @offsetY)/PIXELS_PER_METER
# 		)
# 		@mPhysicsMouse

# 	tick: ->
# 		return unless @status == STATUS_ACTIVE
# 		@physics.Step(deltaSeconds(), 10, 10)
# 		if @status == STATUS_ACTIVE
# 			@tileUnder(mouseX, mouseY)?.erase() if mouseDown
# 			@onTick()

# 	draw: ->
# 		g.save()
# 		g.translate(@offsetX, @offsetY)
# 		@physics.DrawDebugData() if DEBUG_PHYSICS and showPhysics
# 		for y in [0..TILE_HEIGHT-1]
# 			for x in [0..TILE_WIDTH-1]
# 				do =>
# 					for i in [0..2]
# 						tile = @getTileI(i, x, y)
# 						if tile? and tile.isVisible()
# 							@tilemap = @tilemaps[i]
# 							tile.draw()
# 							return
# 		@onDraw()
# 		g.restore()

# 	getNonEmptyTileAt: (x,y) ->
# 		result = @getTileI(0, x, y)
# 		# result = @getTileI(1, x, y) unless result? and result.isVisible()
# 		# result = @getTileI(2, x, y) unless result? and result.isVisible()
# 		result

# 	getTileI: (i,x,y) -> 
# 		if x>=0 and x<TILE_WIDTH and y>=0 and y<TILE_HEIGHT then @tiles[i][tileId(x,y)] else null

# 	tileUnder: (px, py) -> 
# 		@getNonEmptyTileAt(
# 			Math.floor((px - @offsetX) / TILE_SIZE), 
# 			Math.floor((py - @offsetY) / TILE_SIZE)
# 		)
