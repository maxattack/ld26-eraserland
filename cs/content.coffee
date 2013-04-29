images = new ImageGroup [
	'images/pencil.png'
	'images/background.jpg'
	'images/winScreen.png'
	'images/loseScreen.png'

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


