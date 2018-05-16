function M = rotation_I2Edot(time)
global omega_0
M = zeros(3,3);
M(1,1) = -omega_0*sin(omega_0*time);
M(1,2) = -omega_0*cos(omega_0*time);
M(2,1) = omega_0*cos(omega_0*time);
M(2,2) = -omega_0*sin(omega_0*time);



end