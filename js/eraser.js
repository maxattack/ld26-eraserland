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
  var Body, BodyDef, CircleShape, ContactListener, CupcakeSprite, DEBUG_PHYSICS, DebugDraw, Fixture, FixtureDef, GRAVITY, HERO_STATUS_FALLING, HERO_STATUS_WALKING, HeroSprite, ImageGroup, K, MassData, PIXELS_PER_METER, Pencil, PolygonShape, STATUS_ACTIVE, STATUS_LOSE, STATUS_WIN, TAU, TILE_HEIGHT, TILE_SIZE, TILE_TYPE_DISTRACTION, TILE_TYPE_EMPTY, TILE_TYPE_SOLID, TILE_WIDTH, Tile, Vec2, WORLD_HEIGHT, WORLD_WIDTH, World, WorldManifold, b2World, canvas, clearBackground, deltaSeconds, dt, firstLevel, g, images, mouseDown, mousePressed, mouseReleased, mouseX, mouseY, pencil, pixToTile, queueFrame, randRange, rawMillis, scratchManifold, seconds, setupPhysics, showPhysics, startScreen, tileId, time, world;

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

  WorldManifold = Box2D.Collision.b2WorldManifold;

  ContactListener = Box2D.Dynamics.b2ContactListener;

  TAU = Math.PI + Math.PI;

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

  images = new ImageGroup(['images/pencil.png', 'images/background.jpg', 'images/walk.png', 'images/cupcake.png', 'images/first_baked.png', 'images/startScreen_baked.png', 'images/loseScreen.png', 'images/winScreen.png', 'images/heart1.png']);

  pencil = null;

  world = null;

  scratchManifold = new WorldManifold;

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

  tileId = function(x, y) {
    return x + TILE_WIDTH * y;
  };

  PIXELS_PER_METER = 32;

  DEBUG_PHYSICS = true;

  showPhysics = false;

  Pencil = (function() {
    function Pencil() {
      pencil = this;
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

  STATUS_ACTIVE = 0;

  STATUS_WIN = 1;

  STATUS_LOSE = 2;

  World = (function() {
    function World(options) {
      var i, listener, _i, _j, _len, _len1, _ref, _ref1,
        _this = this;

      world = this;
      this.tilemap = options.tilemap;
      this.offsetX = 0.5 * (canvas.width - WORLD_WIDTH) + 2;
      this.offsetY = 0.5 * (canvas.height - WORLD_HEIGHT) + 20;
      this.physics = setupPhysics();
      this.tiles = (function() {
        var _i, _ref, _results;

        _results = [];
        for (i = _i = 0, _ref = TILE_WIDTH * TILE_HEIGHT - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(new Tile(i));
        }
        return _results;
      })();
      if (options.solidTiles != null) {
        _ref = options.solidTiles;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          this.tiles[i].setSolid();
        }
      }
      if (options.distractionTiles != null) {
        _ref1 = options.distractionTiles;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          i = _ref1[_j];
          this.tiles[i].setDistracting();
        }
      }
      if (options.hero !== void 0) {
        this.hero = new HeroSprite(options.hero);
      }
      if (options.cupcake !== void 0) {
        this.cupcake = new CupcakeSprite(options.cupcake);
      }
      this.status = STATUS_ACTIVE;
      if ((this.hero != null) && (this.cupcake != null)) {
        listener = new ContactListener;
        listener.BeginContact = function(contact) {
          if (contact.GetFixtureA().GetBody().GetUserData() === _this.hero) {
            if (contact.GetFixtureB().GetBody().GetUserData() === _this.cupcake) {
              return _this.status = STATUS_WIN;
            }
          } else if (contact.GetFixtureB().GetBody().GetUserData() === _this.hero) {
            if (contact.GetFixtureA().GetBody().GetUserData() === _this.cupcake) {
              return _this.status = STATUS_WIN;
            }
          }
        };
        this.physics.SetContactListener(listener);
      }
    }

    World.prototype.tick = function() {
      var _ref, _ref1, _ref2, _ref3, _ref4;

      if (this.status !== STATUS_ACTIVE) {
        return;
      }
      this.physics.Step(deltaSeconds(), 10, 10);
      if (this.status === STATUS_ACTIVE) {
        if (mouseDown) {
          if ((_ref = this.tileUnder(mouseX, mouseY)) != null) {
            _ref.erase();
          }
        }
        if ((_ref1 = this.cupcake) != null) {
          _ref1.tick();
        }
        if ((_ref2 = this.hero) != null) {
          _ref2.tick();
        }
        if (((_ref3 = this.cupcake) != null ? _ref3.outOfBounds() : void 0) || ((_ref4 = this.hero) != null ? _ref4.outOfBounds() : void 0)) {
          return this.status = STATUS_LOSE;
        }
      }
    };

    World.prototype.draw = function() {
      var tile, _i, _len, _ref, _ref1, _ref2;

      g.save();
      g.translate(this.offsetX, this.offsetY);
      if (DEBUG_PHYSICS && showPhysics) {
        this.physics.DrawDebugData();
      }
      _ref = this.tiles;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tile = _ref[_i];
        tile.draw();
      }
      if ((_ref1 = this.cupcake) != null) {
        _ref1.draw();
      }
      if ((_ref2 = this.hero) != null) {
        _ref2.draw();
      }
      return g.restore();
    };

    World.prototype.getTile = function(x, y) {
      if (x >= 0 && x < TILE_WIDTH && y >= 0 && y < TILE_HEIGHT) {
        return this.tiles[tileId(x, y)];
      } else {
        return null;
      }
    };

    World.prototype.tileUnder = function(px, py) {
      return this.getTile(Math.floor((px - this.offsetX) / TILE_SIZE), Math.floor((py - this.offsetY) / TILE_SIZE));
    };

    return World;

  })();

  setupPhysics = function() {
    var body, bodyDef, debugDraw, fixDef, physics;

    physics = new b2World(new Vec2(0, GRAVITY / PIXELS_PER_METER), false);
    bodyDef = new BodyDef;
    bodyDef.type = Body.b2_staticBody;
    bodyDef.position.Set(TILE_WIDTH / 2, TILE_HEIGHT + 0.5);
    fixDef = new FixtureDef;
    fixDef.density = 1.0;
    fixDef.friction = 0.5;
    fixDef.restitution = 0.2;
    fixDef.shape = new PolygonShape;
    fixDef.shape.SetAsBox(TILE_WIDTH / 2 + 1, 0.5);
    bodyDef.position.y = -0.5;
    body = physics.CreateBody(bodyDef).CreateFixture(fixDef);
    fixDef.shape = new PolygonShape;
    fixDef.shape.SetAsBox(0.5, TILE_HEIGHT / 2);
    bodyDef.position.Set(-0.5, TILE_HEIGHT / 2);
    physics.CreateBody(bodyDef).CreateFixture(fixDef);
    bodyDef.position.x = TILE_WIDTH + 0.5;
    physics.CreateBody(bodyDef).CreateFixture(fixDef);
    if (DEBUG_PHYSICS) {
      debugDraw = new DebugDraw();
      debugDraw.SetSprite(g);
      debugDraw.SetDrawScale(PIXELS_PER_METER);
      debugDraw.SetFillAlpha(0.5);
      debugDraw.SetLineThickness(4.0);
      debugDraw.SetFlags(DebugDraw.e_shapeBit | DebugDraw.e_jointBit);
      physics.SetDebugDraw(debugDraw);
    }
    return physics;
  };

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

    Tile.prototype.setSolid = function() {
      var bodyDef, fixDef;

      this.type = TILE_TYPE_SOLID;
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
      this.body.CreateFixture(fixDef);
      return this.body.SetUserData(this);
    };

    Tile.prototype.setDistracting = function() {
      return this.type = TILE_TYPE_DISTRACTION;
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
      return g.drawImage(world.tilemap, x + x, y + y, 64, 64, x - 16, y - 16, 64, 64);
    };

    return Tile;

  })();

  HERO_STATUS_WALKING = 0;

  HERO_STATUS_FALLING = 1;

  HeroSprite = (function() {
    function HeroSprite(options) {
      var bodyDef, fixDef, vert, _i, _len, _ref;

      this.walkingSpeed = options.walkingSpeed;
      this.status = HERO_STATUS_WALKING;
      bodyDef = new BodyDef;
      bodyDef.fixedRotation = true;
      bodyDef.type = Body.b2_dynamicBody;
      bodyDef.position.Set(options.x, options.y);
      this.body = world.physics.CreateBody(bodyDef);
      fixDef = new FixtureDef;
      fixDef.density = 1;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.2;
      fixDef.shape = new PolygonShape;
      fixDef.shape.SetAsBox(0.45, 0.7);
      _ref = fixDef.shape.GetVertices();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        vert = _ref[_i];
        vert.y -= 0.255;
      }
      this.body.CreateFixture(fixDef);
      fixDef.shape = new CircleShape(0.45);
      fixDef.shape.SetLocalPosition(new Vec2(0, 0.5));
      this.body.CreateFixture(fixDef);
      this.body.SetUserData(this);
    }

    HeroSprite.prototype.outOfBounds = function() {
      var p;

      p = this.body.GetPosition();
      return p.x < -1 || p.x > TILE_WIDTH + 1 || p.y > TILE_HEIGHT + 2;
    };

    HeroSprite.prototype.draw = function() {
      var frame, h, p, w, x, y;

      p = this.body.GetPosition();
      x = 32 * (p.x - 0.5) - 6;
      y = 32 * (p.y - 1);
      frame = Math.floor(seconds() * 10) % 10;
      w = images.walk.width;
      h = images.walk.height / 10;
      if (this.walkingSpeed < 0) {
        g.save();
        g.translate(x, y);
        g.translate(w / 2, 0);
        g.scale(-1, 1);
        g.drawImage(images.walk, 0, frame * h, w, h, -w / 2, 0, w, h + 2);
        return g.restore();
      } else {
        return g.drawImage(images.walk, 0, frame * h, w, h, x, y, w, h + 2);
      }
    };

    HeroSprite.prototype.tick = function() {
      var didHitWall, edge, isGrounded, vel;

      isGrounded = false;
      didHitWall = false;
      edge = this.body.GetContactList();
      while (edge != null) {
        if (edge.other.GetType() === Body.b2_staticBody) {
          edge.contact.GetWorldManifold(scratchManifold);
          if (scratchManifold.m_normal.y < -0.95) {
            isGrounded = true;
          } else if (!didHitWall) {
            if (this.walkingSpeed > 0) {
              if (scratchManifold.m_normal.x > 0.95) {
                didHitWall = true;
              }
            } else {
              if (scratchManifold.m_normal.x < -0.95) {
                didHitWall = true;
              }
            }
          }
        }
        edge = edge.next;
      }
      if (isGrounded) {
        if (didHitWall) {
          this.walkingSpeed = -this.walkingSpeed;
        }
        vel = this.body.GetLinearVelocity();
        vel.x = this.walkingSpeed;
        return this.body.SetLinearVelocity(vel);
      }
    };

    return HeroSprite;

  })();

  CupcakeSprite = (function() {
    function CupcakeSprite(options) {
      var bodyDef, fixDef;

      bodyDef = new BodyDef;
      bodyDef.fixedRotation = true;
      bodyDef.type = Body.b2_dynamicBody;
      bodyDef.position.Set(options.x, options.y);
      this.body = world.physics.CreateBody(bodyDef);
      fixDef = new FixtureDef;
      fixDef.density = 1;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.2;
      fixDef.shape = new PolygonShape;
      fixDef.shape.SetAsBox(0.95, 0.95);
      this.body.CreateFixture(fixDef);
      this.body.SetUserData(this);
    }

    CupcakeSprite.prototype.outOfBounds = function() {
      var p;

      p = this.body.GetPosition();
      return p.x < -1 || p.x > TILE_WIDTH + 1 || p.y > TILE_HEIGHT + 2;
    };

    CupcakeSprite.prototype.draw = function() {
      var frame, h, p, w, x, y;

      frame = Math.floor(seconds() * 7.5) % 6;
      w = images.cupcake.width;
      h = images.cupcake.height / 6;
      p = this.body.GetPosition();
      x = 32 * (p.x - 1);
      y = 32 * (p.y - 1) + 4;
      return g.drawImage(images.cupcake, 0, frame * h, w, h, x, y, w, h);
    };

    CupcakeSprite.prototype.tick = function() {};

    return CupcakeSprite;

  })();

  startScreen = {
    tilemap: images.startScreenBaked,
    solidTiles: [tileId(11, 8), tileId(12, 8), tileId(13, 8), tileId(14, 8), tileId(11, 9), tileId(12, 9), tileId(13, 9), tileId(14, 9), tileId(11, 10), tileId(12, 10), tileId(13, 10), tileId(14, 10), tileId(11, 11), tileId(12, 11), tileId(13, 11), tileId(14, 11)]
  };

  firstLevel = (function() {
    var i, options;

    options = {
      tilemap: images.firstBaked,
      solidTiles: (function() {
        var _i, _ref, _results;

        _results = [];
        for (i = _i = 0, _ref = TILE_WIDTH - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(tileId(i, 14));
        }
        return _results;
      })(),
      distractionTiles: (function() {
        var _i, _ref, _results;

        _results = [];
        for (i = _i = 0, _ref = TILE_WIDTH - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(tileId(i, 15));
        }
        return _results;
      })(),
      hero: {
        x: 1,
        y: 8,
        walkingSpeed: 4
      },
      cupcake: {
        x: 20,
        y: 9
      }
    };
    options.solidTiles.push(tileId(12, 10), tileId(12, 11), tileId(12, 12), tileId(12, 13), tileId(13, 10), tileId(13, 11));
    return options;
  })();

  $(function() {
    var beginGameplay, beginLose, beginStartScreen, beginWin, doGameplay, doLoseScreenIn, doStartScreen, doWinScreenIn, doc, timeout, transition;

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
    if (DEBUG_PHYSICS) {
      doc.keydown(function(e) {
        if (e.which === 80) {
          return showPhysics = !showPhysics;
        }
      });
    }
    time = rawMillis();
    new Pencil;
    beginStartScreen = function() {
      new World(startScreen);
      return doStartScreen();
    };
    doStartScreen = function() {
      var anySolid, tile, _i, _len, _ref;

      clearBackground();
      clearBackground();
      world.tick();
      anySolid = false;
      _ref = world.tiles;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tile = _ref[_i];
        if (tile.isSolid()) {
          anySolid = true;
          break;
        }
      }
      if (!anySolid) {
        return beginGameplay();
      } else {
        world.draw();
        pencil.draw();
        return queueFrame(doStartScreen);
      }
    };
    transition = 0;
    timeout = 0;
    beginGameplay = function() {
      new World(firstLevel);
      transition = 0;
      return doGameplay();
    };
    doGameplay = function() {
      clearBackground();
      world.tick();
      transition += 0.1 * (1.0 - transition);
      if (transition < 0.99) {
        g.globalAlpha = transition;
      }
      world.draw();
      if (transition < 0.99) {
        g.globalAlpha = 1;
      }
      pencil.draw();
      switch (world.status) {
        case STATUS_LOSE:
          return beginLose();
        case STATUS_WIN:
          return beginWin();
        default:
          return queueFrame(doGameplay);
      }
    };
    beginLose = function() {
      transition = 0;
      timeout = 0;
      return queueFrame(doLoseScreenIn);
    };
    doLoseScreenIn = function() {
      var duration, u;

      duration = 4;
      transition += 0.1 * (1.0 - transition);
      clearBackground();
      u = timeout / (0.25 * duration);
      if (u > 1) {
        u = 1;
      }
      g.globalAlpha = (1 - u) * (1 - u);
      world.draw();
      g.globalAlpha = 1;
      g.drawImage(images.loseScreen, 0.5 * (canvas.width - images.loseScreen.width), 175 * transition);
      pencil.draw();
      timeout += deltaSeconds();
      if (timeout > duration) {
        return beginGameplay();
      } else {
        return queueFrame(doLoseScreenIn);
      }
    };
    beginWin = function() {
      transition = 0;
      timeout = 0;
      return queueFrame(doWinScreenIn);
    };
    doWinScreenIn = function() {
      transition += 0.1 * (1.0 - transition);
      clearBackground();
      world.draw();
      g.drawImage(images.heart1, canvas.width - 200, canvas.height - 200);
      g.drawImage(images.winScreen, 0.5 * (canvas.width - images.winScreen.width), 125 * transition);
      pencil.draw();
      return queueFrame(doWinScreenIn);
    };
    return (function() {
      if (images.loading()) {
        if (images.failed()) {
          return alert("Eek! Failed to load Assets :*(");
        } else {
          return queueFrame(arguments.callee);
        }
      } else {
        return beginGameplay();
      }
    })();
  });

}).call(this);
