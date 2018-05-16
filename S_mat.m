function S = S_mat(omega)
% omega is the column vector representing the angular velocity of the
% CubeSat in rad/s in the body fixed reference frame.
S = zeros(3,3);
S(1,1) = 0;
S(1,2) = omega(3);
S(1,3) = -omega(2);
S(2,1) = -omega(3);
S(2,2) = 0;
S(2,3) = omega(1);
S(3,1) = omega(2);
S(3,2) = -omega(1);
S(3,3) = 0;
end