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

class Game {
	static DrawingCanvas dc = new DrawingCanvas();
	int _loadedImageCounter = 0;
	bool _gameRunning = false;
	double lastUpdated;
	double _start;
	List<String> _imagesToLoad;
	List<String> _soundsToLoad;
	List<Bullet> _bullets = [];
	Player player = new Player();
	static AudioContext audioCtx = new AudioContext(); Level _level;

	Game() {
		_imagesToLoad = ["img/tileset.png",
		"img/player.png",
		"img/playerWalkRight.png",
		"img/water.png"];
		_soundsToLoad = [];
		load();
		_level = new Level("level/test.map");	
		_level.load();

		// register events
		document.onKeyDown.listen(handleInput);
		document.onKeyUp.listen(handleRelease);
	}

	void load() {   
		for(String url in _imagesToLoad) {
			ResManager.load(url, loadedImageCallback);

		}   
		for(String url in _soundsToLoad) {
			ResManager.loadSound(url, audioCtx);

		}   
	}   

	void loadedImageCallback() {   
		_loadedImageCounter++;
		if(_loadedImageCounter >= _imagesToLoad.length) {
			start();

		}   
	}

	void start() {
		_gameRunning = true;
		Angle angle = new Angle();
		angle.set(90.0);
		math.Random rnd = new math.Random();
		
		for(int i=-100; i < 1000; i+=20) {
			angle = new Angle();
			angle.set(rnd.nextInt(360).toDouble());
			_bullets.add(new Bullet(i,5, angle));
		}
		
		angle.set(10.0);
		_bullets.add(new Bullet(100,5, angle));
		window.requestAnimationFrame(mainLoop);
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

	void mainLoop(double delta)
	{
		if(_gameRunning) {
			if(lastUpdated == null) {
				lastUpdated = delta;
				if(_start == null) {
					_start = delta;
				}
			} 
			if(_level.hasTileOnPosition(Player.X, Player.Y+Player.playerHeight)) {
				player.setFloor(true);
			} else {
				player.setFloor(false);
			}
			if(player.walking) {
				if(Player.walkingLeft) {
					if(_level.hasTileOnPosition(Player.X-Player.stepWidth, Player.Y-1)) {
						player.walking = false;
						//if(Player.Y % GameParameters.tileSize > GameParameters.tileSize/2) {
							Player.X -= (Player.X % GameParameters.tileSize);
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
			if(delta-lastUpdated > 50) {
				dc.clear();
				lastUpdated = delta;
				_level.draw();
				player.draw();
				drawBullets();
				UI.draw();
				dc.flip();


			}
			window.requestAnimationFrame(mainLoop);

		}
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
				_gameRunning = false;
				break;
		}
	}
}
