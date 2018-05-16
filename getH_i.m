function H_i = getH_i(rod, attitude, time, omega_0,...
    iteration)
global Field Angles_Position_Indeces;
% Rod can either be 1 or 2.
% attitude is a 3 x 1 vectors with roll, pitch, then yaw
% time is the time at which this measurement is taken
% field, denoted H_E is a 3 x 1 vector with the magnetic field at the
% height of the
% satellite
% omega_0 is the orbital speed of the Earth in m/s

% Equation for H_i:
% H_i = (b_i^T)*(R_I2B)*(R_I2E^T)*H_E, where ^T is the transpose


if rod == 1
    b_i = [1; 0; 0];
else
    b_i = [0; 1; 0];
end

field = get_Field(Angles_Position_Indeces(iteration));
R_I2E = rotation_I2E(omega_0, time);
R_I2B = rotation_I2B(attitude);

H_i = (b_i')*(R_I2B)*(R_I2E')*field;
end