
class CupcakeSprite
	constructor: (options) ->
		bodyDef = new BodyDef
		bodyDef.fixedRotation = yes
		bodyDef.type = Body.b2_dynamicBody
		bodyDef.position.Set(options.x, options.y)
		@body = world.physics.CreateBody(bodyDef)

		fixDef = new FixtureDef
		fixDef.density = 1
		fixDef.friction = 0.5
		fixDef.restitution = 0.2
		fixDef.shape = new PolygonShape
		fixDef.shape.SetAsBox(0.95, 0.95)
		# vert.y -= 0.255 for vert in fixDef.shape.GetVertices()
		@body.CreateFixture(fixDef)
		@body.SetUserData(this)

	outOfBounds: ->
		p = @body.GetPosition()
		p.x < -1 or p.x > TILE_WIDTH+1 or p.y > TILE_HEIGHT+2


	draw: ->
		frame = Math.floor(seconds() * 7.5) % 6
		w = images.cupcake.width
		h = images.cupcake.height / 6
		p = @body.GetPosition()
		x = 32 * (p.x - 1)
		y = 32 * (p.y - 1) + 4
		g.drawImage(images.cupcake, 0, frame * h, w, h, x, y, w, h)

	tick: ->

