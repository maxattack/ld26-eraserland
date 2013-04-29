cloudBits = null
DROP_SPAWNRATE = 0.05
DROP_HEADING = Vec2.Make(2,4)

createPolygon = (options) ->
	result = new PolygonShape
	v = options.v
	verts = (Vec2.Make(MPP*v[i+i], MPP*v[i+i+1]) for i in [0..(v.length/2)-1])
	result.SetAsArray(verts);
	result

drawBodyImage = (body, img) ->
	p = body.GetPosition()
	g.save()
	g.translate(PIXELS_PER_METER*p.x, PIXELS_PER_METER*p.y)
	g.rotate(body.GetAngle())
	g.drawImage(img, 0, 0)
	g.restore()


class CloudSprite
	constructor: (options) ->
		{ @speed } = options
		bodyDef = new BodyDef
		bodyDef.type = Body.b2_kinematicBody
		bodyDef.position.Set(options.x, options.y)
		bodyDef.userData = this
		@body = world.physics.CreateBody(bodyDef)

		fixDef = new FixtureDef
		# fixDef.density = 1
		# fixDef.friction = 0.5
		# fixDef.restitution = 0.5
		fixDef.isSensor = yes

		@mask = 0
		
		@fixtureCount = thirdLevel.cloudShapes.length

		for shape,i in thirdLevel.cloudShapes
			# add a circle
			fixDef.shape = new CircleShape MPP*shape.r
			fixDef.shape.SetLocalPosition(Vec2.Make(MPP*shape.x, MPP*shape.y))
			fixDef.userData = i
			fixture = @body.CreateFixture(fixDef)
			@mask |= (1<<i)

		@timeout = expovariate(DROP_SPAWNRATE)

	hasBit: (i) -> (@mask & (1<<i)) != 0
	hasAnyBits: -> @mask != 0
	clearBit: (i) -> @mask = @mask & (~(1<<i))

	eraseFixture: (fixture) ->
		return unless @hasBit(fixture.GetUserData())
		@body.DestroyFixture(fixture)
		@clearBit(fixture.GetUserData())
		@fixtureCount--
		world.destroyCloud(this) unless @hasAnyBits()


	tick: ->
		p = @body.GetPosition()
		p.x += @speed * deltaSeconds()
		p.x = -5 if p.x > TILE_WIDTH+0.5
		@body.SetPosition(p)

		@timeout -= deltaSeconds()
		if @timeout < 0
			@timeout = expovariate(DROP_SPAWNRATE)
			randomFixtureIndex = Math.floor(randRange(0,@fixtureCount))
			fl = @body.GetFixtureList()
			fl = fl.GetNext() for i in [1..randomFixtureIndex] when fl.GetNext()?
			p = @body.GetPosition()
			c = fl.GetShape().GetLocalPosition()
			x = p.x + c.x
			y = p.y + c.y
			world.getFreeDrop()?.spawn(x, y) if x > 0.25 && x < TILE_WIDTH-0.25

	draw: ->
		p = @body.GetPosition()
		for bit,i in cloudBits when @hasBit(i)
			g.drawImage(bit, PIXELS_PER_METER*p.x, PIXELS_PER_METER*p.y)

class DropSprite
	constructor: (type) ->
		@image = images["drop0#{type+1}"]

		bodyDef = new BodyDef
		bodyDef.type = Body.b2_dynamicBody
		bodyDef.position.Set(-10, -10)
		bodyDef.active = no
		bodyDef.userData = this
		@body = world.physics.CreateBody(bodyDef)

		fixDef = new FixtureDef
		fixDef.density = 1
		fixDef.friction = 0.5
		fixDef.restitution = 0.5
		fixDef.shape = createPolygon(thirdLevel.dropShapes[type])
		@body.CreateFixture(fixDef)
		@timeout = -1

		@next = null

	spawn: (x,y) ->
		@body.SetPosition(Vec2.Make(x,y))
		@body.SetAngle(0);
		@body.SetAngularVelocity(0);
		@body.SetLinearVelocity(DROP_HEADING);
		@body.SetActive(yes)
		@timeout = 1500

	tick: ->
		return unless @body.IsActive()
		@timeout -= dt
		if @timeout < 0
			@body.SetActive(no)
			@body.SetPosition(-10, -10)
			world.repool(this)
		else
			if @body.GetPosition().y > TILE_HEIGHT+5
				world.incFlower(@body.GetPosition().x)
				@body.SetActive(no)
				@body.SetPosition(-10, -10)
				world.repool(this)


	draw: ->
		return unless @body.IsActive()
		drawBodyImage(@body, @image)

class FlowerSprite
	constructor: (i) ->
		@image = images["flower#{i+1}"]
		@count = 0
		@y = 0
		@x = (1 + 2*i) * canvas.width / 6.0 - 16
		if i == 1
			@x += 32

	onDrop: -> @count++ if @count < 20
	visible: -> @y > 0.99 * (@image.height)

	draw: ->
		return if @count < 20
		# spring physics
		@y += 0.2 * (@image.height - @y)
		g.drawImage(@image, @x - 0.5 * @image.width, canvas.height-@y-world.offsetY)
		



class World3 extends World
	constructor: ->
		super thirdLevel

		unless cloudBits?
			cloudBits = [
				images.cloudy01
				images.cloudy02
				images.cloudy03
				images.cloudy04
				images.cloudy05
				images.cloudy06
				images.cloudy07
				images.cloudy08
				images.cloudy09
				images.cloudy10
			]

		@clouds = (new CloudSprite(cloud) for cloud in thirdLevel.clouds)
		@drops = (new DropSprite(i%thirdLevel.dropShapes.length) for i in [1..128])
		@flowers = (new FlowerSprite(i) for i in [0..2])
		@timeout = 1500

		# create the drop freepool
		@nextFreeDrop = @drops[0]
		for i in [0..@drops.length-2]
			@drops[i].next = @drops[i+1]

	getFreeDrop: ->
		return null unless @nextFreeDrop?
		result = @nextFreeDrop
		@nextFreeDrop = result.next
		result.next = null
		return result

	repool: (drop) ->
		drop.next = @nextFreeDrop
		@nextFreeDrop = drop

	incFlower: (x) ->
		switch
			when x < TILE_WIDTH/3.0 then @flowers[0].onDrop()
			when x > 2*TILE_WIDTH/3.0 then @flowers[2].onDrop()
			else @flowers[1].onDrop()

	destroyCloud: (cloud) ->
		i = @clouds.indexOf(cloud)
		@clouds.splice(i, 1)

	onTick: ->

		if mouseDown
			selectFixture = (fixture) =>
				target = fixture.GetBody().GetUserData()
				if target?.constructor == CloudSprite
					target.eraseFixture(fixture)
				false
			@physics.QueryPoint(selectFixture, @physicsMouse())

		if @clouds.length > 0
			cloud.tick() for cloud in @clouds
			drop.tick() for drop in @drops
		else
			@status = STATUS_LOSE

		if @flowers[0].visible() && @flowers[1].visible() && @flowers[2].visible()
			@timeout -= dt
			@status = STATUS_WIN if @timeout < 0
				

	onDraw: ->
		cloud.draw() for cloud in @clouds
		drop.draw() for drop in @drops
		flower.draw() for flower in @flowers

	onDestroy: ->	

