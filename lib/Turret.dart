part of Game;

class Turret {
	double lastUpdated;
	double lastLaunched;
	double lastFire = 0.0;

	int X;
	int Y;
	bool dead = false;
	int energy = 100;

	static Sprite turretSprite = new Sprite(ResManager.get("img/turret.png"));
	static Sprite cannonSprite = new Sprite(ResManager.get("img/turretcannon.png"));
	static Sprite smokeSprite = new Sprite(ResManager.get("img/smoke.png"));
	Angle cannonAngle = new Angle();
	List <Bullet> _rockets = [];

	Turret(int X, int Y) {
		this.X = X;
		this.Y = Y;
		turretSprite.setTileSize(32);
		cannonSprite.setTileSize(21);
		cannonSprite.setYSize(6);
	}

	void update(double delta) {
		int hsx = (GameParameters.screenWidth/2).floor();
		if(lastUpdated == null) {
			lastUpdated = delta;
			lastLaunched = delta;
		}
		if(X > Player.X - hsx && X < Player.X + hsx) {
			if(!dead) {
				if(delta - lastLaunched > 2000) {
					launchRocket();
					lastLaunched = delta;
					adjustAngleToPlayer();
				}
			}
		}
		if(delta - lastUpdated > 15) {
			updateRockets(delta);
			lastUpdated = delta;
		}
	}

	void launchRocket() {
		Bullet b = new Bullet(X,Y, new Angle());
		b.setRocket();
		_rockets.add(b);
	}

	void updateRockets(double delta) {
		if(_rockets.length > 0) {
			for(int i = 0; i < _rockets.length; i++) {
				Bullet b = _rockets[i];
				b.update(delta);
				if(b.Y < 0 || b.Y > GameParameters.screenHeight || Game.getLevel().hasTileOnExactPosition(b.X-Player.X, b.Y) || Game.getPlayer().isItGettingBlocked(b.X-Player.X+(GameParameters.screenWidth/2).floor(), b.Y)) {
					_rockets.removeAt(i);
				}
			}
		}
	}
	
	void adjustAngleToPlayer() {
		Vector vPlayer = new Vector(1,0);
		int dy = Player.Y-Y;
		Vector vBullet = new Vector(Player.X-X, dy);
		cannonAngle.setRadian(vPlayer.getAngle(vBullet));
		if(Player.Y < Y) {
			cannonAngle.set(360.0-cannonAngle.getAngle());
		}
	}

	void draw() {
		int hsx = (GameParameters.screenWidth/2).floor();
		if(X > Player.X - hsx && X < Player.X + hsx) {
			int dx = X-Player.X+(GameParameters.screenWidth/2).floor();
			turretSprite.draw(Game.dc, dx, Y, new Angle());
			cannonSprite.draw(Game.dc, dx+3, Y+5, cannonAngle);
			if(dead && lastUpdated - lastFire > 300) {
				lastFire = lastUpdated;
				smokeSprite.step();
			}
			if(dead) {
				smokeSprite.draw(Game.dc, dx, Y-GameParameters.tileSize+5, new Angle());
			}
		}
		for(Bullet b in _rockets) {
			b.draw();
		}
	}

	void looseEnergy(int e) {
		energy -= e;
		if(energy<=0) {
			if(dead==false) {
				Game.playSound("sounds/turret_destroyed.wav");
			}
			dead = true;
		}
	}

}
