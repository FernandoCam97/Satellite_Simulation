function [B_1, B_2] = getHysteresis(start_time, end_time, time_step, ...
    theta_final,theta_initial, attitude,iteration,start_iteration)
%%%%%%%%%%%%%%%%%%%%%
% In Matt's simulation, t is the array of times, so:
% start_time = t(1)
% end_time = t(i) % The i^th iteration through time
% time_step = dt
%%%%%%%
% attitude should be a column vector (3 x 1)
%% Modelling of Hysteresis Material
%% Variables and Setup
% b_1, b_2, b_3 are the unit vectors in the body fixed frame. The permanent
% magnet is positioned along b_3, and the hysteresis materials are along
% b_1 and b_2. We will assume at the beginning that the initial orientation
% of the CubSat is exactly the same as the Earth fixed reference frame.


global Field Angles_Position_Indeces Isat omega_0 S_Omega b_1 ...
    b_2 attitude_history B_hyst_history1 B_hyst_history2 H_c ...
    H_r B_m

omega = zeros(3,1); % angular velocity of CubeSat wrt body fixed frame
%% Temporary for now
%Isat = zeros(3,3);
%%
I = zeros(3,3); % Moment of inertia of satellite in kg m^2
I(1,1) = Isat(1);
I(2,2) = Isat(2);
I(3,3) = Isat(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tolerance_fix_disc = 1; % To deal with jumps in solution of diff eq.
%% Time variables for simulation
steps = floor((end_time - start_time)/time_step); % Time steps for the simulation
%fprintf('Steps Hyst = %f',steps)
%steps = iteration;
time_interval = linspace(start_time, end_time, steps); % Time interval for the simulation
%% Initializing Variables

H_1_history = zeros(1, steps); % History for differential equation
H_2_history = zeros(1, steps);
H_1_dot_history = zeros(1, steps);
H_2_dot_history = zeros(1, steps);
%attitude_history = zeros(3, steps);
B1_history = zeros(1, steps); % Magnetic field in hysteresis rod induced by earth's field
B2_history = zeros(1,steps);
H_E_dot_history = zeros(3, steps); %Earth's  magnetic field derivative at sta's height
%S_Omega = zeros(3,3,steps);
%% Angles for the orbit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
orbit_total_angles = abs(theta_final - theta_initial); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle_step = orbit_total_angles/steps; % in degrees
Angles_Position = Field(:,1);
%Angles_Position_Indeces = get_angle_index_history(Angles_Position, ...
    %tolerance_angle_find, steps, angle_step);
%% Main
for i = 1 : steps
    H_1_history(i) = b_1'*rotation_I2B(attitude)*...
        (rotation_I2E(omega_0,start_time+time_step*i)')*...
        Field(Angles_Position_Indeces(i+start_iteration),2:end)';
    H_2_history(i) = b_2'*rotation_I2B(attitude)*...
        (rotation_I2E(omega_0,start_time+time_step*i)')*...
        Field(Angles_Position_Indeces(i+start_iteration),2:end)';
end
%disp(Field(Angles_Position_Indeces(1))')
for i = 1 : steps
    if i > 1
        H_E_dot_history(:,i) = (rotation_I2B(attitude_history(:,i+start_iteration))*...
            (rotation_I2E(omega_0,start_time+time_step*i)')...
            *Field(Angles_Position_Indeces(i+start_iteration),2:end)' - ...
            rotation_I2B(attitude_history(:,i-1+start_iteration))...
            *(rotation_I2E(omega_0,start_time+time_step*(i-1))')*...
            Field(Angles_Position_Indeces(start_iteration+(i-1)),2:end)')/time_step;
    end
end

for i = 1 : steps
    n_i = i + start_iteration;
    H_1_dot_history(i) = b_1'*(-S_Omega(:,:,n_i)*rotation_I2B(attitude_history(:,n_i))...
        *rotation_I2E(omega_0,time_interval(i))' + rotation_I2B(attitude_history(:,n_i))...
        *rotation_I2Edot(time_interval(i))')*Field(Angles_Position_Indeces(n_i),2:end)' ...
        + b_1'*rotation_I2B(attitude_history(:,n_i))*rotation_I2E(omega_0,time_interval(i))...
        *H_E_dot_history(:,i);
    H_2_dot_history(i) = b_2'*(-S_Omega(:,:,n_i)*rotation_I2B(attitude_history(:,n_i))...
        *rotation_I2E(omega_0,time_interval(i))' + rotation_I2B(attitude_history(:,n_i))...
        *rotation_I2Edot(time_interval(i))')*Field(Angles_Position_Indeces(n_i),2:end)' ...
        + b_2'*rotation_I2B(attitude_history(:,n_i))*rotation_I2E(omega_0,time_interval(i))...
        *H_E_dot_history(:,i);
end
initial_condition_B1 = B_hyst_history1(start_iteration+1);
initial_condition_B2 = B_hyst_history2(start_iteration+1);
for i = 1 : steps
    B1_history(i) = solve_diffEqu_B(1, start_time, H_1_history, H_1_dot_history,...
    	i, time_step, H_c, H_r, B_m, initial_condition_B1,steps,end_time,...
        start_iteration+1);
    B2_history(i) = solve_diffEqu_B(2, start_time, H_2_history, H_2_dot_history,...
    	i, time_step, H_c, H_r, B_m, initial_condition_B2,steps,end_time,...
        start_iteration+1);
    if i > 2
        if abs(B1_history(i) - B1_history(i-1)) > tolerance_fix_disc
            B1_history(i) = B1_history(i-1) + (B1_history(i-1) - B1_history(i-2))...
                /(H_1_history(i-1) - H_1_history(i-2)); % The second part is the slope
        end
        if abs(B2_history(i) - B2_history(i-1)) > tolerance_fix_disc
            B2_history(i) = B2_history(i-1) + (B2_history(i-1) - B2_history(i-2))...
                /(H_2_history(i-1) - H_2_history(i-2)); % The second part is the slope
        end
    end
    
    %disp(i);
    %cla;
    %plot(H_1_history(1,1:i), B_history(1,1:i))
    %pause(0.1);
end
B_hyst_history1(iteration) = B1_history(end);
B_hyst_history2(iteration) = B2_history(end);
B_1 = B_hyst_history1(iteration)*b_1;
B_2 = B_hyst_history2(iteration)*b_2;
end