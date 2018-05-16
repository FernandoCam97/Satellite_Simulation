function dB_dt = get_dB_dt(t, B, time_interval, H_c, H_r, B_m,...
    H_i_history, H_i_dot_history)
global Field Angles_Position_Indeces;
% t is the time to be evaluated at
% B is the field 
% Note that is to be used for a symbolic function to be solved by ode45

dB_dt = 0;
H_i = interp1(time_interval, H_i_history, t);
H_i_dot = interp1(time_interval, H_i_dot_history, t);

if H_i_dot <= 0
    dB_dt = ((2*B_m)/(H_r*pi))*((((H_c - H_i)*cos((pi*B)/(2*B_m)) + ...
        H_r*sin((pi*B)/(2*B_m)))/(2*H_c))^2) * H_i_dot;
else
    dB_dt = ((2*B_m)/(H_r*pi))*((((H_c + H_i)*cos((pi*B)/(2*B_m)) - ...
        H_r*sin((pi*B)/(2*B_m)))/(2*H_c))^2) * H_i_dot;
end

end