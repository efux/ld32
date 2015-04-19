part of Game;

class ScreenCanvas
{
	static DrawingCanvas _canvas;
	
	static void setCanvas(CanvasElement canvas)
	{
		if(_canvas==null) {
			_canvas = new DrawingCanvas();
			document.body.nodes.add(_canvas.canvas);
		}
		_canvas.canvas.context2D.drawImage(canvas,0,0);
	}

	static int getX() {
		int retVal = 0;
		if(_canvas!=null) {
			Rectangle box = _canvas.canvas.getBoundingClientRect();
			retVal = box.left;
		}
		return retVal;
	} 

	static int getY() {
		int retVal = 0;
		if(_canvas!=null) {
			Rectangle box = _canvas.canvas.getBoundingClientRect();
			retVal = box.top;
		}
		return retVal;
	}
}
