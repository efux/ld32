part of Game;

class Bullet {
	int X;
	int Y;
	Angle angle;
	double lastUpdated;
	int speed = 4;
	bool intelligent = false;
	Vector _movement;
	Sprite bullet = new Sprite(ResManager.get("img/bullet.png"));

	Bullet(int X, int Y, Angle angle) {
		bullet.setTileSize(5);
		this.X = X;
		this.Y = Y;
		setAngle(angle);
	}

	void setAngle(Angle angle) {
		this.angle = angle;
		_movement = new Vector(speed, 0);
		_movement.rotate(angle);
	}

	void setRock() {
		bullet = new Sprite(ResManager.get("img/rock.png"));
		bullet.setTileSize(64);
	}

	void setRocket() {
		bullet = new Sprite(ResManager.get("img/rocket.png"));
		bullet.setTileSize(16);
		intelligent = true;
	}

	void adjustAngleToPlayer() {
		Vector vPlayer = new Vector(1,0);
		int dy = Player.Y-Y;
		Vector vBullet = new Vector(Player.X-X, dy);
		angle.setRadian(vPlayer.getAngle(vBullet));
		if(Player.Y < Y) {
			angle.set(360.0-angle.getAngle());
		}

		setAngle(angle);
	}

	void update(double delta) {
		if(intelligent) {
			adjustAngleToPlayer();
		}
		if(lastUpdated==null) {
			lastUpdated = delta;
		}
		if(delta - lastUpdated > 15) {
			X += _movement.x;
			Y += _movement.y;
			lastUpdated = delta;
		}
	}

	void draw() {
		int dx = X-Player.X+(GameParameters.screenWidth/2).floor();
		bullet.draw(Game.dc, dx, Y, angle);
		bullet.step();
	}
}
