function [eul,w] = motionSim(eul0,w0,t,M)
%Use ode45 to solve motionODE function below
[t,w] = ode45(@(t,w) motionODE(w,M),t,w0);
intw=trapz(t,w); %Integrate results to get change in rotation angle
eul=eul0+intw; %should work over small time step, maybe...
w=[w(end,1),w(end,2),w(end,3)]; %return newest angular velocity
end

function dwdt = motionODE(w,M)
global Isat
dwdt = zeros(3,1);
%Euler's rigid body dynamics equations
dwdt(1) = (M(1)-(Isat(3)-Isat(2))*w(2)*w(3))/Isat(1);
dwdt(2) = (M(2)-(Isat(1)-Isat(3))*w(3)*w(1))/Isat(2);
dwdt(3) = (M(3)-(Isat(2)-Isat(1))*w(1)*w(2))/Isat(3);
end


