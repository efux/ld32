part of Game;

class Bullet {
	int X;
	int Y;
	Angle angle;
	double lastUpdated;
	int speed = 4;
	Vector _movement;
	Sprite bullet = new Sprite(ResManager.get("img/bullet.png"));

	Bullet(int X, int Y, Angle angle) {
		bullet.setTileSize(5);
		this.X = X;
		this.Y = Y;
		this.angle = angle;
		_movement = new Vector(speed, 0);
		_movement.rotate(angle);
	}

	void setRock() {
		bullet = new Sprite(ResManager.get("img/rock.png"));
		bullet.setTileSize(64);
	}

	void update(double delta) {
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
	}
}
