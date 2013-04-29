loadingImages = new ImageGroup [
	'images/donut_erase_01.png'
	'images/donut_erase_02.png'
	'images/donut_erase_03.png'
	'images/donut_erase_04.png'
	'images/donut_erase_05.png'
	'images/donut_erase_06.png'
	'images/donut_erase_07.png'
	'images/donut_erase_08.png'
	'images/donut_erase_09.png'
	'images/loadingText.png'
]

images = new ImageGroup [
	'images/pencil.png'
	'images/background.jpg'
	'images/winScreen.png'
	'images/loseScreen.png'
	'images/winwinwin.png'

	'images/startScreen_baked.png'

	'images/first_baked.png'
	'images/lose1.png'
	'images/walk.png'
	'images/cupcake.png'

	'images/second_baked.png'
	'images/lose2.png'
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

	'images/third_baked.png'
	'images/lose3.png'
	'images/cloudy_01.png'
	'images/cloudy_02.png'
	'images/cloudy_03.png'
	'images/cloudy_04.png'
	'images/cloudy_05.png'
	'images/cloudy_06.png'
	'images/cloudy_07.png'
	'images/cloudy_08.png'
	'images/cloudy_09.png'
	'images/cloudy_10.png'
	'images/drop_01.png'
	'images/drop_02.png'
	'images/drop_03.png'
	'images/flower1.png'
	'images/flower2.png'
	'images/flower3.png'

	'images/lose4.png'
	'images/spaceDebris_01.png'
	'images/spaceDebris_02.png'
	'images/spaceDebris_03.png'
	'images/spaceDebris_04.png'
	'images/spaceDebris_05.png'
	'images/spaceDebris_06.png'
	'images/spaceDebris_07.png'
	'images/spaceDebris_08.png'
	'images/spaceDebris_09.png'
	'images/spaceDebris_10.png'
	'images/spaceDebris_11.png'
	'images/spaceDebris_12.png'
	'images/spaceDebris_13.png'
	'images/spaceDebris_14.png'
	'images/spaceDebris_15.png'
	'images/spaceDebris_16.png'
	'images/spaceDebris_17.png'

	# 'images/scratch0_baked.png'
	# 'images/scratch1_baked.png'
	# 'images/scratch2_baked.png'

	# 'images/lose5.png'
	'images/balloony_01.png'
	'images/balloony_02.png'
	'images/balloony_03.png'
	'images/balloony_04.png'
	'images/balloony_05.png'
	'images/balloony_06.png'
	'images/balloony_07.png'
	'images/balloony_08.png'
	'images/raccoony_01.png'
	'images/raccoony_02.png'
	'images/raccoony_03.png'
	'images/raccoony_04.png'
	'images/raccoony_05.png'

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
	gravity: GRAVITY
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
	gravity: GRAVITY
	tilemap: images.secondBaked
	solidTiles: [
		241, 242, 243
		268, 269
		294,295,296,297,298,299,300,301,302
		320,321,322,323,324,325,326,327,328
		350,351,352
	]
	distractionTiles: [
		267, 270,271,275,276,272,273,274
		348,349,353,354
	]
	cats: [
		# warmed up simulation
		{"x":12.323300015471101,"y":3.8465967395415808,"a":-11.931000187779881,"shapes":[{"r":18,"x":30,"y":28},{"x":12,"y":32,"w":58,"h":32}]}
		{"x":19.699587234467785,"y":10.29897078983545,"a":2.8718130925751546,"shapes":[{"r":37,"x":90,"y":40},{"x":49,"y":59,"r":20}]}
		{"x":10.778058106993631,"y":5.047338544468242,"a":13.201050215975728,"shapes":[{"x":26,"y":4,"w":41,"h":91}]}
		{"x":11.671088046543748,"y":4.065897481563266,"a":7.991763801087106,"shapes":[{"x":43,"y":34,"r":31}]}
		{"x":14.766186723188492,"y":9.837711336068626,"a":10.479634211607914,"shapes":[{"x":7,"y":1,"w":51,"h":154}]}
		{"x":10.162379425122746,"y":6.792643432858858,"a":8.002978031479138,"shapes":[{"x":50,"y":46,"r":28},{"x":54,"y":98,"r":32}]}
		{"x":12.809443487308453,"y":1.4977038048259605,"a":-19.37257229460358,"shapes":[{"x":4,"y":7,"w":88,"h":49}]}
		{"x":8.007106549579278,"y":6.319051912201984,"a":43.473866249947534,"shapes":[{"x":35,"y":36,"r":26}]}
		{"x":10.505405101055622,"y":5.0551576253364034,"a":22.49650269720527,"shapes":[{"x":53,"y":49,"r":44}]}
		{"x":9.767136712039559,"y":7.603619634335876,"a":12.682970770830673,"shapes":[{"x":53,"y":71,"r":32},{"x":29,"y":46,"r":16}]}
		{"x":12.397408589095967,"y":5.786530086979555,"a":56.032734074510145,"shapes":[{"x":21,"y":32,"w":89,"h":60}]}
		{"x":8.190003793641523,"y":4.934742043413446,"a":-43.084996381290374,"shapes":[{"x":7,"y":26,"w":51,"h":36},{"x":27,"y":23,"r":17}]}
		{"x":10.533059920401506,"y":4.5769408248149395,"a":-32.63040934184026,"shapes":[{"x":55,"y":32,"r":30},{"x":24,"y":27,"r":18},{"x":17,"y":44,"r":7}]}
		{"x":16.9958769343146,"y":2.274543821191903,"a":1.0548678191798502,"shapes":[{"x":14,"y":38,"w":43,"h":113},{"x":34,"y":40,"w":13,"h":33},{"x":57,"y":45,"r":17}]}
		{"x":7.939480181609701,"y":3.4160739750603977,"a":163.80547124435023,"shapes":[{"x":4,"y":12,"w":58,"h":44},{"x":13,"y":4,"w":42,"h":11}]}
		{"x":13.405907708351902,"y":5.481645139773989,"a":-46.02980863577727,"shapes":[{"x":45,"y":35,"r":25},{"x":45,"y":86,"r":23}]}
		{"x":12.527323535720809,"y":5.8941459554959135,"a":44.616495518946024,"shapes":[{"x":53,"y":33,"r":27},{"x":6,"y":35,"w":34,"h":60}]}
		{"x":10.982598330564482,"y":8.651135676741642,"a":18.29152329547216,"shapes":[{"x":36,"y":39,"r":22},{"x":34,"y":78,"r":27}]}
	]

thirdLevel = 
	gravity: GRAVITY
	tilemap: images.thirdBaked
	solidTiles: [390..415]
	distractionTiles: [364..389]
	cloudShapes: [
		{x:52,y:35,r:26}          
		{x:80,y:25,r:21}          
		{x:107,y:27,r:24}          
		{x:126,y:34,r:25}          
		{x:137,y:53,r:19}          
		{x:120,y:70,r:27}          
		{x:102,y:73,r:27}          
		{x:74,y:79,r:24}          
		{x:55,y:66,r:28}          
		{x:34,y:60,r:22}          
	]
	dropShapes: [
		{v:[8,0,15,20,17,32,8,37,2,32,2,17]}
		{v:[9,1,17,18,17,26,8,29,2,24,2,17]}
		{v:[11,0,15,20,7,27,2,22,2,13]}
	]
	clouds: [
		{x:8, y:0.5, speed:2.5}
		{x:1, y:4, speed:8}
		{x:20, y:2.5, speed:1}
	]

fourthLevel = 
	makeFloor: yes
	gravity: Vec2.Make(0,0)
	debrisShapes: [
		{x:88,y:84,r:68} #alien
		{x:33,y:49,r:31} #atoms
		{x:53,y:51,r:48} #blackhole   
		{x:32,y:32,r:31} #craters 
		{x:51,y:51,r:48} #deathstar
		{x:45,y:45,r:60} #earth
		{x:53,y:92,r:60} #machinedude
		{x:16,y:16,r:16} #moon
		{x:43,y:78,r:42} #robot
		{x:44,y:37,r:32} #rocket
		{x:58,y:46,r:37} #sattelite
		{x:63,y:51,r:43} #saturn
		{x:37,y:35,r:28} #star1
		{x:46,y:49,r:30} #star2
		{x:54,y:60,r:46} #spaceman
		{x:76,y:69,r:60} #sun
		{x:32,y:21,r:20} #ufo
	]

# fifthLevel = 
# 	tilemaps: [
# 		images.scratch0Baked
# 		images.scratch1Baked
# 		images.scratch2Baked
# 	]

sixthLevel = 
	gravity: Vec2.Make(0,-10)
	balloonShapes: [
		{v:[65,4, 116,12, 150,46, 145,93, 80,90]}
		{v:[148,91, 128,134, 83,159, 83,85]} # {v:[148,91, 128,134, 83,159]}
		{v:[89,165,25, 126, 3, 80, 81, 78]}
		{v:[78,11,88,106,12,115,10,70,44,15]}
		{x:61,y:166,w:32,h:50}
		{x:65,y:208,w:32,h:50}
		{x:68,y:246,w:32,h:50}
		{x:70,y:298,w:32,h:50}
	]
	raccoonShapes: [
		{x:32,y:43,r:32}   
		{x:105,y:58,r:32} 
		{x:65,y:93,r:55} 		  
		{x:80,y:158,r:37} 
		{v:[19,117,51,115,47,187,22,166]}
	]


