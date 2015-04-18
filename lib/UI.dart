part of Game;

class UI {

	static void draw() {
		Game.dc.canvas.context2D
			..fillStyle = "#000"
			..fillRect(0,GameParameters.screenHeight-25, GameParameters.screenWidth, 25)
			..fillStyle = "#00F"
			..fillRect(0,GameParameters.screenHeight-25, Player.mana*GameParameters.screenWidth/Player.maxMana, 25);
	}
}
