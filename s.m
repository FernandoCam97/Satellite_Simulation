function [M] = torqueSim(B,angle,t_i, dt, theta_initial, theta_final)
%TORQUESIM Takes rotation matrix and position to return torque in body fixed frame
% angle is the orientation/attitude of the satellite
global msat p Bs Hc Vhyst uhyst Isat%Import global constants
global oldH
u0=(4*pi)*1e-7; %permittivity of free space
DCM=rotate3(angle);
B=B*DCM; %rotate magnetic field vector to sat coordinate system
H=B/u0; %magnetic flux density body-fixed reference frame

%Creates lag effect produced by magnetic hsyteresis. Based on Flatley and
%Henretty. If dH/dt < 0, +Hc used, if dH/dt > 0, -Hc used.
%a=double(H<oldH); %setup logoical comparator
%a(a==0)=-1; %transorm to -1 for false
%hysteresis loop model, rhombus shaped hysteresis loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Get Hysteresis
attitude = angle'; % We need a column vector
[B_hyst1 B_hyst2] = getHysteresis(0, t_i, dt, theta_final, theta_initial, attitude);
% 1st input is starting time (we will alsways have this as 0 so that we 
% can integrate accuratele)
% 2nd input is the current time we need the field at
% 3rd input is time step
% 4th input is final angle of (i.e. the angle of the orbit at time t_i)
% 5th input is initial angle
% 6th input is the current attitude as a column vector.







%{
Bhyst=(2/pi)*Bs*atan(p*(H+a.*Hc));
mhyst=((Bhyst*Vhyst)/u0).*uhyst; %unit vector attributes rod placement
m=mhyst+msat; %combine the magnetic moments
M=cross(m,B);
oldH = H(3); %store previous external H, used for dH/dt
%}
end

