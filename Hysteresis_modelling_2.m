clear all
%% Modelling of Hysteresis Material
%% Variables and Setup
% b_1, b_2, b_3 are the unit vectors in the body fixed frame. The permanent
% magnet is positioned along b_3, and the hysteresis materials are along
% b_1 and b_2. We will assume at the beginning that the initial orientation
% of the CubSat is exactly the same as the Earth fixed reference frame.
%field = [1;1;1]; % This will be the Earth's magnetic field vector in the
                   % Earht fixed frame. This value is just constant for
                   % now.   
global Field Angles_Position_Indeces;
%load('B_1000.csv');
%Field = B_1000;
[Field tolerance_angle_find] = generate_test_field(1000,2);
%tolerance_angle_find = abs(Field(2,1) - Field(1,1));
b_1 = [1; 0; 0]; % Hysteresis 1 along here
b_2 = [0; 1; 0]; % Hysteresis 2 along here
b_3 = [0; 0; 1]; % Permanent Magnet along here
omega_0 = 7.27 * 10^(-5); % Earth's constant orbital speed in rad/s
height = 650*10^3; % Height of satellite in m
Earth_Radius = 6378*10^3; % Radius of earth in meters
omega = zeros(3,1); % angular velocity of CubeSat wrt body fixed frame
attitude = zeros(3,1); % Attitude in terms of roll pitch and yaw (phi, theta, psi)
H_1 = 0; % Component of Earth's magnetic field in direction of first hysteresis rod (longitudinally)
H_2 = 0; %These are in terms of the body frame
I = zeros(3,3); % Moment of inertia of satellite in kg m^2
I(1,1) = 2.91058*10^(-2);
I(2,2) = 2.91058*10^(-2);
I(3,3) = 0.59261*10^(-2);
angular_position = 10; % Value in degrees
%% Time variables for simulation
start_time = 0;
end_time = 1000; % in seconds
time_step = 1; % Length of time step in seconds
steps = (end_time - start_time)/time_step; % Time steps for the simulation
time_interval = linspace(start_time, end_time, steps); % Time interval for the simulation
%% Initializing Variables
H_1_history = zeros(1, steps); % History for differential equation
H_2_history = zeros(1, steps);
H_1_dot_history = zeros(1, steps);
H_2_dot_history = zeros(1, steps);
attitude_history = zeros(3, steps);
B_history = zeros(1, steps);
H_E_dot_history = zeros(3, steps);
%% Angles for the orbit
orbit_total_angles = 10; 
angle_step = orbit_total_angles/steps; % in degrees
Angles_Position = Field(:,1);
Angles_Position_Indeces = get_angle_index_history(Angles_Position, ...
    tolerance_angle_find, steps);
%% Hysteresis Parameters
H_c = 1.59; % Coercivity of material in A/m
H_r = 1.969; % Remnance of material in A/m
B_m = 0.73; % Saturation value in Teslas
V_h = 7.15*10^(-8); % Volume of hysteresis rod in m^3
%% Permanent Magnet Parameters
B_p = 1.28; % Magnetic flux density of permanent magnet in Teslas
V_p = 7.15*10^(-8); % Volume of permanent magnet in m^3

%% Some testing
hi_1 = linspace(0,4*pi,steps);
H_1_history = 10.*sin(hi_1);
for i = 2 : steps
    H_1_dot_history(i) = (H_1_history(i) - H_1_history(i-1))/time_step;
end
initial_condition_B = 0;
start_time = 0;
%tolerance_angle_find = 0.001;
for i = 1 : steps
    if i > 1
        initial_condition_B = B_history(i-1);
        start_time = time_interval(i-1);
    end
    %H_1_history(i) = getH_i(1, attitude, time_interval(i), omega_0, i);
    %H_1_dot_history(i) = get_H_i_dot(1, attitude, time_interval(i), ...
    %    omega_0, omega, time_step, i);
    B_history(i) = solve_diffEqu2_B(1, time_interval(i), H_1_history(i), H_1_dot_history(i),...
        time_step, H_c, H_r, B_m, initial_condition_B);
    %H_2_history(i) = getH_i(2, attitude, time_interval(i), omega_0, angular_position_index);
    %H_E_dot_history(:,i) = get_H_E_dot(i, time_step);
    disp(i);
    plot(H_1_history(1,1:i), B_history(1,1:i))
    pause(0.1);
end
%H_1 = getH_i(1, attitude, 1, omega_0, angular_position);
%H_1_dot = get_H_i_dot(1,attitude,1,omega_0,omega, time_step,...
    %angular_position_index);
