function [I] = inertia(x,y,z,m)
I(1) = m*(x^2+y^2)/12;
I(2) = m*(z^2+x^2)/12;
I(3) = m*(z^2+y^2)/12;
end