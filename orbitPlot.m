function orbitPlot (theta,R,vid,name)
% Takes true anomoly and plots satellite and movement.
% rev is number of revolutions
% apsis plots apoapsis and periapsis
% name parameter is name for legend. No legend if empty
global r
fig=figure(1);
[x,y,z] = sphere;
surf(r.*x,r.*y,r.*z,'FaceColor','blue');
a = 7000;
hold on;
axis equal;
xlim([-a a]);
ylim([-a a]);
zlim([-a a]);

[~,Ai] = max(sqrt(sum(R.^2)));
[~,Pi] = min(sqrt(sum(R.^2)));
p1 = plot3(R(1,:),R(2,:),R(3,:),'-k');
p2 = plot3(R(1,Ai),R(2,Ai),R(3,Ai),'m*');
plot3(R(1,Pi),R(2,Pi),R(3,Pi),'m*');
p3 = plot3(R(1,1),R(2,1),R(3,1),'.r','MarkerSize',20);
legend([p1,p2,p3],{name,'apsis','CubeSat'});
if vid
    v = VideoWriter('orbit.mp4','MPEG-4');
    open(v)
end
for i=1:length(theta)
    p3.XData = R(1,i);
    p3.YData = R(2,i);
    p3.ZData = R(3,i);
    drawnow;
    if vid
        A=getframe(fig);
        writeVideo(v,A);
    end
end
if vid
    close(v);
end
end