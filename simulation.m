function [EUL,W] = simulation(eul0,t,w0,theta,res,final_time)
%SIMULATION Simulate the motion of the satellite. Includes data output and
%exportable (.mp4) animated rotation plot.
%   Many boolean values were used to turn features on or off. This is used
%   to improve functionality while maintaining run speed.
% w0 is a 1x3 vector
global steps_m Omega_Sat S_Omega attitude_history...
    omega_0 Field Isat B_hyst_history1 B_hyst_history2  M_history
%% Initializing Variables
r = length(theta); %resolution, number of data points
dt = max(t)-min(t); %time step
steps_m = length(theta);
disp(steps_m)
Omega_Sat = zeros(3,steps_m); %History of angular velocity of sat
S_Omega = zeros(3,3,steps_m);
attitude_history = zeros(3, steps_m);
%Vhyst = 95e-3*5e-3*5e-3;


omega_0 = 7.27 * 10^(-5); % Earth's constant orbital speed in rad/s
Isat = inertia(0.1,0.1,0.3,4);

plotVar=true; %to plot or not to plot, that is the options
vid=false; %save video or not to save video
%switch statement interpreting plot parameter from function input. d
%represents # of skipped frames between plot updates. Significantly
%affects run speed.
%% Setup
switch res
    case 'high'
        d=1;
    case 'video'
        d=1;
        vid=true;
    case 'med'
        d=20;
    case 'low'
        d=60;
    case 'off'
        plotVar=false;
    otherwise
        error('Invalid plot parameter. Function resolution accepts: ''off'', ''low'', ''med'', ''high'', ''video''.');
end
if plotVar
    %setup vector field matrices
    [X,Y,Z]=meshgrid(-30:20:30,-30:20:30,-30:20:30);
    O = ones(length(X),length(Y),length(Z)); %length
    %setup figure parameters
    fig=figure('Position',[0,0,1280,720]);
    lim=[-30,30];
    axis manual
    axis([lim,lim,lim]);
    view(3)
    axis equal
    hold on
end
percent=[10,30,50,70,90,95].*r./100; %define specific points to ouput progress
percent=round(percent,0); %precaution, points should always be integer values
global oldH %for dH/dt of hysteresis
oldH=0;
%Output angle and torque data to main function, if output vars exist
output=false;
if nargout ~= 0
    output=true; %turn angle storage on/off
    EUL=zeros(r,3); %angles
    W=zeros(r,3); %torque
end
%initialize videowriter
if vid
    v = VideoWriter('satellite.mp4','MPEG-4');
    open(v)
end
%output info text
fprintf('\nSimulation started....\n');
fprintf('Stats: dt=%0.2fs, frames=%0.0f, %0.0f%% orbit or %0.3f days\n',dt,r,(max(theta)/360)*100,dt*r/43200);
%warn if simulation resolution is too low to produce accurate results
if dt>2
    warning('A time step of less than 2 seconds is recommended for accurate results. Note: this number has been chosen arbitrarily.');
end
% magnetic field at each point
fprintf('\nBuilding magnetic field....');
%B=ones(r,3); %initialize matrix
%{
for i = 1:r
    [B(i,:),~,~,~,~]=wrldmagm(GEO(1,i),GEO(2,i),GEO(3,i),decyear(2017,3,23)); % BUilds magnetic field
end
%}
%B=B.*1e-9; %convert to teslas from nT
fprintf('done\n');
fprintf('Computing rotation....\n');
% %% Hysteresis Setup
% %% Hysteresis Parameters
% H_c = 1.59; % Coercivity of material in A/m
% H_r = 1.969; % Remnance of material in A/m
% B_m = 0.73; % Saturation value in Teslas
% %V_h = 7.15*10^(-8); % Volume of hysteresis rod in m^3
% %% Permanent Magnet Parameters
% B_p = 1.28; % Magnetic flux density of permanent magnet in Teslas
% V_p = 7.15*10^(-8); % Volume of permanent magnet in m^3
%% Histories
B_hyst_history1  = zeros(1,r);
B_hyst_history2  = zeros(1,r);
M_history = zeros(3,r);
% ---- Setup/initialization done ---- %

%% Simulation Loop!
for i = 1:r
    if plotVar
        if ~ishghandle(fig) %exit loop if figure window is closed
            error('Figure closed, simulation stopped.');
        end
    end
    DCM=rotate3(eul0); %direction cosine matrix
    %employ torque simulator function to get moment 
    M = torqueSim(Field(i,:),eul0,i*dt,dt, theta(1), theta(i),i);
    M_history(:,i) = M;
    %get new angle 
    [eul0,w0]=motionSim(eul0,w0,t,M);
    t=t+dt;
    if output
        EUL(i,:)=eul0;
        W(i,:)=w0;
        if i < steps_m
            Omega_Sat(:,i+1) = w0'; % Want column vector
            attitude_history(:,i+1) = eul0';
            S_Omega(:,:,i+1) = getS_Omega(w0');
        end
    end
    if plotVar && mod(i,d)==0
        %draw rotating satellite
        cla
        %plot 3D magnetic vector field
        quiver3(X,Y,Z,O*Field(i,1),O*Field(i,2),O*Field(i,3));
        hold on;
        drawSat(DCM);
        drawnow
    end
    if vid
        A=getframe(fig);
        writeVideo(v,A);
    end
    if any(percent==i)
        fprintf('%0.f%%\n',i/r*100);
    end
end
if vid
    close(v);
end
EUL=wrapTo2Pi(EUL);
end

