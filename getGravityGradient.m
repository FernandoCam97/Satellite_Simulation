function Mg = getGravityGradient(attitude,iteration)
global Isat R mu

R0 = 7000; % Distance to Earth in km (we assume it's constant)
Mg = zeros(3,1); % Gravity gradient torque
ue = zeros(3,1); % Unit vector in nadir direction
ue = -rotation_I2B(attitude)*R(:,iteration);
ue = ue/getNorm(ue);
I = zeros(3,3); % Moment of inertia of satellite in kg m^2
I(1,1) = Isat(1);
I(2,2) = Isat(2);
I(3,3) = Isat(3);


Mg = ((3*mu)/R0^3)*cross(ue,I*ue);

end