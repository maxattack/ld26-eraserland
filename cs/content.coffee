
startScreen =
	tilemap: images.startScreenBaked
	solidTiles: [
		tileId(11, 8), tileId(12, 8), tileId(13, 8), tileId(14, 8)
		tileId(11, 9), tileId(12, 9), tileId(13, 9), tileId(14, 9)
		tileId(11,10), tileId(12,10), tileId(13,10), tileId(14,10)
		tileId(11,11), tileId(12,11), tileId(13,11), tileId(14,11)
	]


testLevel = do ->
	options = 
		tilemap: images.testBaked
		solidTiles: (tileId(i,14) for i in [0..TILE_WIDTH-1])
		distractionTiles: (tileId(i, 15) for i in [0..TILE_WIDTH-1])
		hero:
			x: 1
			y: 8
			walkingSpeed: 4
		cupcake:
			x: 20
			y: 9
	options.solidTiles.push(
		tileId(12, 10),
		tileId(12, 11),
		tileId(12, 12),
		tileId(12, 13),
		tileId(13, 10)
		tileId(13, 11),
	)
	options

