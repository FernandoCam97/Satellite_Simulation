function matrix = rotation_derivative_I2E(omega_0, t)
% omega_0 is the Earth's orbital speed, and t is the time in seconds
% This assumes that the Earth Inertial and the Earth Fixed are the same at
% time t_0 = 0
matrix = zeros(3,3);
matrix(1,1) = -omega_0*sin(omega_0*t);
matrix(1,2) = -omega_0*cos(omega_0*t);
matrix(1,3) = 0;
matrix(2,1) = omega_0*cos(omega_0*t);
matrix(2,2) = -omega_0*sin(omega_0*t);
matrix(2,3) = 0;
matrix(3,1) = 0;
matrix(3,2) = 0;
matrix(3,3) = 0;
end