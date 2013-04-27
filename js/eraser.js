// Generated by CoffeeScript 1.6.2
(function() {
  
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
;
  var Body, BodyDef, CUPCAKE_STATUS_FALLING, CUPCAKE_STATUS_IDLE, CircleShape, CupcakeSprite, DEBUG_PHYSICS, DebugDraw, Fixture, FixtureDef, GRAVITY, HERO_STATUS_FALLING, HERO_STATUS_WALKING, HeroSprite, ImageGroup, K, MassData, PIXELS_PER_METER, Pencil, PolygonShape, TAU, TILE_HEIGHT, TILE_SIZE, TILE_TYPE_DISTRACTION, TILE_TYPE_EMPTY, TILE_TYPE_SOLID, TILE_WIDTH, Tile, Vec2, WORLD_HEIGHT, WORLD_WIDTH, World, b2World, canvas, clearBackground, deltaSeconds, dt, g, images, mouseDown, mousePressed, mouseReleased, mouseX, mouseY, pencil, pixToTile, queueFrame, randRange, rawMillis, seconds, setMessage, setupTest, time, world;

  ImageGroup = (function() {
    function ImageGroup(paths) {
      var path, stripName, _fn, _i, _len,
        _this = this;

      stripName = function(path) {
        var i, result, s, tokens, _i, _ref;

        result = path.replace(/^.*[\\\/]/, '').split('.')[0];
        if (result.indexOf("_") !== -1) {
          tokens = result.split('_');
          result = tokens[0];
          for (i = _i = 1, _ref = tokens.length - 1; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
            s = tokens[i];
            result = result + s[0].toUpperCase() + s.substring(1, s.length);
          }
        }
        return result;
      };
      this.numLoading = paths.length;
      this.numFailed = 0;
      _fn = function(path) {
        var img;

        img = new Image();
        img.onload = function() {
          return _this.numLoading--;
        };
        img.onerror = img.onabort = function() {
          _this.numLoading--;
          return _this.numFailed++;
        };
        img.src = path;
        return _this[stripName(path)] = img;
      };
      for (_i = 0, _len = paths.length; _i < _len; _i++) {
        path = paths[_i];
        _fn(path);
      }
    }

    ImageGroup.prototype.loading = function() {
      return this.numLoading > 0;
    };

    ImageGroup.prototype.complete = function() {
      return this.numLoading === 0 && this.numFailed === 0;
    };

    ImageGroup.prototype.failed = function() {
      return this.numFailed > 0;
    };

    return ImageGroup;

  })();

  randRange = function(x, y) {
    return x + Math.random() * (y - x);
  };

  b2World = Box2D.Dynamics.b2World;

  Vec2 = Box2D.Common.Math.b2Vec2;

  BodyDef = Box2D.Dynamics.b2BodyDef;

  Body = Box2D.Dynamics.b2Body;

  FixtureDef = Box2D.Dynamics.b2FixtureDef;

  Fixture = Box2D.Dynamics.b2Fixture;

  MassData = Box2D.Collision.Shapes.b2MassData;

  PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  DebugDraw = Box2D.Dynamics.b2DebugDraw;

  TAU = Math.PI + Math.PI;

  setMessage = function(msg) {
    return $('#logger').html(msg);
  };

  canvas = null;

  g = null;

  mouseX = 0;

  mouseY = 0;

  mousePressed = false;

  mouseReleased = false;

  mouseDown = false;

  rawMillis = function() {
    return new Date().getTime();
  };

  dt = 0;

  time = 0;

  seconds = function() {
    return 0.001 * time;
  };

  deltaSeconds = function() {
    return 0.001 * dt;
  };

  images = new ImageGroup(['images/pencil.png', 'images/background.jpg', 'images/walk.png', 'images/cupcake.png', 'images/test_baked.png']);

  pencil = null;

  world = null;

  queueFrame = function(state) {
    dt = rawMillis() - time;
    time = rawMillis();
    dt = Math.min(dt, 33);
    mousePressed = false;
    mouseReleased = false;
    return requestAnimationFrame(state);
  };

  clearBackground = function() {
    return g.clearRect(0, 0, canvas.width, canvas.height);
  };

  TILE_SIZE = 32;

  TILE_WIDTH = 26;

  TILE_HEIGHT = 16;

  WORLD_WIDTH = TILE_SIZE * TILE_WIDTH;

  WORLD_HEIGHT = TILE_SIZE * TILE_HEIGHT;

  GRAVITY = 1024;

  TILE_TYPE_EMPTY = 0;

  TILE_TYPE_SOLID = 1;

  TILE_TYPE_DISTRACTION = 2;

  K = 1.0 / 32.0;

  pixToTile = function(x) {
    return Math.floor(K * x);
  };

  PIXELS_PER_METER = 32;

  DEBUG_PHYSICS = true;

  Pencil = (function() {
    function Pencil() {
      this.rubTime = 0;
    }

    Pencil.prototype.draw = function() {
      var angle, dx, dy, u;

      g.save();
      dx = mouseX - (canvas.width >> 1);
      dy = mouseY - (0.666 * canvas.height);
      angle = Math.atan2(dy, dx);
      g.translate(mouseX, mouseY);
      g.rotate(angle + Math.PI);
      if (!mouseDown) {
        g.drawImage(images.pencil, -images.pencil.width, -10);
      } else {
        if (mousePressed) {
          this.rubTime = 0;
        } else {
          this.rubTime += deltaSeconds();
        }
        u = 0.5 * Math.sin(TAU * 5 * this.rubTime);
        g.drawImage(images.pencil, u * 20 - images.pencil.width, -u * 4 - 10);
      }
      return g.restore();
    };

    return Pencil;

  })();

  Tile = (function() {
    function Tile(i) {
      this.x = i % TILE_WIDTH;
      this.y = (i - this.x) / TILE_WIDTH;
      this.type = TILE_TYPE_EMPTY;
      this.body = null;
    }

    Tile.prototype.isSolid = function() {
      return this.type === TILE_TYPE_SOLID;
    };

    Tile.prototype.isVisible = function() {
      return this.type !== TILE_TYPE_EMPTY;
    };

    Tile.prototype.initPhysics = function() {
      var bodyDef, fixDef;

      if (!this.isSolid()) {
        return;
      }
      fixDef = new FixtureDef;
      fixDef.density = 1;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.2;
      bodyDef = new BodyDef;
      bodyDef.type = Body.b2_staticBody;
      bodyDef.position.Set(this.x + 0.5, this.y + 0.5);
      fixDef.shape = new PolygonShape;
      fixDef.shape.SetAsBox(0.5, 0.5);
      this.body = world.physics.CreateBody(bodyDef);
      return this.body.CreateFixture(fixDef);
    };

    Tile.prototype.erase = function() {
      if (this.type === TILE_TYPE_EMPTY) {
        return false;
      }
      if (this.body != null) {
        world.physics.DestroyBody(this.body);
        this.body = null;
      }
      this.type = TILE_TYPE_EMPTY;
      return true;
    };

    Tile.prototype.draw = function() {
      var x, y;

      if (!this.isVisible()) {
        return;
      }
      x = this.x << 5;
      y = this.y << 5;
      return g.drawImage(images.testBaked, x + x, y + y, 64, 64, x - 16, y - 16, 64, 64);
    };

    return Tile;

  })();

  World = (function() {
    function World() {
      var bodyDef, debugDraw, fixDef, i, _i;

      this.offsetX = 0.5 * (canvas.width - WORLD_WIDTH) + 2;
      this.offsetY = 0.5 * (canvas.height - WORLD_HEIGHT) + 20;
      this.tiles = (function() {
        var _i, _ref, _results;

        _results = [];
        for (i = _i = 0, _ref = TILE_WIDTH * TILE_HEIGHT - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(new Tile(i));
        }
        return _results;
      })();
      this.hero = new HeroSprite;
      this.cupcake = new CupcakeSprite;
      this.physics = new b2World(new Vec2(0, GRAVITY / PIXELS_PER_METER), false);
      fixDef = new FixtureDef;
      fixDef.density = 1.0;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.2;
      bodyDef = new BodyDef;
      bodyDef.type = Body.b2_staticBody;
      bodyDef.position.Set(TILE_WIDTH / 2, TILE_HEIGHT + 0.5);
      fixDef.shape = new PolygonShape;
      fixDef.shape.SetAsBox(TILE_WIDTH / 2 + 1, 0.5);
      bodyDef.position.y = -0.5;
      this.physics.CreateBody(bodyDef).CreateFixture(fixDef);
      fixDef.shape = new PolygonShape;
      fixDef.shape.SetAsBox(0.5, TILE_HEIGHT / 2);
      bodyDef.position.Set(-0.5, TILE_HEIGHT / 2);
      this.physics.CreateBody(bodyDef).CreateFixture(fixDef);
      bodyDef.position.x = TILE_WIDTH + 0.5;
      this.physics.CreateBody(bodyDef).CreateFixture(fixDef);
      if (DEBUG_PHYSICS) {
        debugDraw = new DebugDraw();
        debugDraw.SetSprite(g);
        debugDraw.SetDrawScale(PIXELS_PER_METER);
        debugDraw.SetFillAlpha(0.5);
        debugDraw.SetLineThickness(4.0);
        debugDraw.SetFlags(DebugDraw.e_shapeBit | DebugDraw.e_jointBit);
        this.physics.SetDebugDraw(debugDraw);
      }
      bodyDef.type = Body.b2_dynamicBody;
      for (i = _i = 0; _i <= 9; i = ++_i) {
        if (Math.random() > 0.5) {
          fixDef.shape = new PolygonShape;
          fixDef.shape.SetAsBox(randRange(0.1, 1), randRange(0.1, 1));
        } else {
          fixDef.shape = new CircleShape(randRange(0.1, 2));
        }
        bodyDef.position.Set(randRange(1, TILE_WIDTH - 1), randRange(1, 4));
        this.physics.CreateBody(bodyDef).CreateFixture(fixDef);
      }
    }

    World.prototype.tick = function() {
      var _ref;

      this.physics.Step(deltaSeconds(), 10, 10);
      if (mouseDown) {
        if ((_ref = this.tileUnder(mouseX, mouseY)) != null) {
          _ref.erase();
        }
      }
      this.cupcake.tick();
      return this.hero.tick();
    };

    World.prototype.draw = function() {
      var tile, _i, _len, _ref;

      g.save();
      g.translate(this.offsetX, this.offsetY);
      if (DEBUG_PHYSICS) {
        this.physics.DrawDebugData();
      }
      _ref = this.tiles;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tile = _ref[_i];
        tile.draw();
      }
      this.cupcake.draw();
      this.hero.draw();
      return g.restore();
    };

    World.prototype.getTile = function(x, y) {
      if (x >= 0 && x < TILE_WIDTH && y >= 0 && y < TILE_HEIGHT) {
        return this.tiles[Math.floor(x) + TILE_WIDTH * Math.floor(y)];
      } else {
        return null;
      }
    };

    World.prototype.tileUnder = function(px, py) {
      return this.getTile(Math.floor((px - this.offsetX) / TILE_SIZE), Math.floor((py - this.offsetY) / TILE_SIZE));
    };

    return World;

  })();

  setupTest = function() {
    var i, tile, _i, _j, _len, _ref, _ref1;

    for (i = _i = 0, _ref = TILE_WIDTH - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      world.getTile(i, 14).type = TILE_TYPE_SOLID;
      world.getTile(i, 15).type = TILE_TYPE_DISTRACTION;
    }
    _ref1 = world.tiles;
    for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
      tile = _ref1[_j];
      tile.initPhysics();
    }
    world.hero.x = 32;
    world.hero.y = 12 * 32;
    world.hero.vx = 16;
    world.cupcake.x = 20 * 32;
    return world.cupcake.y = 9 * 32;
  };

  HERO_STATUS_WALKING = 0;

  HERO_STATUS_FALLING = 1;

  HeroSprite = (function() {
    function HeroSprite() {
      this.x = 0;
      this.y = 0;
      this.vx = 0;
      this.vy = 0;
      this.status = HERO_STATUS_WALKING;
    }

    HeroSprite.prototype.tick = function() {
      switch (this.status) {
        case HERO_STATUS_WALKING:
          return this.tickWalking();
        case HERO_STATUS_FALLING:
          return this.tickFalling();
      }
    };

    HeroSprite.prototype.tickWalking = function() {
      var top, xnext, xprev, _ref, _ref1, _ref2, _ref3, _ref4, _ref5;

      xprev = pixToTile(this.x);
      this.x += this.vx * deltaSeconds();
      xnext = pixToTile(this.x);
      if (xnext !== xprev) {
        top = pixToTile(this.y);
        if (this.vx > 0) {
          if (!((_ref = world.getTile(xnext, top + 2)) != null ? _ref.isSolid() : void 0)) {
            this.x = TILE_SIZE * xnext;
            this.vy = 128;
            return this.status = HERO_STATUS_FALLING;
          } else if (((_ref1 = world.getTile(xnext + 1, top)) != null ? _ref1.isSolid() : void 0) || ((_ref2 = world.getTile(xnext + 1, top + 1)) != null ? _ref2.isSolid() : void 0)) {
            this.vx = -this.vx;
            return this.x = TILE_SIZE * xnext;
          }
        } else {
          if (!((_ref3 = world.getTile(xnext + 1, top + 2)) != null ? _ref3.isSolid() : void 0)) {
            this.x = TILE_SIZE * (xnext + 1);
            this.vy = 128;
            return this.status = HERO_STATUS_FALLING;
          } else if (((_ref4 = world.getTile(xnext, top)) != null ? _ref4.isSolid() : void 0) || ((_ref5 = world.getTile(xnext, top + 1)) != null ? _ref5.isSolid() : void 0)) {
            this.vx = -this.vx;
            return this.x = TILE_SIZE * (xnext + 1);
          }
        }
      }
    };

    HeroSprite.prototype.tickFalling = function() {
      var x, y, _ref;

      this.vy += GRAVITY * deltaSeconds();
      this.y += this.vy * deltaSeconds();
      x = pixToTile(this.x);
      y = pixToTile(this.y) + 2;
      if ((_ref = world.getTile(x, y)) != null ? _ref.isSolid() : void 0) {
        this.vy = 0;
        this.y -= this.y % TILE_SIZE;
        return this.status = HERO_STATUS_WALKING;
      }
    };

    HeroSprite.prototype.draw = function() {
      var frame, h, w;

      frame = Math.floor(seconds() * 10) % 10;
      w = images.walk.width;
      h = images.walk.height / 10;
      if (this.vx < 0) {
        g.save();
        g.translate(this.x - 6, this.y);
        g.translate(w / 2, 0);
        g.scale(-1, 1);
        g.drawImage(images.walk, 0, frame * h, w, h, -w / 2, 0, w, h + 2);
        return g.restore();
      } else {
        return g.drawImage(images.walk, 0, frame * h, w, h, this.x - 6, this.y, w, h + 2);
      }
    };

    return HeroSprite;

  })();

  CUPCAKE_STATUS_IDLE = 0;

  CUPCAKE_STATUS_FALLING = 1;

  CupcakeSprite = (function() {
    function CupcakeSprite() {
      this.x = 0;
      this.y = 0;
      this.vy = 0;
      this.status = CUPCAKE_STATUS_IDLE;
    }

    CupcakeSprite.prototype.draw = function() {
      var frame, h, w;

      frame = Math.floor(seconds() * 7.5) % 6;
      w = images.cupcake.width;
      h = images.cupcake.height / 6;
      return g.drawImage(images.cupcake, 0, frame * h, w, h, this.x, this.y + 4, w, h);
    };

    CupcakeSprite.prototype.tick = function() {
      switch (this.status) {
        case CUPCAKE_STATUS_IDLE:
          return this.tickIdle();
        case CUPCAKE_STATUS_FALLING:
          return this.tickFalling();
      }
    };

    CupcakeSprite.prototype.tickIdle = function() {
      var x, y, _ref, _ref1;

      x = pixToTile(this.x);
      y = pixToTile(this.y);
      if (!(((_ref = world.getTile(x, y + 2)) != null ? _ref.isSolid() : void 0) || ((_ref1 = world.getTile(x + 1, y + 2)) != null ? _ref1.isSolid() : void 0))) {
        this.vy = 128;
        return this.status = CUPCAKE_STATUS_FALLING;
      }
    };

    CupcakeSprite.prototype.tickFalling = function() {
      var x, y, _ref, _ref1;

      this.vy += GRAVITY * deltaSeconds();
      this.y += this.vy * deltaSeconds();
      x = pixToTile(this.x);
      y = pixToTile(this.y);
      if (((_ref = world.getTile(x, y + 2)) != null ? _ref.isSolid() : void 0) || ((_ref1 = world.getTile(x + 1, y + 2)) != null ? _ref1.isSolid() : void 0)) {
        this.vy = 0;
        this.y -= this.y % TILE_SIZE;
        return this.status = CUPCAKE_STATUS_IDLE;
      }
    };

    return CupcakeSprite;

  })();

  $(function() {
    var doGameplay, doc;

    canvas = $('canvas')[0];
    if ((canvas != null ? canvas.getContext : void 0) == null) {
      alert('HTML5 Required, Dude');
      return;
    }
    g = canvas.getContext('2d');
    doc = $(this);
    doc.mousemove(function(e) {
      mouseX = e.pageX - canvas.offsetLeft;
      return mouseY = e.pageY - canvas.offsetTop;
    });
    doc.mousedown(function(e) {
      if (e.which !== 1) {
        return;
      }
      mouseX = e.pageX - canvas.offsetLeft;
      mouseY = e.pageY - canvas.offsetTop;
      mouseDown = true;
      mousePressed = true;
      if (mouseX >= 0 && mouseX < canvas.width && mouseY >= 0 && mouseY < canvas.height) {
        return e.preventDefault();
      }
    });
    doc.mouseup(function(e) {
      if (e.which !== 1) {
        return;
      }
      mouseX = e.pageX - canvas.offsetLeft;
      mouseY = e.pageY - canvas.offsetTop;
      mouseDown = false;
      mouseReleased = true;
      if (mouseX >= 0 && mouseX < canvas.width && mouseY >= 0 && mouseY < canvas.height) {
        return e.preventDefault();
      }
    });
    time = rawMillis();
    pencil = new Pencil;
    world = new World;
    setupTest();
    doGameplay = function() {
      clearBackground();
      world.tick();
      world.draw();
      pencil.draw();
      return queueFrame(doGameplay);
    };
    return (function() {
      if (images.loading()) {
        if (images.failed()) {
          return alert("Eek! Failed to load Assets :*(");
        } else {
          return queueFrame(arguments.callee);
        }
      } else {
        return queueFrame(doGameplay);
      }
    })();
  });

}).call(this);
