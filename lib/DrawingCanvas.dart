part of Game;

class DrawingCanvas
{
	CanvasElement canvas;
	CanvasRenderingContext2D _ctx;
	CanvasElement tileCanvas;

	DrawingCanvas()
	{
		canvas = new Element.tag("canvas");
		tileCanvas = new CanvasElement(width: GameParameters.tileSize, height: GameParameters.tileSize);
		canvas.width = GameParameters.screenWidth;
		canvas.height = GameParameters.screenHeight;
		_ctx = canvas.context2D;
	}

	void flip()
	{
		ScreenCanvas.setCanvas(canvas);	
	}

	void draw(ImageElement img, int x, int y)
	{
		_ctx.drawImage(img, x, y);
	}

	void drawTile(ImageElement img, int x, int y, int tilePos) {
		tilePos--;
		if(tilePos >= 0) {
			tileCanvas.width = tileCanvas.width;
			int ytile = (tilePos / (img.width/GameParameters.tileSize)).floor();
			int xtile = tilePos % (img.width/GameParameters.tileSize).floor();
			tileCanvas.context2D.drawImage(img, 0 - (GameParameters.tileSize*xtile), 0 - (GameParameters.tileSize*ytile));
			drawScaled(tileCanvas, x, y, GameParameters.tileSize, GameParameters.tileSize, new Angle());
		}
	}

	void drawScaled(CanvasElement img, int x, int y, int dwidth, int dheight, Angle angle)
	{
		_ctx.translate(x, y);
		_ctx.translate(img.width/2, img.height/2);
		_ctx.rotate(angle.getRadian());
		_ctx.drawImageScaled(img, -img.width/2, -img.height/2, dwidth, dheight);
		_ctx.rotate(-angle.getRadian());
		_ctx.translate(-img.width/2, -img.height/2);
		_ctx.translate(-x,-y);
	}

	void clear()
	{
		draw(ResManager.get("img/clouds.png"), 0-(Player.X/10).floor(),0);
	}
}
