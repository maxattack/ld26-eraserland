MPP = 1.0/PIXELS_PER_METER

class CatSprite
	constructor: (i, shapes) ->
		i += 1
		@image = if i >= 10 then images['cat'+i] else images['cat0'+i]
		bodyDef = new BodyDef
		bodyDef.type = Body.b2_dynamicBody
		bodyDef.position.Set(randRange(1,TILE_WIDTH-1), randRange(2,TILE_HEIGHT-4))
		bodyDef.linearVelocity.Set(randRange(-0.5, 0.5), randRange(-10, -20))

		@body = world.physics.CreateBody(bodyDef)

		fixDef = new FixtureDef
		fixDef.density = 1
		fixDef.friction = 0.5
		fixDef.restitution = 0.2
		
		for shape in shapes
			if 'r' of shape
				# add a circle
				fixDef.shape = new CircleShape MPP*shape.r
				fixDef.shape.SetLocalPosition(Vec2.Make(MPP*shape.x, MPP*shape.y))
				@body.CreateFixture(fixDef)

			else
				# add a rect		
				fixDef.shape = new PolygonShape
				fixDef.shape.SetAsBox(0.5*MPP*shape.w, 0.5*MPP*shape.h)

				dx = MPP*shape.x - (-0.5*MPP*shape.w)
				dy = MPP*shape.y - (-0.5*MPP*shape.h)
				for vert in fixDef.shape.GetVertices()
					vert.x += dx
					vert.y += dy
				@body.CreateFixture(fixDef)

		console.log @image

	draw: ->
		p = @body.GetPosition()
		g.save()
		g.translate(32*p.x, 32*p.y)
		g.rotate(@body.GetAngle())
		g.drawImage(@image, 0, 0)
		g.restore()




class World2 extends World
	constructor: ->
		super secondLevel
		@cats = ( new CatSprite(i,shapes) for shapes,i in secondLevel.cats )

	onTick: ->


	onDraw: ->
		cat.draw() for cat in @cats

