part of Game;

class Player {
	static int X = 300;
	static int Y = 0;

	static int playerHeight = 32;
	bool walking = false;
	bool falling = false;
	double fallingSpeed = 0.0;
	static int mana = 100;
	static int maxMana = 1000;
	bool jumping = false;
	static int stepWidth = 5;
	Angle waterAngle = new Angle();
	Sprite playerWalkingRight = new Sprite(ResManager.get("img/player.png"));
	static bool walkingLeft = false;
	double lastUpdated;
	bool water = true;
	bool fire = false;
	bool earth = false;
	bool wind = false;
	List<Bullet> _rocks = [];

	int waterManaUsage = 8;
	int earthManaUsage = 100;
	int earthDamage = 10;

	Sprite waterSprite = new Sprite(ResManager.get("img/water.png"));

	Player() {
		playerHeight = ResManager.get("img/playerWalkRight.png").height;
		waterSprite.setTileSize(128);
	}

	void walkRight() {
		walking = true;
		walkingLeft = false;
	}

	void walkLeft() {
		walking = true;
		walkingLeft = true;
	}

	void switchMode(int mode) {
		/* 0 = Fire
		   1 = Water
		   2 = Wind
		   3 = Earth */
		water = false;
		fire = false;
		wind = false;
		earth = false;
		if(mode == 0) {
			fire = true;
		}
		if(mode == 1) {
			water = true;
		}
		if(mode == 2) {
			wind = true;
		}
		if(mode == 3) {
			earth = true;
		}
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
		updateRocks(delta);
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
			if(water) {
				useWater();
			}
			if(earth) {
				useEarth();
			}
			chargeMana();
		} 
	}

	void useWater() {
		waterManaUsage = 8;
		if(mana > waterManaUsage) {
			decrementMana(waterManaUsage);
		} else {
			switchMode(0);
		}	
	}

	void useEarth() {
		earthManaUsage = 100;
		if(mana > earthManaUsage) {
			decrementMana(earthManaUsage);
			launchRocks();
		} else {
			switchMode(0);
		}
	}

	void launchRocks() {
		if(_rocks.length<5) {
			for(int i = 0; i < GameParameters.screenWidth; i += 64) {
				Angle angle = new Angle();
				math.Random r = new math.Random();
				angle.set(r.nextInt(180).toDouble());
				Bullet b = new Bullet(i + Player.X-(GameParameters.screenWidth/2).floor(), -64, angle);
				b.setRock();
				_rocks.add(b);
			}
		}
	}

	void drawRocks() {
		if(_rocks.length!=0) {
			for(Bullet b in _rocks) {
				b.draw();
			}
		}
	}

	void updateRocks(double delta) {
		delta = delta+5.0;
		if(_rocks.length!=0) {
			for(int i = 0; i < _rocks.length; i++) {
				_rocks[i].update(delta);
				if(_rocks[i].Y > GameParameters.screenHeight) {
					_rocks.removeAt(i);
				} 
			}
		}
	}

	void decrementMana(int m) {
		mana -= m;
		if(mana < 0) {
			mana = 0;
		}
	}

	void chargeMana() {
		mana += 1;
		if(mana > maxMana) {
			mana = maxMana;
		}
	}

	void draw() {
		playerWalkingRight.draw(Game.dc, GameParameters.screenWidth/2, Y, new Angle());
		playerWalkingRight.step();
		if(water) {
			waterSprite.draw(Game.dc, GameParameters.screenWidth/2+playerWalkingRight.getTileSize()/2-waterSprite.getTileSize()/2, Y+playerWalkingRight.getTileSize()/2-waterSprite.getTileSize()/2,waterAngle);
			waterAngle.set(waterAngle.getAngle()+1);
			waterSprite.step();
		}
		drawRocks();
	}

	bool isItGettingBlocked(int x, int y) {
		if(water) {
			if(x-10 > GameParameters.screenWidth/2+playerWalkingRight.getTileSize()/2-waterSprite.getTileSize()/2 && x+10 < GameParameters.screenWidth/2+playerWalkingRight.getTileSize()/2+waterSprite.getTileSize()/2) {
				if(y-10 > Y+playerWalkingRight.getTileSize()/2-waterSprite.getTileSize()/2 && y+10 < Y+playerWalkingRight.getTileSize()/2+waterSprite.getTileSize()/2)
					return true;
			}
		}
		return false;
	}

	int isGettingHurtBy(int x, int y) {
		int hsx = (GameParameters.screenWidth/2).floor();
		if(x > Player.X-hsx && x < Player.X+hsx) {
			if(earth) {
				return earthDamage;
			}
		}
	}

}

