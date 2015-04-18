part of Game;

class Sprite
{
	ImageElement _baseImg;
	int _tileSize = 32;
	int _frame = 0;
	int _zoom = 0;
	bool _run = true;

	Sprite(ImageElement img)
	{
		_baseImg = img;
	}

	void draw(DrawingCanvas c, x, y, angle)
	{
		CanvasElement canvas = new CanvasElement(width: _tileSize, height: _tileSize);
		canvas.context2D.drawImage(_baseImg, 0 - (_tileSize*_frame), 0);
		c.drawScaled(canvas, x, y, canvas.width + _zoom, canvas.height + _zoom, angle);
	}

	void setTileSize(int tileSize)
	{
		_tileSize = tileSize;
	}

	void step()
	{
		if(_run) {
			_frame = (_frame + 1) % (_baseImg.width/_tileSize).round();
		} else {
			_frame = 5;
		}
	}

	int getFrame() {
		return _frame;
	}

	void setZoom(double zoomPercent)
	{
		_zoom = zoomPercent.round();
	}

	void runAnimation(bool run) 
	{
		this._run = run;
	}
}
