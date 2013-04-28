
class Tile
	constructor: (i) ->
		@x = i % TILE_WIDTH
		@y = (i - @x) / TILE_WIDTH
		@type = TILE_TYPE_EMPTY
		@body = null

	isSolid: -> @type == TILE_TYPE_SOLID
	isVisible: -> @type != TILE_TYPE_EMPTY

	setSolid: ->
		alert 'EEK!' if @type != TILE_TYPE_EMPTY
		@type = TILE_TYPE_SOLID
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
		@body.SetUserData(this)

	setDistracting: ->
		alert 'ACK!' if @type != TILE_TYPE_EMPTY
		@type = TILE_TYPE_DISTRACTION

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
		g.drawImage(world.tilemap, x+x, y+y, 64, 64, x-16, y-16, 64, 64)
