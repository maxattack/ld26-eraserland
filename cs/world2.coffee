

createBox = (x,y,w,h) ->
	result = new PolygonShape
	result.SetAsBox(0.5*MPP*w, 0.5*MPP*h)
	dx = MPP*x - (-0.5*MPP*w)
	dy = MPP*y - (-0.5*MPP*h)
	for vert in result.GetVertices()
		vert.x += dx; vert.y += dy
	result

class CatSprite
	constructor: (i, options) ->
		# @options = options
		i += 1
		@image = if i >= 10 then images['cat'+i] else images['cat0'+i]
		bodyDef = new BodyDef
		bodyDef.type = Body.b2_dynamicBody
		# if options.y < 1 || options.y > 16
		# 	bodyDef.position.Set(11+randRange(-1.5,2.5), randRange(2,4))
		# else
		bodyDef.position.Set(options.x, options.y)
		bodyDef.angle = options.a

		@body = world.physics.CreateBody(bodyDef)

		fixDef = new FixtureDef
		fixDef.density = 2
		fixDef.friction = 0.4
		fixDef.restitution = 0.9
		
		for shape in options.shapes
			if 'r' of shape
				# add a circle
				fixDef.shape = new CircleShape MPP*shape.r
				fixDef.shape.SetLocalPosition(Vec2.Make(MPP*shape.x, MPP*shape.y))
				@body.CreateFixture(fixDef)

			else
				# add a rect		
				fixDef.shape = createBox(shape.x, shape.y, shape.w, shape.h)
				@body.CreateFixture(fixDef)

		@body.SetUserData(this)
		@next = null; @prev = null
		@isAlive = yes
		@alpha = 1

	# logTelem: -> 
	# 	p = @body.GetPosition()
	# 	@options.x = p.x
	# 	@options.y = p.y
	# 	@options.a = @body.GetAngle()
	# 	"#{JSON.stringify(@options)}<br>"

	destroy: ->
		@next = null
		@prev = null
		world.physics.DestroyBody(@body)
		@isAlive = no

	outOfBounds: ->	@body.GetPosition().y > TILE_HEIGHT+5

	draw: ->
		p = @body.GetPosition()
		g.save()
		g.translate(32*p.x, 32*p.y)
		g.rotate(@body.GetAngle())
		g.drawImage(@image, 0, 0)
		g.restore()

	drawFadeOut: ->
		p = @body.GetPosition()
		@alpha *= 0.75
		g.save()
		g.globalAlpha = @alpha
		g.translate(32*p.x, 32*p.y)
		g.rotate(@body.GetAngle())
		g.drawImage(@image, 0, 0)
		g.restore()
		@alpha < 0.02


class World2 extends World
	constructor: ->
		super secondLevel
		@firstCat = null
		@fadingCats = null
		for i in [secondLevel.cats.length-1..0]
			cat = new CatSprite(i,secondLevel.cats[i])
			cat.next = @firstCat
			@firstCat?.prev = cat
			@firstCat = cat

		# doc.on 'keydown.world2', (e) =>
		# 	return true unless e.which == 84
		# 	c = @firstCat
		# 	msg = '<ul>'
		# 	while c?
		# 		msg += c.logTelem()
		# 		c = c.next
		# 	msg += '</ul>'
		# 	$('#feedback').html msg
		# 	true

	destroyCat: (cat) ->
		return unless cat.isAlive

		cat.next?.prev = cat.prev
		cat.prev?.next = cat.next
		@firstCat = cat.next if cat == @firstCat
		cat.destroy()

		cat.next = @fadingCats
		@fadingCats?.prev = cat
		@fadingCats = cat

	onTick: ->
		#erase cats?
		if mouseDown
			selectFixture = (fixture) =>
				if fixture.GetBody().GetUserData()?.constructor == CatSprite
					@destroyCat(fixture.GetBody().GetUserData())
				false
			@physics.QueryPoint(selectFixture, @physicsMouse())
		

		# check for win or lose?
		if @firstCat?
			cat = @firstCat
			while cat?
				if cat.outOfBounds()
					@status = STATUS_LOSE
					break
				cat = cat.next
		else
			@status = STATUS_WIN unless @fadingCats?

	onDraw: ->
		c = @firstCat
		while c?
			c.draw()
			c = c.next
		c = @fadingCats
		while c?
			next = c.next
			if c.drawFadeOut()
				c.next?.prev = c.prev
				c.prev?.next = c.next
				if c == @fadingCats
					@fadingCats = c.next 
					
				else
			c = next



	onDestroy: ->	
		# doc.off 'keydown.world2'

