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

class Game {
	static DrawingCanvas dc = new DrawingCanvas();
	int _loadedImageCounter = 0;
	bool _gameRunning = false;
	double lastUpdated;
	double _start;
	List<String> _imagesToLoad;
	List<String> _soundsToLoad;
	Player player = new Player();
	static AudioContext audioCtx = new AudioContext();
	Level _level;

	Game() {
		_imagesToLoad = ["img/tileset.png",
		"img/player.png",
		"img/playerWalkRight.png"];
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
		window.requestAnimationFrame(mainLoop);
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
			if(delta-lastUpdated > 50) {
				dc.clear();
				lastUpdated = delta;
				_level.draw();
				player.draw();
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
			case KeyCode.S:
				break;
			case KeyCode.ENTER:
				break;
			case KeyCode.E:
				break;
			case KeyCode.ESC:
				_gameRunning = false;
				break;
		}
	}
}
