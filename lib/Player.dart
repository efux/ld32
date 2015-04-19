part of Game;

class Player {
	static int X = 300;
	static int Y = 0;

	static int playerHeight = 32;
	bool walking = false;
	bool falling = false;
	double fallingSpeed = 0.0;
	static int mana = 900;
	static int maxMana = 1000;
	bool jumping = false;
	static int stepWidth = 5;
	Angle waterAngle = new Angle();
	Sprite playerWalkingRight = new Sprite(ResManager.get("img/playerWalkRight.png"));
	Sprite playerWalkingLeft = new Sprite(ResManager.get("img/playerWalkLeft.png"));
	Sprite summonSprite = new Sprite(ResManager.get("img/action.png"));
	Sprite player = new Sprite(ResManager.get("img/player.png"));
	static bool walkingLeft = false;
	double lastUpdated;
	bool water = false;
	bool fire = true;
	bool earth = false;
	bool wind = false;
	bool activated = false;
	bool lookingRight = true;
	int oldMode = 0;
	List<Bullet> _rocks = [];

	int waterManaUsage = 8;
	int earthManaUsage = 100;
	int earthDamage = 10;
	int fireManaUsage = 2;
	int fireDamage = 3;
	int windManaUsage = 20;

	Sprite waterSprite = new Sprite(ResManager.get("img/water.png"));
	Sprite fireSprite = new Sprite(ResManager.get("img/fire.png"));

	Player() {
		playerHeight = ResManager.get("img/playerWalkRight.png").height;
		waterSprite.setTileSize(128);
		fireSprite.setTileSize(64);
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
		if(oldMode==mode) {
			mode = 0;
		}
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
			fallingSpeed = -8.0;
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
			if(activated) {
				if(water) {
					useWater();
				}
				if(earth) {
					useEarth();
				}
				if(fire) {
					useFire();
				} 
			}
			chargeMana();
		} 
	}
	
	void useFire() {
		if(mana > fireManaUsage) {
			decrementMana(fireManaUsage);
		} 
	}

	void useWater() {
		if(mana > waterManaUsage) {
			decrementMana(waterManaUsage);
		} else {
			switchMode(0);
		}	
	}

	void useEarth() {
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
		if(walking) {
			if(walkingLeft) {
				playerWalkingLeft.draw(Game.dc, GameParameters.screenWidth/2, Y, new Angle());
				playerWalkingLeft.step();
			} else {
				playerWalkingRight.draw(Game.dc, GameParameters.screenWidth/2, Y, new Angle());
				playerWalkingRight.step();
			}
		} else {
			if(activated) {
				if(water || earth) {
					summonSprite.draw(Game.dc, GameParameters.screenWidth/2, Y, new Angle());
					summonSprite.step();
				}	
			} else {
				player.draw(Game.dc, GameParameters.screenWidth/2, Y, new Angle());
				player.step();
			}
		}
		if(activated) {
			if(water) {
				waterSprite.draw(Game.dc, GameParameters.screenWidth/2+playerWalkingRight.getTileSize()/2-waterSprite.getTileSize()/2, Y+playerWalkingRight.getTileSize()/2-waterSprite.getTileSize()/2,waterAngle);
				waterAngle.set(waterAngle.getAngle()+1);
				waterSprite.step();
			} 
			if(fire) {
				Angle angle = new Angle();
				int dx = (GameParameters.screenWidth/2 + playerWalkingRight.getTileSize()/2).floor();
				int dy = Y - 20;
				if(lookingRight == false) { 
					angle.set(180.0); 
					dx = (GameParameters.screenWidth/2 - playerWalkingRight.getTileSize()/2 - fireSprite.getTileSize()).floor();
				}
				fireSprite.draw(Game.dc, dx, dy, angle);
				fireSprite.step();
			}
		}
		drawRocks();
	}

	bool isItGettingBlocked(int x, int y) {
		if(water && activated) {
			if(x-10 > GameParameters.screenWidth/2+playerWalkingRight.getTileSize()/2-waterSprite.getTileSize()/2 && x+10 < GameParameters.screenWidth/2+playerWalkingRight.getTileSize()/2+waterSprite.getTileSize()/2) {
				if(y-10 > Y+playerWalkingRight.getTileSize()/2-waterSprite.getTileSize()/2 && y+10 < Y+playerWalkingRight.getTileSize()/2+waterSprite.getTileSize()/2)
					return true;
			}
		}
		return false;
	}

	int isGettingHurtBy(int x, int y) {
		int hsx = (GameParameters.screenWidth/2).floor();
		if(activated) {
			if(earth) {
				if(x > Player.X-hsx && x < Player.X+hsx) {
					return earthDamage;
				}
			}
			if(fire) {
				int hpx = (playerWalkingRight.getTileSize/2).floor();
				if(lookingRight) {
					if(x > hsx && x < hsx+fireSprite.getTileSize()+hpx+16) {
						if(y > Y && y < Y+80) {
							return fireDamage;
						}
					}
				}
			}
		}
	}

	void activate(bool a) {
		if(!falling) {
			activated = a;
			if(activated) {
				walking = false;
			}
		}
	}

}

