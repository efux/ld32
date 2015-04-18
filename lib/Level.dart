part of Game;

class Level
{
	String _name;
	ImageElement _c;
	List<List<Tile>> _map = [];

	Level(String name)
	{
		_name = name;
	}

	void load() {
		String tmxBody = ResManager.loadLevel(_name, mapLoaded);
	}

	void mapLoaded(tmxBody) {
		List<String> rows = tmxBody.split("\n");
		for(String rowString in rows) {
			if(rowString != "") {
				List<Tile> row = [];
				List<String> stringColumn = rowString.split(",");
				for(String content in stringColumn) {
					if(content!="") {
						row.add(new Tile(int.parse(content)));
					}
				}
				_map.add(row);

			}
		}

		// transpond matrix
		List<List<Tile>> transponded = [];
		for(int j = 0; j < _map[0].length; j++) {
			List<Tile> column = [];
			for(int i = 0; i < _map.length; i++) {
				column.add(_map[i][j]);
			}
			transponded.add(column);
		}
		_map = transponded;
	}

	bool hasTileOnPosition(int x, int y) {
		x = ((x+GameParameters.screenWidth/2)/GameParameters.tileSize).floor();
		y = (y/GameParameters.tileSize).floor();

		if(y < 0) {
			return false;
		}

		if(_map[x][y+1].tileId != 0) {
			return true;
		}
		if(_map[x+1][y+1].tileId != 0) {
			return true;
		}

		return false;
	}

	bool hasTileOnExactPosition(int x, int y) {
		x = ((Player.X+x+GameParameters.screenWidth/2)/GameParameters.tileSize).floor();
		y = (y/GameParameters.tileSize).floor();

		if(_map[x][y].tileId != 0) {
			return true;
		}
		return false;
	}


	void draw() {
		int xstart = ((Player.X - (GameParameters.screenWidth/GameParameters.tileSize)/2) / GameParameters.tileSize ).floor();
		int xend = ((GameParameters.screenWidth + GameParameters.tileSize) / GameParameters.tileSize).floor();
		xend += xstart;

		if(xstart < 0) {
			xstart = 0;
		}
		if(xend >= _map.length) {
			xend = _map.length-1;
		}

		for(int x = xstart; x <= xend; x++) {
			List<Tile> tiles = _map[x];
			for(int y=0; y < tiles.length; y++) {
				Tile tile = tiles[y];
				int yp = y * GameParameters.tileSize;
				int xp = (x * GameParameters.tileSize) - Player.X;
				Game.dc.drawTile(ResManager.get("img/tileset.png"),xp,yp, tile.tileId);
			}
		}
	}
}
