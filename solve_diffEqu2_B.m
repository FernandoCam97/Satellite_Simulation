function B_i_sol_t = solve_diffEqu2_B(rod,start_time, H_i_history,...
    H_i_dot_history, time_step, H_c, H_r, B_m,...
    initial_conditions)
global Field Angles_Position_Indeces;
% Rod is an integer to ge either rod 1 or rod 2
% start_time is the initial time of the simulation
% H_i_history is an array with the component of the Earth's magnetic field
% on the hysteresis rod, the array has length up to the current iteration
% H_i_dot_history is the derivative of the above with the same length
% iteration: is the current time for calculation

if rod == 1
    b_i = [1; 0; 0];
else
    b_i = [0; 1; 0];
end

end_time = start_time + time_step;
time_interval = linspace(start_time, end_time); % Just make 100 steps for now
%% Adjusting Histories
%H_i_history = H_i_history(1,1:iteration);
%H_i_dot_history = H_i_dot_history(1,1:iteration);


%if iteration ~= 1
%    [t, B_i_sol] = ode45(@(t,B) get_dB_dt(t, B, time_interval, H_c, H_r,...
%        B_m, H_i_history, H_i_dot_history), [start_time end_time], initial_conditions);
%else
    dB_dt = @(t,B) ((2*B_m)/(H_r*pi))*((((H_c - H_i_history(1))*cos((pi*B)...
        /(2*B_m)) + H_r*sin((pi*B)/(2*B_m)))/(2*H_c))^2)...
        * H_i_dot_history(1);
    [t, B_i_sol] = ode45(dB_dt, [start_time end_time], initial_conditions);
%end

B_i_sol_t = B_i_sol(end);
end