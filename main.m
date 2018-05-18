clear
clc
%% Satellite Specifications
% Define global satellite constants to be used by multiple functions
global Isat msat r Field R mu B_hyst_history1 B_hyst_history2 M_history ...
    attitude_history b_1 b_2 b_3 Angles_Position_Indeces
M_history = 0;
B_hyst_history1 = 0;
B_hyst_history2 = 0;
attitude_history = 0;
Angles_Position_Indeces = 0;

Isat = inertia(0.1,0.1,0.3,4);
%load('B_1000.csv');
%Field = B_1000;
msat=[1,0,0]*0.3; %magnetic moment for permanent magnets Am^2
r = 6371; %radius of Earth in km
% hystersis rod specs
global Vhyst uhyst H_c H_r B_m B_p V_p
uhyst=[0,1,1]; %hysteresis rod unit vectors
%% Hysteresis Setup
%% Hysteresis Parameters
H_c = 1.59; % Coercivity of material in A/m
H_r = 1.969; % Remnance of material in A/m
B_m = 0.73; % Saturation value in Teslas
Vhyst = 95e-3*5e-3*5e-3; %rod volume in m
%% Permanent Magnet Parameters
B_p = 1.28; % Magnetic flux density of permanent magnet in Teslas
V_p = 7.15*10^(-8); % Volume of permanent magnet in m^3
%% Magnet Orientations
b_1 = [1; 0; 0]; % Hysteresis 1 along here
b_2 = [0; 1; 0]; % Hysteresis 2 along here
b_3 = [0; 0; 1]; % Permanent Magnet along here
%%
% Hc=12; %Coercive force, A/m 
% Br=0.004; %remanence, T
% Bs=0.025; %saturation induction, T
% p=(1/Hc)*tan((pi*Br)/(2*Bs)); %constant from Flatley and Henretty

%% Keplerian Elements
% Parameters for ISS Orbit
mu = 398600;       % Earth’s gravitational parameter [km^3/s^2]
h    = 7.67*(405+r);   % [km^2/s] Specific angular momentum
i    = 51.64;      % [deg] Inclination
RAAN = 194.78;     % [deg] Right ascension (RA) of the ascending node
e    = 0.0007;     % Eccentricity
omega = 255.33;    % [deg] Argument of periapsis
%% Orbit Specification
n=[2,10]; % resolution modifier n(1) is the # of orbits, and n(2) is the points per degree
theta = linspace(0,n(1)*360,n(1)*360*n(2));   % [deg] True anomaly, controls sim resolution and length
% ensure practicality
if length(theta)>1000000
    error('The array length is greater than 1,000,000. Are you trying to melt your computer?');
end
%% Setup Orbit
[R,~,Rmag,~] = orbit(h,i,RAAN,e,omega,theta,mu); %return the x,y,z components of the orbit path
%orbitPlot(theta,R,true,'ISS'); %show orbit!
[A,Ai] = max(Rmag); %apoapsis and index
[~,Pi] = min(Rmag); %periapsis and index


T=2*pi*sqrt((A^3)/mu); %period of orbit (time)


fprintf('Apoapsis: %3.2f km\nPeriapsis: %3.2f km\n',Rmag(Ai),Rmag(Pi));
GEO = cart2geo(R(1,:),R(2,:),R(3,:)); %convert from ECEF cartesian to GCS
clear R
%% Simulation
% Initial Conditions
theta = mod(theta,360); % To keep it to 360
dt = (T*(max(theta)/360))/length(theta); %timestep
t=[0,dt]; %time range for ODE solver


eul0=[0,0,0]; %initial angle in rad
w0=[0,0,0]*0.001; %initial rotation in rad/s
% Run simulation function: requires orbit path & initial conditions
final_time = n(1)*T/3600;
[EUL,W]=simulation(GEO,eul0,t,w0,theta,'off',final_time);
%plot angular velocity and angle wrt. time
figure
t=linspace(0,n(1)*T/3600,length(theta));
plot([t',t',t'],EUL);
title('Angle about XYZ axis in ECEF Frame');
xlabel('Time [hours]');
ylabel('Normalized Angle [rad]');
legend('\Omega_x','\Omega_y','\Omega_z');
figure
plot([t',t',t'],W);
title('Angular Velocity about XYZ axis');
xlabel('Time [hours]');
legend('\omega_x','\omega_y','\omega_z');
fprintf('done :)\n');

%% Saving Data
save('attitude_history.mat','attitude_history');
save('B_hyst_history1.mat','B_hyst_history1');
save('B_hyst_history2.mat','B_hyst_history2');
save('M_history.mat','M_history');
