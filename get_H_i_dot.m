function H_i_dot = get_H_i_dot(rod, attitude, time, omega_0, omega,...
    time_step, iteration)
global Field Angles_Position_Indeces;
% Will get the derivative wrt time of H_i, the equation is:
% H_i_dot = (b_i^T)*(-(S(omega))*(R_I2B)*(R_I2E^T) + (R_I2B)*(R_I2E^T))*H_E
%           + ((b_i^T)*(R_I2B)*(R_I2E^T)*(H_E_dot)
% where H_E is the Earth's magnetic field at the height of the satellite,
H_i_dot = 0;
if rod == 1
    b_i = [1; 0; 0];
else
    b_i = [0; 1; 0];
end
R_I2B = rotation_I2B(attitude);
R_I2E = rotation_I2E(omega_0, time);
H_E_dot = get_H_E_dot(iteration, time_step);

R_I2E_dot = rotation_derivative_I2E(omega_0, time);
field = get_Field(Angles_Position_Indeces(iteration));

H_i_dot = (b_i')*(-S_mat(omega)*R_I2B*(R_I2E') + R_I2B*(R_I2E_dot'))*field ...
    + (b_i')*(R_I2B)*(R_I2E')*H_E_dot;


end