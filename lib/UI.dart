part of Game;

class UI {
	static Sprite elements = new Sprite(ResManager.get("img/elements.png"));
	static ImageElement ui = ResManager.get("img/UI.png");

	static void draw() {

		elements.setZoom(10.0);
		int dx = GameParameters.screenWidth-ui.width;
		int dy = GameParameters.screenHeight-ui.height;
		Game.dc.draw(ui, dx, dy);
		elements.setFrame(Player.oldMode);
		elements.draw(Game.dc, dx + 28, dy+17, new Angle());
		Game.dc.canvas.context2D
			..fillStyle = "#E44"
			..fillRect(dx + 76,GameParameters.screenHeight-49, Player.energy*164/Player.maxEnergy, 7)
			..fillStyle = "#F00"
			..fillRect(dx + 76,GameParameters.screenHeight-49, Player.energy*158/(Player.maxEnergy), 3);
		Game.dc.canvas.context2D
			..fillStyle = "#44E"
			..fillRect(dx+76,GameParameters.screenHeight-31, Player.mana*164/Player.maxMana, 7)
			..fillStyle = "#00F"
			..fillRect(dx + 76,GameParameters.screenHeight-31, Player.mana*158/(Player.maxMana), 3);
	}
}
