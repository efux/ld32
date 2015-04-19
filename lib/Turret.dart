part of Game;

class Turret {
	double lastUpdated;
	double lastLaunched;

	int X;
	int Y;

	static Sprite turretSprite = new Sprite(ResManager.get("img/turret.png"));
	static Sprite cannonSprite = new Sprite(ResManager.get("img/turretcannon.png"));
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
		if(lastUpdated == null) {
			lastUpdated = delta;
			lastLaunched = delta;
		}
		if(delta - lastUpdated > 15) {
			updateRockets(delta);
			lastUpdated = delta;
		}
		if(delta - lastLaunched > 2000) {
			launchRocket();
			lastLaunched = delta;
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
		adjustAngleToPlayer();
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
		int dx = X-Player.X+(GameParameters.screenWidth/2).floor();
		turretSprite.draw(Game.dc, dx, Y, new Angle());
		cannonSprite.draw(Game.dc, dx+3, Y+5, cannonAngle);
		for(Bullet b in _rockets) {
			b.draw();
		}
	}

}
