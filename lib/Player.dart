part of Game;

class Player {
	static int X = 60;
	static int Y = 0;

	static int playerHeight = 32;
	bool walking = false;
	bool falling = false;
	double fallingSpeed = 0.0;
	bool jumping = false;
	static int stepWidth = 5;
	Sprite playerWalkingRight = new Sprite(ResManager.get("img/player.png"));
	static bool walkingLeft = false;
	double lastUpdated;

	Player() {
		playerHeight = ResManager.get("img/playerWalkRight.png").height;
	}

	void walkRight() {
		walking = true;
		walkingLeft = false;
	}

	void walkLeft() {
		walking = true;
		walkingLeft = true;
	}

	void setFloor(bool onTheFloor) {
		if(onTheFloor) {
			if(jumping==false) {
				falling = false;
				fallingSpeed = 0.0;
				if(Y % GameParameters.tileSize != 0) {
					Y -= (Y % GameParameters.tileSize);
				}
			}
		} else {
			falling = true;
			if(fallingSpeed==0) {
				jumping = false;
				fallingSpeed = 5.0;
			} else {
				fallingSpeed += 0.5;
			}
		}
	}

	void jump() {
		if(falling==false) {
			jumping = true;
			falling = true;
			fallingSpeed = -10.0;
		}
	}

	void update(double delta) {
		if(lastUpdated == null) {
			lastUpdated = delta;
		}
		if(delta - lastUpdated > 20) {
			if(walking) {
				if(walkingLeft) {
					X -= stepWidth;
				} else {
					X += stepWidth;
				}
			}
			if(falling) {
				Y += fallingSpeed;
			}

		} 
	}

	void draw() {
		playerWalkingRight.draw(Game.dc, GameParameters.screenWidth/2, Y, new Angle());
		playerWalkingRight.step();
	}

}

