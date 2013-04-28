
class HeroSprite
	constructor: (options) ->
		{ @walkingSpeed } = options

		bodyDef = new BodyDef
		bodyDef.fixedRotation = yes
		bodyDef.type = Body.b2_dynamicBody
		bodyDef.position.Set(options.x, options.y)
		@body = world.physics.CreateBody(bodyDef)

		# give the hero rounded feet so that he doesn't catch
		# corners in the tiles - age old box2D problem -__-;;
		fixDef = new FixtureDef
		fixDef.density = 1
		fixDef.friction = 0.5
		fixDef.restitution = 0.2
		
		fixDef.shape = new PolygonShape
		fixDef.shape.SetAsBox(0.45, 0.7)
		vert.y -= 0.255 for vert in fixDef.shape.GetVertices()
		@body.CreateFixture(fixDef)

		fixDef.shape = new CircleShape 0.45
		fixDef.shape.SetLocalPosition(new Vec2(0, 0.5))
		@body.CreateFixture(fixDef)

		@body.SetUserData(this)

	outOfBounds: ->
		p = @body.GetPosition()
		p.x < -1 or p.x > TILE_WIDTH+1 or p.y > TILE_HEIGHT+2

	draw: ->
		p = @body.GetPosition()
		x = 32 * (p.x - 0.5) - 6
		y = 32 * (p.y - 1)
		frame = Math.floor(seconds() * 10) % 10
		w = images.walk.width; h = images.walk.height / 10
		if @walkingSpeed < 0
			g.save()
			g.translate(x, y)
			g.translate(w/2, 0)
			g.scale(-1, 1)
			g.drawImage(images.walk, 0, frame * h, w, h, -w/2, 0, w, h+2)
			g.restore()
		else
			g.drawImage(images.walk, 0, frame * h, w, h, x, y, w, h+2)

	tick: ->
		isGrounded = no
		didHitWall = no
		edge = @body.GetContactList()
		while edge?
			if edge.other.GetType() == Body.b2_staticBody
				edge.contact.GetWorldManifold(scratchManifold)
				if scratchManifold.m_normal.y < -0.95
					isGrounded = yes
				else if not didHitWall
					if @walkingSpeed > 0
						didHitWall = yes if scratchManifold.m_normal.x > 0.95
					else 
						didHitWall = yes if scratchManifold.m_normal.x < -0.95
			edge = edge.next
		
		if isGrounded
			@walkingSpeed = -@walkingSpeed  if didHitWall
			vel = @body.GetLinearVelocity()
			vel.x = @walkingSpeed
			@body.SetLinearVelocity(vel)
