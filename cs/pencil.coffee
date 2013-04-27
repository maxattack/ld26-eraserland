
class Pencil
	constructor: ->
		@rubTime = 0

	draw: ->
		g.save()
		dx = mouseX - (canvas.width>>1)
		dy = mouseY - (0.666 * canvas.height)
		angle = Math.atan2(dy, dx)
		g.translate mouseX, mouseY
		g.rotate angle+Math.PI

		unless mouseDown
			g.drawImage images.pencil, -images.pencil.width, -10
		else
			if mousePressed then @rubTime = 0 else @rubTime += deltaSeconds()
			u = 0.5 * Math.sin(TAU * 5 * @rubTime)
			g.drawImage images.pencil, u*20-images.pencil.width, -u*4-10
		g.restore()


