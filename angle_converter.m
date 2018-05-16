function angle = angle_converter(angle, type)
% Converts to angles in (-pi, pi]
% Type 1 is in radians
% Type 2 is in degrees
if type == 1
    angle_max = pi;
else
    angle_max = 180;
end

angle = mod(angle + angle_max, 2*angle_max) - angle_max;
if angle == -angle_max
    angle = angle_max;
end
end