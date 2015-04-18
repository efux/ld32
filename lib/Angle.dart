part of Game;

class Angle
{
	double _angle = 0.0;
	
	void set(double angle)
	{
		_angle = angle;
	}

	double getRadian()
	{
		return (_angle * math.PI) / 180.0;
	}

	double getAngle()
	{
		return _angle;
	}
}
