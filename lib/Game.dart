library Game;

import "dart:html";
import "dart:web_audio";
import "dart:math" as math;

part "GameParameters.dart";
part "DrawingCanvas.dart";
part "ScreenCanvas.dart";
part "Angle.dart";
part "ResManager.dart";
part "Sprite.dart";
part "Level.dart";
part "Tile.dart";
part "Player.dart";
part "Bullet.dart";
part "Vector.dart";
part "Vector2f.dart";
part "UI.dart";
part "Turret.dart";

class Game {
	static DrawingCanvas dc = new DrawingCanvas();
	int _loadedImageCounter = 0;
	static bool gameRunning = false;
	double lastUpdated;
	double _start;
	List<String> _imagesToLoad;
	List<String> _soundsToLoad;
	List<Bullet> _bullets = [];
	List<Turret> _turrets = [];
	bool showMenu = false;
	static Player player = new Player();
	static AudioContext audioCtx = new AudioContext(); 
	static Level _level;

	Game() {
		_imagesToLoad = ["img/tileset.png",
		"img/player.png",
		"img/playerWalkRight.png",
		"img/playerWalkLeft.png",
		"img/water.png",
		"img/clouds.png",
		"img/rock.png",
		"img/action.png",
		"img/fire.png",
		"img/actionFireRight.png",
		"img/fireActionLeft.png",
		"img/rocket.png",
		"img/UI.png",
		"img/elements.png",
		"img/smoke.png",
		"img/menu.png",
		"img/turretcannon.png",
		"img/turret.png"];
		_soundsToLoad = ["sounds/hit.wav",
		"sounds/fire.wav",
		"sounds/action.wav",
		"sounds/ld32.wav",
		"sounds/earth.wav",
		"sounds/turret_destroyed.wav"];
		load();
		_level = new Level("level/test.map");	
		_level.load(); 

		// register events
		document.onKeyDown.listen(handleInput);
		document.onKeyUp.listen(handleRelease);
	}

	static Level getLevel() {
		return _level;
	}

	static Player getPlayer() {
		return player;
	}

	static playSound(String path) {
		AudioBufferSourceNode source = audioCtx.createBufferSource();
		source.buffer = ResManager.getSound(path);                                
		source.connectNode(audioCtx.destination, 0, 0);
		source.start(0);
	}

	static playMusic() {
		AudioBufferSourceNode source = audioCtx.createBufferSource();
		source.buffer = ResManager.getSound("sounds/ld32.wav");                                
		source.connectNode(audioCtx.destination, 0, 0);
		source.start(0);
		source.loop = true;
	}

	void load() {   
		for(String url in _soundsToLoad) {
			ResManager.loadSound(url, audioCtx);
		}   
		for(String url in _imagesToLoad) {
			ResManager.load(url, loadedImageCallback); 
		}
	}   

	void loadedImageCallback() {   
		_loadedImageCounter++;
		if(_loadedImageCounter >= _imagesToLoad.length) {
			showMenu=true;
			window.requestAnimationFrame(mainLoop);
		}   
	}

	void handleMouseUp(MouseEvent e) {
		if(e.button == 0) {
			player.activate(false);
		}
	}

	void handleMouseDown(MouseEvent e) {
		if(e.button == 0) {
			player.activate(true); 
		}
	}

	void handleMouseMove(MouseEvent e) {
		int x = e.client.x;

		Vector v2 = new Vector(ScreenCanvas.getX() + (GameParameters.screenWidth/2).floor(), ScreenCanvas.getY());

		if(x < v2.x) {
			player.lookingRight = false;
		} else {
			player.lookingRight = true;
		}
	}

	void start() {
		Player.X = 200;
		Player.Y = -10;
		player.water = false;
		player.activate(false);
		player.fire = true;
		gameRunning = true;
		playMusic();

		document.onMouseMove.listen(handleMouseMove);
		document.onMouseDown.listen(handleMouseDown);
		document.onMouseUp.listen(handleMouseUp);

		// --- INIT ---
		Angle angle = new Angle();
		angle.set(90.0);
		math.Random rnd = new math.Random();

		for(int i=-100; i < 1000; i+=100) {
			angle = new Angle();
			angle.set(rnd.nextInt(360).toDouble());
			_bullets.add(new Bullet(i,5, angle));
		}

		angle.set(10.0);
		_bullets.add(new Bullet(100,5, angle));

		_turrets.add(new Turret(532, 128));
		_turrets.add(new Turret(1256, 64));
		_turrets.add(new Turret(2024, 256));
		_turrets.add(new Turret(2152, 160));
		_turrets.add(new Turret(2696, 96));
		_turrets.add(new Turret(3080, 96));
		_turrets.add(new Turret(3880, 192));
		_turrets.add(new Turret(4040, 192));
		_turrets.add(new Turret(5320, 96));

		// --- INIT --- It's always sign of bad code to put sections like this =D
	}

