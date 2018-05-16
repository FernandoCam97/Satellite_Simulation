function [M] = torqueSim(B,angle,t_i, dt, theta_initial, theta_final,iteration)
%% TORQUESIM Takes rotation matrix and position to return torque in body fixed frame
% angle is the orientation/attitude of the satellite
global  Vhyst omega_0 Omega_Sat ...
     S_Omega %Import global constants
global Field Angles_Position_Indeces ...
    B_hyst_history1 B_hyst_history2 
%% TESTING
% steps_m = floor(100/dt);
% Omega_Sat = zeros(3,steps_m);
% S_Omega = zeros(3,3,steps_m);
% Vhyst = 95e-3*5e-3*5e-3;
% b_1 = [1; 0; 0]; % Hysteresis 1 along here
% b_2 = [0; 1; 0]; % Hysteresis 2 along here
% b_3 = [0; 0; 1]; % Permanent Magnet along here
% load('B_1000.csv');
% Field = B_1000;
% attitude_history = zeros(3, steps_m); % WE HAVE TO UPDATE THIS TO HAVE ACTUAL ATTITUDE 
%%%%%%%%%%%%GET RID OF THESE AFTERWARDS, WE NEED THESE TO BE AT THE
%%%%%%%%%%%%APPROPRIATE STEPS!!!!!!!!!!!!!!!!!!!!!
%%
%disp(S_Omega)
S_Omega(:,:,iteration) = getS_Omega(Omega_Sat(:,iteration)); % We're going to have to feed
                                            % the current angular velocity
                                            % of the cubesat to fill up the
                                            % matrix with the history of
                                            % the angular velocities matrix
%%

% u0=(4*pi)*1e-7; %permittivity of free space
% DCM=rotate3(angle);
% B=B*DCM; %rotate magnetic field vector to sat coordinate system
% H=B/u0; %magnetic flux density body-fixed reference frame

%Creates lag effect produced by magnetic hsyteresis. Based on Flatley and
%Henretty. If dH/dt < 0, +Hc used, if dH/dt > 0, -Hc used.
%a=double(H<oldH); %setup logoical comparator
%a(a==0)=-1; %transorm to -1 for false
%hysteresis loop model, rhombus shaped hysteresis loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Get Hysteresis
attitude = angle'; % We need a column vector
[B_hyst1, B_hyst2] = getHysteresis(0, t_i+dt, dt, theta_final, ...
    theta_initial, attitude,iteration);
% 1st input is starting time (we will alsways have this as 0 so that we 
% can integrate accuratele)
% 2nd input is the current time we need the field at
% 3rd input is time step
% 4th input is final angle of (i.e. the angle of the orbit at time t_i)
% 5th input is initial angle
% 6th input is the current attitude as a column vector.
R_I2B = rotation_I2B(attitude);
R_I2E = rotation_I2E(omega_0,t_i);
angle_index = Angles_Position_Indeces(end);

M_1 = cross(B_hyst1*Vhyst,R_I2B*(R_I2E')*(Field(angle_index, 2:end)'));
M_2 = cross(B_hyst2*Vhyst,R_I2B*(R_I2E')*(Field(angle_index, 2:end)'));
%M1 = cross(B_hyst1*Vhyst, 
%Bhyst=(2/pi)*Bs*atan(p*(H+a.*Hc));
%mhyst=((Bhyst*Vhyst)/u0).*uhyst; %unit vector attributes rod placement
%m=mhyst+msat; %combine the magnetic moments
%M=cross(m,B);
%oldH = H(3); %store previous external H, used for dH/dt
%M = [0.00001,0.00001,0.00001];
M_g = getGravityGradient(attitude,iteration); 
M = M_1+M_2+M_g;
end

