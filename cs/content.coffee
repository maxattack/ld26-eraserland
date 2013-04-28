images = new ImageGroup [
	'images/pencil.png'
	'images/background.jpg'
	'images/walk.png'
	'images/cupcake.png'
	'images/first_baked.png'
	'images/startScreen_baked.png'
	'images/loseScreen.png'
	'images/winScreen.png'
	'images/heart1.png'
	'images/second_baked.png'
	"images/cat_01.png"
	"images/cat_02.png"
	"images/cat_03.png"
	"images/cat_04.png"
	"images/cat_05.png"
	"images/cat_06.png"
	"images/cat_07.png"
	"images/cat_08.png"
	"images/cat_09.png"
	"images/cat_10.png"
	"images/cat_11.png"
	"images/cat_12.png"
	"images/cat_13.png"
	"images/cat_14.png"
	"images/cat_15.png"
	"images/cat_16.png"
	"images/cat_17.png"
	"images/cat_18.png"
]

startScreen =
	tilemap: images.startScreenBaked
	solidTiles: [
		tileId(11, 8), tileId(12, 8), tileId(13, 8), tileId(14, 8)
		tileId(11, 9), tileId(12, 9), tileId(13, 9), tileId(14, 9)
		tileId(11,10), tileId(12,10), tileId(13,10), tileId(14,10)
		tileId(11,11), tileId(12,11), tileId(13,11), tileId(14,11)
	]


firstLevel = do ->
	options = 
		tilemap: images.firstBaked
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

secondLevel = 
	tilemap: images.secondBaked
	solidTiles: (tileId(i,15) for i in [0..TILE_WIDTH-1])
	distractionTiles: (tileId(i,14) for i in [0..TILE_WIDTH-1])
	cats: [
		[ {r:18, x:30, y:28}, {x:12, y:32, w:58, h:32} ]
		[ {r:37, x:90, y:40}, {x:49, y:59, r:20} ]
		[ {x:26, y:4, w:41, h:91 } ]
		[ {x:43, y:34, r:31} ]
		[ {x:7, y:1, w:51, h:154} ]
		[ {x:50, y:46, r:28}, { x:54, y:98, r:32 } ]
		[ {x:4, y:7, w:88, h:49} ]
		[ {x:35, y:36, r:26} ]
		[ {x:53, y:49, r:44} ]
		[ {x:53, y:71, r:32}, {x:29, y:46, r:16} ]
		[ {x:21, y:32, w:89, h:60 } ]
		[ {x:7, y:26, w:51, h:36}, {x:27, y:23, r:17} ]
		[ {x:55,y:32,r:30}, {x:24,y:27,r:18}, {x:17,y:44,r:7} ]
		[ {x:14,y:38,w:43,h:113}, {x:34,y:40,w:13,h:33}, {x:57,y:45,r:17} ]
		[ {x:4,y:12,w:58,h:44}, {x:13,y:4,w:42,h:11} ]
		[ {x:45,y:35,r:25}, {x:45,y:86,r:23} ]
		[ {x:53,y:33,r:27}, {x:6,y:35,w:34,h:60} ]
		[ {x:36,y:39,r:22}, {x:34,y:78,r:27} ]
	]
