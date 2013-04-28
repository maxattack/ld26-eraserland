

class World1 extends World
	constructor: ->
		super firstLevel

		@hero = new HeroSprite(options.hero)
		@cupcake = new CupcakeSprite(options.cupcake)

		listener = new ContactListener
		# listener.EndContact = (contact)=>
		# listener.PreSolve = (contact, oldManifold)=>
		# listener.PostSolve = (contact, impulse)=>
		listener.BeginContact = (contact)=>
			if contact.GetFixtureA().GetBody().GetUserData() == @hero
				if contact.GetFixtureB().GetBody().GetUserData() == @cupcake
					@status = STATUS_WIN
			else if contact.GetFixtureB().GetBody().GetUserData() == @hero
				if contact.GetFixtureA().GetBody().GetUserData() == @cupcake
					@status = STATUS_WIN
		@physics.SetContactListener(listener)

	onTick: ->
		@cupcake.tick()
		@hero.tick()
		if @cupcake.outOfBounds() or @hero.outOfBounds()
			@status = STATUS_LOSE


	onDraw: ->
		@cupcake.draw()
		@hero.draw()


