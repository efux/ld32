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
}
