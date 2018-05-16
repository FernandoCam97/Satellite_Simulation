function [R] = rotate3(w)
Rx=[1 0 0;
    0 cos(w(1)) -sin(w(1));
    0 sin(w(1)) cos(w(1))];
Ry=[cos(w(2)) 0 sin(w(2));
    0 1 0;
    -sin(w(2)) 0 cos(w(2))];
Rz=[cos(w(3)) -sin(w(3)) 0;
    sin(w(3)) cos(w(3)) 0;
    0 0 1];
R=Rz*Ry*Rx;
end

