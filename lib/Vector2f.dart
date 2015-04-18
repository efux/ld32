part of Game;

class Vector2f {
	double x; 
	double y;
	
	Vector2f(this.x, this.y);

	operator +(Vector2f other) => new Vector2f(x + other.x, y + other.y);
	operator -(Vector2f other) => new Vector2f(x - other.x, y + other.y);
	operator *(int scalar) => new Vector2f(x * scalar, y * scalar);
	operator /(int scalar) => new Vector2f(x / scalar, y / scalar);

	double dotProduct(Vector2f other)
	{
		return x * vector.x + y * vector.y;
	}

	void rotate(Angle angle)
	{
		double new_x = x * math.cos(angle.getRadian()) - y * math.sin(angle.getRadian());
		double new_y = x * math.sin(angle.getRadian()) + y * math.cos(angle.getRadian());
		x = new_x;
		y = new_y;
	}
}
