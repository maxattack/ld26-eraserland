balloonBits = null
raccoonBits = null

class BalloonSprite
	constructor: ->
		bodyDef = new BodyDef
		bodyDef.type = Body.b2_dynamicBody
		bodyDef.position.Set(450/32, 120/32)
		bodyDef.userData = this
		# bodyDef.angularVelocity = randRange(-5, 5)
		bodyDef.angularDamping = 10
		@body = world.physics.CreateBody(bodyDef)

		fixDef = new FixtureDef
		# fixDef.density = 1
		# fixDef.friction = 0.5
		# fixDef.restitution = 0.5
		fixDef.isSensor = yes

		@mask = 0
		@fixtureCount = sixthLevel.balloonShapes.length
		for shape,i in sixthLevel.balloonShapes
			if 'v' of shape
				fixDef.shape = createPolygon shape
			else if 'r' of shape
				# add a circle
				fixDef.shape = new CircleShape MPP*shape.r
				fixDef.shape.SetLocalPosition(Vec2.Make(MPP*shape.x, MPP*shape.y))
			else if 'w' of shape
				fixDef.shape = createBox(shape.x, shape.y, shape.w, shape.h)
			fixDef.userData = i
			fixture = @body.CreateFixture(fixDef)
			@mask |= (1<<i)


	hasBit: (i) -> (@mask & (1<<i)) != 0
	hasAnyBits: -> @mask != 0
	clearBit: (i) -> @mask = @mask & (~(1<<i))

	hasRubberBits: -> @hasBit(0) && @hasBit(1) && @hasBit(2) && @hasBit(3)

	eraseFixture: (fixture) ->
		i = fixture.GetUserData()
		return unless @hasBit(i) && i<4
		@body.DestroyFixture(fixture)
		@clearBit(i)
		@fixtureCount--
		world.destroyBalloon(this) unless @hasAnyBits()

	tick: ->
		# p = @body.GetPosition()
		# @force.Set(@targ.x - p.x, @targ.y - p.y)
		# @force.x *= 0.0001
		# @force.y *= 0.0001
		# @body.ApplyForce(@force, p)
		@body.SetAngle(0.1 * Math.sin(10 * seconds()))

	draw: ->
		p = @body.GetPosition()
		for bit,i in balloonBits when @hasBit(i)
			drawBodyImage(@body, bit)

class RaccoonSprite
	constructor: ->
		bodyDef = new BodyDef
		bodyDef.type = Body.b2_kinematicBody
		bodyDef.position.Set(450/32, 320/32)
		bodyDef.userData = this
		@body = world.physics.CreateBody(bodyDef)

		fixDef = new FixtureDef
		# fixDef.density = 1
		# fixDef.friction = 0.5
		# fixDef.restitution = 0.5
		fixDef.isSensor = yes

		@mask = 0
		@fixtureCount = sixthLevel.raccoonShapes.length
		for shape,i in sixthLevel.raccoonShapes
			if 'v' of shape
				fixDef.shape = createPolygon shape
			else if 'r' of shape
				# add a circle
				fixDef.shape = new CircleShape MPP*shape.r
				fixDef.shape.SetLocalPosition(Vec2.Make(MPP*shape.x, MPP*shape.y))
			else if 'w' of shape
				fixDef.shape = createBox(shape.x, shape.y, shape.w, shape.h)
			fixDef.userData = i
			fixture = @body.CreateFixture(fixDef)
			@mask |= (1<<i)

	hasBit: (i) -> (@mask & (1<<i)) != 0
	hasAnyBits: -> @mask != 0
	clearBit: (i) -> @mask = @mask & (~(1<<i))

	eraseFixture: (fixture) ->
		return unless @hasBit(fixture.GetUserData())
		@body.DestroyFixture(fixture)
		@clearBit(fixture.GetUserData())
		@fixtureCount--
		world.destroyRaccoon(this) unless @hasAnyBits()

	tick: ->

	draw: ->
		p = @body.GetPosition()
		for bit,i in raccoonBits when @hasBit(i)
			drawBodyImage(@body, bit)	




class World6 extends World
	constructor: ->
		super sixthLevel
		unless balloonBits?
			balloonBits = [
				images.balloony01
				images.balloony02
				images.balloony03
				images.balloony04
				images.balloony05
				images.balloony06
				images.balloony07
				images.balloony08
			]
			raccoonBits = [
				images.raccoony01
				images.raccoony02
				images.raccoony03
				images.raccoony04
				images.raccoony05
			]
		@balloon = new BalloonSprite
		@raccoon = new RaccoonSprite

		anchor = new RevoluteJointDef
		anchor.Initialize(@balloon.body, @raccoon.body, Vec2.Make(16.78125, 14.5625))
		@joint = @physics.CreateJoint anchor
		mouseDef = new MouseJointDef
		p = @balloon.body.GetPosition()
		# mouseDef.target = Vec2.Make(p.x, p.y - 10)
		# mouseDef.dampingRatio = 0.1
		# mouseDef.frequencyHz = 1
		# mouseDef.maxForce = 10
		# @mouse = @physics.CreateJoint mouseDef

	destroyRaccoon: (raccoon) ->
		@physics.DestroyJoint(@joint)
		@raccoon = null if raccoon == @raccoon

	destroyBalloon: (balloon) ->
		@balloon = null if balloon == @balloon

	onTick: ->
		@balloon?.tick()
		if mouseDown
			selectFixture = (fixture) =>
				target = fixture.GetBody().GetUserData()
				target.eraseFixture?(fixture)
				false
			@physics.QueryPoint(selectFixture, @physicsMouse())
			console.log @balloon.body.GetPosition().y
		@status = STATUS_LOSE unless @balloon?.hasRubberBits()
		@status = STATUS_WIN if @balloon.body.GetPosition().y < -20

	onDraw: ->
		@balloon?.draw()
		@raccoon?.draw()

	onDestroy: ->