function S = getS_Omega(omega)
S = zeros(3,3);
S(1,2) = omega(3);
S(1,3) = -omega(2);
S(2,1) = -omega(3);
S(2,3) = omega(1);
S(3,1) = omega(2);
S(3,1) = -omega(1);
end