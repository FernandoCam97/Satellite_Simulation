function avg_point = fix_discontinuities(point1, point2, point3, tolerance)

avg_point = point2;

if point1 >= point3
	if point2 > point1 || point2 < point3
        avg_point = (point1 + point3)/2;
    end
else
    if point2 > point3 || point2 < point1
        avg_point = (point3 + point1)/2;
    end
end
%{
if abs(avg_point - point1) > tolerance || abs(avg_point - point3) > tolerance
    if point1 >= point3
        avg_point = 
    end
end
%}

end