
`
// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
// http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating 
// requestAnimationFrame polyfill by Erik Möller
// fixes from Paul Irish and Tino Zijdel
 (function() {
	var lastTime = 0;
	var vendors = ['ms', 'moz', 'webkit', 'o'];
	for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
		window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
		window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame']
								   || window[vendors[x]+'CancelRequestAnimationFrame'];
	}
	if (!window.requestAnimationFrame) {
		window.requestAnimationFrame = function(callback, element) {
			var currTime = new Date().getTime();
			var timeToCall = Math.max(0, 16 - (currTime - lastTime));
			var id = window.setTimeout(function() { callback(currTime + timeToCall); },
			  timeToCall);
			lastTime = currTime + timeToCall;
			return id;
		};
	}
	if (!window.cancelAnimationFrame) {
		window.cancelAnimationFrame = function(id) {
			clearTimeout(id);
		};
	}
}());
`

class ImageGroup
	constructor: (paths) ->
		stripName = (path) -> 
			result = path.replace(/^.*[\\\/]/, '').split('.')[0]
			unless result.indexOf("_") == -1
				tokens = result.split('_')
				result = tokens[0]
				for i in [1..tokens.length-1]
					s = tokens[i]
					result = result + s[0].toUpperCase() + s.substring(1, s.length)
			return result

		@numLoading = paths.length
		@numFailed = 0
		for path in paths 
			do(path) =>
				img = new Image()
				img.onload = () =>
					@numLoading--
				img.onerror = \
				img.onabort = () =>
					@numLoading--
					@numFailed++
				img.src = path
				this[stripName(path)] = img

	loading: -> @numLoading > 0
	complete: -> @numLoading == 0 and @numFailed == 0
	failed: -> @numFailed > 0

randRange = (x,y) -> x + Math.random() * (y - x)

# convenience names
b2World = Box2D.Dynamics.b2World
Vec2 = Box2D.Common.Math.b2Vec2
BodyDef = Box2D.Dynamics.b2BodyDef
Body = Box2D.Dynamics.b2Body
FixtureDef = Box2D.Dynamics.b2FixtureDef
Fixture = Box2D.Dynamics.b2Fixture
MassData = Box2D.Collision.Shapes.b2MassData
PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
CircleShape = Box2D.Collision.Shapes.b2CircleShape
DebugDraw = Box2D.Dynamics.b2DebugDraw
