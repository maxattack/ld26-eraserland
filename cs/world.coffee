world = null

STATUS_ACTIVE = 0
STATUS_WIN = 1
STATUS_LOSE = 2

class World
	constructor: (options)->
		world = this
		{@tilemap} = options
		@offsetX = 0.5 * (canvas.width - WORLD_WIDTH) + 2
		@offsetY = 0.5 * (canvas.height - WORLD_HEIGHT) + 20
		@physics = setupPhysics()
		
		@tiles = (new Tile(i) for i in [0..(TILE_WIDTH*TILE_HEIGHT-1)])
		if options.solidTiles?
			@tiles[i].setSolid() for i in options.solidTiles
		if options.distractionTiles?
			@tiles[i].setDistracting() for i in options.distractionTiles
		
		@status = STATUS_ACTIVE

	onTick: ->
	onDraw: ->

	tick: ->
		return unless @status == STATUS_ACTIVE
		@physics.Step(deltaSeconds(), 10, 10)
		if @status == STATUS_ACTIVE
			@tileUnder(mouseX, mouseY)?.erase() if mouseDown
			@onTick()

	draw: ->
		g.save()
		g.translate(@offsetX, @offsetY)
		@physics.DrawDebugData() if DEBUG_PHYSICS and showPhysics
		tile.draw() for tile in @tiles				
		@onDraw()
		g.restore()

	getTile: (x,y) -> 
		if x >= 0 and x < TILE_WIDTH and y >= 0 and y < TILE_HEIGHT then @tiles[tileId(x,y)] else null

	tileUnder: (px, py) -> 
		@getTile(
			Math.floor((px - @offsetX) / TILE_SIZE), 
			Math.floor((py - @offsetY) / TILE_SIZE)
		)

setupPhysics = ->
	physics = new b2World(new Vec2(0, GRAVITY / PIXELS_PER_METER), no)


	bodyDef = new BodyDef
	bodyDef.type = Body.b2_staticBody
	bodyDef.position.Set(TILE_WIDTH/2, TILE_HEIGHT+0.5)

	fixDef = new FixtureDef
	fixDef.density = 1.0
	fixDef.friction = 0.5
	fixDef.restitution = 0.2
	fixDef.shape = new PolygonShape
	fixDef.shape.SetAsBox(TILE_WIDTH/2+1, 0.5)

	# physics.CreateBody(bodyDef).CreateFixture(fixDef)
	bodyDef.position.y = -0.5
	body = physics.CreateBody(bodyDef).CreateFixture(fixDef)
	fixDef.shape = new PolygonShape
	fixDef.shape.SetAsBox(0.5, TILE_HEIGHT/2)
	bodyDef.position.Set(-0.5, TILE_HEIGHT/2)
	physics.CreateBody(bodyDef).CreateFixture(fixDef);
	bodyDef.position.x = TILE_WIDTH+0.5
	physics.CreateBody(bodyDef).CreateFixture(fixDef);

	if DEBUG_PHYSICS
		debugDraw = new DebugDraw()
		debugDraw.SetSprite(g)
		debugDraw.SetDrawScale(PIXELS_PER_METER)
		debugDraw.SetFillAlpha(0.5)
		debugDraw.SetLineThickness(4.0)
		debugDraw.SetFlags(DebugDraw.e_shapeBit | DebugDraw.e_jointBit)
		physics.SetDebugDraw(debugDraw)

	# physics test
	# bodyDef.type = Body.b2_dynamicBody;
	# for i in [0..9]
	# 	if Math.random() > 0.5
	# 		fixDef.shape = new PolygonShape
	# 		fixDef.shape.SetAsBox(randRange(0.1, 1), randRange(0.1,1))
	# 	else
	# 		fixDef.shape = new CircleShape(randRange(0.1,2))
	# 	bodyDef.position.Set(randRange(1, TILE_WIDTH-1), randRange(1, 4))
	# 	physics.CreateBody(bodyDef).CreateFixture(fixDef)

	return physics


