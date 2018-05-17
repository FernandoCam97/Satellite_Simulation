final_step = 2871;
figure(1)
plot(theta(1:2871),attitude_history(1,1:final_step),...
    theta(1:2871),attitude_history(2,1:final_step), ...
    theta(1:2871),attitude_history(3,1:final_step))
title('Attitude History')
legend('\phi','\theta','\psi')
xlabel('Orbit Angle [deg]')
ylabel('Attitude [deg]')
figure(2)
plot(theta(1:2871),attitude_history(1,1:final_step))
title('Attitude History, Close up of \theta')
xlabel('Orbit Angle [deg]')
ylabel('Attitude [deg]')
figure(3)
plot(theta(1:2871),B_hyst_history1(1:final_step),...
    theta(1:2871),B_hyst_history2(1:final_step))
title('Hysteresis Field')
xlabel('Orbit Angle [deg]')
ylabel('Magnetic Field [T]')
legend('Rod 1', 'Rod 2')
figure(4)
plot(theta(1:2871),M_history(1,1:final_step),...
    theta(1:2871),M_history(2,1:final_step),...
    theta(1:2871),M_history(3,1:final_step))
xlabel('Orbit Angle [deg]')
ylabel('Torque [N\cdot m]')
title('Torque History')
legend('M_x','M_y','M_z')
figure(5)
plot(theta(1:2871),M_1H(1,1:final_step),...
    theta(1:2871),M_1H(2,1:final_step),...
    theta(1:2871),M_1H(3,1:final_step))
xlabel('Orbit Angle [deg]')
ylabel('Torque [N\cdot m]')
title('Torque History of Hysteresis Rod 1 (1,0,0)')
legend('M_x','M_y','M_z')
figure(6)
plot(theta(1:2871),M_2H(1,1:final_step),...
    theta(1:2871),M_2H(2,1:final_step),...
    theta(1:2871),M_2H(3,1:final_step))
xlabel('Orbit Angle [deg]')
ylabel('Torque [N\cdot m]')
title('Torque History of Hysteresis Rod 2 (0,1,0)')
legend('M_x','M_y','M_z')
figure(7)
plot(theta(1:2871),M_3H(1,1:final_step),...
    theta(1:2871),M_3H(2,1:final_step),...
    theta(1:2871),M_3H(3,1:final_step))
xlabel('Orbit Angle [deg]')
ylabel('Torque [N\cdot m]')
title('Torque History of Permanent Magnet (0,0,1)')
legend('M_x','M_y','M_z')
figure(8)
plot(theta(1:2871),M_GH(1,1:final_step),...
    theta(1:2871),M_GH(2,1:final_step),...
    theta(1:2871),M_GH(3,1:final_step))
xlabel('Orbit Angle [deg]')
ylabel('Torque [N\cdot m]')
title('Torque History due to Gravity Gradient')
legend('M_x','M_y','M_z')