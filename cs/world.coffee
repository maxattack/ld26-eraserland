
class Tile
	constructor: (i) ->
		@x = i % TILE_WIDTH
		@y = (i - @x) / TILE_WIDTH
		@type = TILE_TYPE_EMPTY
		@body = null

	isSolid: -> @type == TILE_TYPE_SOLID
	isVisible: -> @type != TILE_TYPE_EMPTY

	initPhysics: ->
		return unless @isSolid()
		fixDef = new FixtureDef
		fixDef.density = 1
		fixDef.friction = 0.5
		fixDef.restitution = 0.2
		bodyDef = new BodyDef
		bodyDef.type = Body.b2_staticBody
		bodyDef.position.Set(@x+0.5, @y+0.5)
		fixDef.shape = new PolygonShape
		fixDef.shape.SetAsBox(0.5, 0.5)
		@body = world.physics.CreateBody(bodyDef)
		@body.CreateFixture(fixDef)

	erase: ->
		return false if @type == TILE_TYPE_EMPTY
		if @body?
			world.physics.DestroyBody(@body) 
			@body = null
		@type = TILE_TYPE_EMPTY
		true

	draw: ->
		return unless @isVisible()
		x = @x<<5; y = @y<<5
		g.drawImage(images.testBaked, x+x, y+y, 64, 64, x-16, y-16, 64, 64)

class World
	constructor: ->
		@offsetX = 0.5 * (canvas.width - WORLD_WIDTH) + 2
		@offsetY = 0.5 * (canvas.height - WORLD_HEIGHT) + 20
		@tiles = (new Tile(i) for i in [0..(TILE_WIDTH*TILE_HEIGHT-1)])

		@hero = new HeroSprite
		@cupcake = new CupcakeSprite

		# create a bounded physics world
		@physics = new b2World(new Vec2(0, GRAVITY / PIXELS_PER_METER), no)
		
		# add walls
		fixDef = new FixtureDef
		fixDef.density = 1.0
		fixDef.friction = 0.5
		fixDef.restitution = 0.2
		bodyDef = new BodyDef
		bodyDef.type = Body.b2_staticBody
		bodyDef.position.Set(TILE_WIDTH/2, TILE_HEIGHT+0.5)
		fixDef.shape = new PolygonShape
		fixDef.shape.SetAsBox(TILE_WIDTH/2+1, 0.5)
		# @physics.CreateBody(bodyDef).CreateFixture(fixDef)
		bodyDef.position.y = -0.5
		@physics.CreateBody(bodyDef).CreateFixture(fixDef)
		fixDef.shape = new PolygonShape
		fixDef.shape.SetAsBox(0.5, TILE_HEIGHT/2)
		bodyDef.position.Set(-0.5, TILE_HEIGHT/2)
		@physics.CreateBody(bodyDef).CreateFixture(fixDef);
		bodyDef.position.x = TILE_WIDTH+0.5
		@physics.CreateBody(bodyDef).CreateFixture(fixDef);

		if DEBUG_PHYSICS
			debugDraw = new DebugDraw()
			debugDraw.SetSprite(g)
			debugDraw.SetDrawScale(PIXELS_PER_METER)
			debugDraw.SetFillAlpha(0.5)
			debugDraw.SetLineThickness(4.0)
			debugDraw.SetFlags(DebugDraw.e_shapeBit | DebugDraw.e_jointBit)
			@physics.SetDebugDraw(debugDraw)


		# physics test
		bodyDef.type = Body.b2_dynamicBody;
		for i in [0..9]
			if Math.random() > 0.5
				fixDef.shape = new PolygonShape
				fixDef.shape.SetAsBox(randRange(0.1, 1), randRange(0.1,1))
			else
				fixDef.shape = new CircleShape(randRange(0.1,2))
			bodyDef.position.Set(randRange(1, TILE_WIDTH-1), randRange(1, 4))
			@physics.CreateBody(bodyDef).CreateFixture(fixDef)

	tick: ->
		@physics.Step(deltaSeconds(), 10, 10)

		# erase tiles?
		if mouseDown
			@tileUnder(mouseX, mouseY)?.erase()
		@cupcake.tick()
		@hero.tick()

	draw: ->
		g.save()
		g.translate(@offsetX, @offsetY)
		@physics.DrawDebugData() if DEBUG_PHYSICS
		tile.draw() for tile in @tiles				
		@cupcake.draw()
		@hero.draw()
		g.restore()

	getTile: (x,y) -> 
		if x >= 0 and x < TILE_WIDTH and y >= 0 and y < TILE_HEIGHT
			@tiles[Math.floor(x) + TILE_WIDTH * Math.floor(y)] 
		else 
			null

	tileUnder: (px, py) -> 
		@getTile(
			Math.floor((px - @offsetX) / TILE_SIZE), 
			Math.floor((py - @offsetY) / TILE_SIZE)
		)

setupTest = ->
	for i in [0..TILE_WIDTH-1]
		world.getTile(i, 14).type = TILE_TYPE_SOLID
		world.getTile(i, 15).type = TILE_TYPE_DISTRACTION

	tile.initPhysics() for tile in world.tiles

	world.hero.x = 32
	world.hero.y = 12*32
	world.hero.vx = 16

	world.cupcake.x = 20*32
	world.cupcake.y = 9*32
