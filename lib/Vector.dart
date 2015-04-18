part of Game;

class Vector {
	int x; 
	int y;
	
	Vector(this.x, this.y);

	operator +(Vector other) => new Vector(x + other.x, y + other.y);
	operator -(Vector other) => new Vector(x - other.x, y + other.y);
	operator *(int scalar) => new Vector(x * scalar, y * scalar);
	operator /(int scalar) => new Vector((y / scalar).round(), (y / scalar).round());

	double dotProduct(Vector other)
	{
		return x * vector.x + y * vector.y;
	}

	void rotate(Angle angle)
	{
		double new_x = x * math.cos(angle.getRadian()) - y * math.sin(angle.getRadian());
		double new_y = x * math.sin(angle.getRadian()) + y * math.cos(angle.getRadian());
		x = new_x.round();
		y = new_y.round();
	}
}
