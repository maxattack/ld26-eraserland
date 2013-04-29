

class DebrisSprite
	constructor: (@idx) ->
		@img = if @idx<10 then images["spaceDebris0#{@idx}"] else images["spaceDebris#{@idx}"]
		shape = fourthLevel.debrisShapes[@idx-1]

		bodyDef = new BodyDef
		bodyDef.type = (if @isSun() then Body.b2_kinematicBody else Body.b2_dynamicBody)
		if @isSun()
			bodyDef.position.x = 0.5 * TILE_WIDTH - shape.x * MPP
			bodyDef.position.y = 0.5 * TILE_HEIGHT - shape.y * MPP
		else
			bodyDef.position.Set(randRange(2, TILE_WIDTH-2), randRange(2, TILE_HEIGHT-2))
			dx = bodyDef.position.x - 0.5 * TILE_WIDTH
			dy = bodyDef.position.y - 0.5 * TILE_HEIGHT
			k = randRange(5,50)/Math.sqrt(dx*dx + dy*dy)
			dx *= k
			dy *= k
			bodyDef.linearVelocity.Set(-dy, dx)
			bodyDef.angularVelocity = randRange(-1,1)
		# bodyDef.linearDamping = 0.1
		bodyDef.angularDamping = 50
		bodyDef.userData = this
		@body = world.physics.CreateBody(bodyDef)
		
		fixDef = new FixtureDef
		fixDef.density = 1
		fixDef.friction = 0.05
		fixDef.restitution = 0.8 # elastic collisions		
		fixDef.shape = new CircleShape MPP*shape.r
		@center = Vec2.Make(MPP*shape.x, MPP*shape.y)
		fixDef.shape.SetLocalPosition(@center)
		@body.CreateFixture(fixDef)
		@force = Vec2.Make(0,0)
		@loc = Vec2.Make(0,0)
		@next = null
		@prev = null
		@alpha = 1

	isSun: -> @idx == 16

	tick: ->
		return if @isSun()
		p = @body.GetPosition()
		@loc.Set(p.x + @center.x, p.y + @center.y)
		dx = 0.5 * TILE_WIDTH - @loc.x
		dy = 0.5 * TILE_HEIGHT - @loc.y
		rsq = dx*dx + dy*dy
		k = 1.0 / Math.sqrt(rsq)
		mass = @body.GetMass()
		gravity = 50.0 * mass * k
		@force.Set(k * dx * gravity, k * dy * gravity)
		@body.ApplyForce(@force, @loc)


	draw: ->
		drawBodyImage(@body, @img)

	drawFadeOut: ->
		@alpha *= 0.75
		g.globalAlpha = @alpha
		drawBodyImage(@body, @img)
		@alpha > 0.01


class World4 extends World
	constructor: ->
		super fourthLevel
		@debris = (new DebrisSprite(i) for i in [1..17])
		@fadeOutList = null
		@sunDead = no

	destroy: (debris) ->
		@sunDead = yes if debris.isSun()
		i = @debris.indexOf(debris)
		if i >= 0
			@debris.splice(i, 1) if i >= 0
			debris.next = @fadeOutList
			@fadeOutList?.prev = debris
			@fadeOutList = debris

	onTick: ->
		if mouseDown
			selectFixture = (fixture) =>
				target = fixture.GetBody().GetUserData()
				@destroy(target) if target?.constructor == DebrisSprite
				false
			@physics.QueryPoint(selectFixture, @physicsMouse())

		unless @sunDead
			d.tick() for d in @debris

		@status = STATUS_WIN if @debris.length == 1 && @debris[0].isSun() && @fadeOutList == null

	onDraw: ->
		d.draw() for d in @debris
		g.save()
		d = @fadeOutList
		while d?
			next = d.next
			unless d.drawFadeOut()
				d.next?.prev = d.prev
				d.prev?.next = d.next
				@fadeOutList = d.next if d == @fadeOutList
				@status = STATUS_LOSE if d.isSun()
			d = next
		g.restore()

	onDestroy: ->