	void updateBullets(double delta) {
		for(int b = 0; b < _bullets.length; b++) {
			_bullets[b].update(delta);
			if(_bullets[b].Y < 0 || _bullets[b].Y > GameParameters.screenHeight || _level.hasTileOnExactPosition(_bullets[b].X-Player.X, _bullets[b].Y) || player.isItGettingBlocked(_bullets[b].X-Player.X+(GameParameters.screenWidth/2).floor(), _bullets[b].Y)) {
				_bullets.removeAt(b);
			}
		}
	}

	void drawBullets() {
		for(Bullet b in _bullets) {
			b.draw();
		}
	}

	void updateTurrets(double delta) {
		int dead = 0;
		for(int t=0; t < _turrets.length; t++) {
			_turrets[t].update(delta);
			_turrets[t].looseEnergy(player.isGettingHurtBy(_turrets[t].X, _turrets[t].Y));
			if(_turrets[t].dead) {
				dead++;
			}
		}
		if(dead==_turrets.length) {
			showGameWin();
		}
	}

	void drawTurrets() {
		for(Turret t in _turrets) {
			t.draw();
		}
	}

	void mainLoop(double delta)
	{
		if(lastUpdated == null) {
			lastUpdated = delta;
			if(_start == null) {
				_start = delta;
			}
		} 
		if(gameRunning) {
			if(_level.hasTileOnPosition(Player.X, Player.Y)) {
				player.setFloor(true);
			} else {
				player.setFloor(false);
			}
			if(player.walking) {
				if(Player.walkingLeft) {
					if(_level.hasTileOnPosition(Player.X-Player.stepWidth, Player.Y-1)) {
						player.walking = false;
						//if(Player.Y % GameParameters.tileSize > GameParameters.tileSize/2) {
						//Player.X -= (Player.X % GameParameters.tileSize);
						//} else {
						//Player.X += (GameParameters.tileSize - (Player.X % GameParameters.tileSize));
						//}
					}
				} else {
					if(_level.hasTileOnPosition(Player.X+Player.stepWidth, Player.Y-1)) {
						player.walking = false;
						if(Player.X % GameParameters.tileSize < GameParameters.tileSize/2) {
							Player.X -= (Player.X % GameParameters.tileSize);
						} else {
							Player.X += (GameParameters.tileSize - (Player.X % GameParameters.tileSize));
						}
					}
				}
			}
			player.update(delta);
			updateBullets(delta);
			updateTurrets(delta);
			if(delta-lastUpdated > 50) {
				dc.clear();
				lastUpdated = delta;
				_level.draw();
				player.draw();
				drawTurrets();
				drawBullets();
				UI.draw();
				dc.flip();

			}
		} else {
			if(showMenu) {
				if(delta-lastUpdated > 100) {
					dc.clear();
					dc.draw(ResManager.get("img/menu.png"), 330, 10);
					player.draw();
					dc.flip();
					if(Player.X <= 5500) {
						Player.X += 5;
					}
					lastUpdated = delta;
				}
			}
		}
		if(gameRunning || showMenu) {
			window.requestAnimationFrame(mainLoop);
		}
	}

	static void showGameOver()
	{   
		gameRunning = false;
		dc.canvas.context2D
			..fillStyle = "#F00"
			..fillRect(0,0, GameParameters.screenWidth, GameParameters.screenHeight)
			..fillStyle = "#FFF"
			..font = 'italic 40pt Courier'
			..fillText("GAME OVER!", 100,100)
			..font = '20pt Courier'
			..fillText("Reload page to restart!", 100,180);
		dc.flip();
	}

	void showGameWin()
	{   
		gameRunning = false;
		dc.canvas.context2D
			..fillStyle = "#0F0"
			..fillRect(0,0, GameParameters.screenWidth, GameParameters.screenHeight)
			..fillStyle = "#FFF"
			..font = 'italic 40pt Courier'
			..fillText("You win!", 100,100)
			..font = '20pt Courier'
			..fillText("Reload page to restart!", 100,180);
		dc.flip();
	}

	void handleRelease(KeyboardEvent event) {
		int key = event.keyCode;

		switch(key) {
			case KeyCode.A:
				player.walking = false;
				break;
			case KeyCode.D:
				player.walking = false;
				break;
			case KeyCode.ENTER:
				if(showMenu) {
					showMenu = false;
					start();
				}
				break;
		}
	}

	void handleInput(KeyboardEvent event)
	{
		int key = event.keyCode;

		switch(key) {
			case KeyCode.A:
				player.walkLeft();
				break;
			case KeyCode.D:
				player.walkRight();
				break;
			case KeyCode.W:
				player.jump();
				break;
			case KeyCode.ONE:
				player.switchMode(0);
				break;
			case KeyCode.TWO:
				player.switchMode(1);
				break;
			case KeyCode.THREE:
				player.switchMode(2);
				break;
			case KeyCode.FOUR:
				player.switchMode(3);
				break;
			case KeyCode.ESC:
				gameRunning = false;
				break;
		}
	}
}
