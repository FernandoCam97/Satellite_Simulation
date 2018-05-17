final_step = 2871;
omega_0 = 7.27 * 10^(-5);
dt = 1.2864;
Vhyst = 95e-3*5e-3*5e-3;
b_1 = [1;0;0];
b_2 = [0;1;0];
b_3 = [0;0;1];
M_1H = zeros(3,final_step);
M_2H = zeros(3,final_step);
M_3H = zeros(3,final_step);
M_GH = zeros(3,final_step);
for j = 1 : final_step
R_I2B = rotation_I2B(attitude_history(:,j));
R_I2E = rotation_I2E(omega_0,(j-1)*dt);
angle_index = Angles_Position_Indeces(j);

M_1H(:,j) = cross(B_hyst_history1(j)*b_1*Vhyst,R_I2B*(R_I2E')*(Field(angle_index, 2:end)'));
M_2H(:,j) = cross(B_hyst_history2(j)*b_2*Vhyst,R_I2B*(R_I2E')*(Field(angle_index, 2:end)'));
M_3H(:,j) = cross(B_p*V_p*b_3,R_I2B*(R_I2E')*(Field(angle_index, 2:end)')); % Permanent magnet
%M1 = cross(B_hyst1*Vhyst, 
%Bhyst=(2/pi)*Bs*atan(p*(H+a.*Hc));
%mhyst=((Bhyst*Vhyst)/u0).*uhyst; %unit vector attributes rod placement
%m=mhyst+msat; %combine the magnetic moments
%M=cross(m,B);
%oldH = H(3); %store previous external H, used for dH/dt
%M = [0.00001,0.00001,0.00001];
M_GH(:,j) = getGravityGradient(attitude_history(:,j),j); 
end