function drawSat(R)
% Plot basic CAD, units in cm
s = [10 10 30];
o = [0 0 0];

rectPrism(R,o,s,'red'); %edge1
hold on
a=[o-s-1;o+s+1];
ax(:,:,1)=[[a(1,1),0,0];
    [0,a(1,2),0];
    [0,0,a(1,3)]]*R;
ax(:,:,2)=[[a(2,1),0,0];
    [0,a(2,2),0];
    [0,0,a(2,3)]]*R;
for i=1:3
    v=[[ax(i,1,1),ax(i,1,2)];[ax(i,2,1),ax(i,2,2)];[ax(i,3,1),ax(i,3,2)]];
    line(v(1,:),v(2,:),v(3,:),'Color','black');
end
end

function rectPrism(R,o,s,colour)
f=[1 2 3 4];
s=s./2;
%bottom
v=[ o(1)-s(1), o(2)-s(2), o(3)-s(3);
    o(1)+s(1), o(2)-s(2), o(3)-s(3);
    o(1)+s(1), o(2)+s(2), o(3)-s(3);
    o(1)-s(1), o(2)+s(2), o(3)-s(3);];
patch('Faces',f,'Vertices',v*R,'FaceColor',colour);
%top
v(:,3)=-v(:,3);
patch('Faces',f,'Vertices',v*R,'FaceColor',colour);
%front
v=[ o(1)-s(1), o(2)+s(2), o(3)-s(3);
    o(1)+s(1), o(2)+s(2), o(3)-s(3);
    o(1)+s(1), o(2)+s(2), o(3)+s(3);
    o(1)-s(1), o(2)+s(2), o(3)+s(3);];
patch('Faces',f,'Vertices',v*R,'FaceColor',colour);
%back
v(:,2)=-v(:,2);
patch('Faces',f,'Vertices',v*R,'FaceColor',colour);
%side1
v=[ o(1)-s(1), o(2)-s(2), o(3)-s(3);
    o(1)-s(1), o(2)+s(2), o(3)-s(3);
    o(1)-s(1), o(2)+s(2), o(3)+s(3);
    o(1)-s(1), o(2)-s(2), o(3)+s(3);];
patch('Faces',f,'Vertices',v*R,'FaceColor',colour);
%side2
v(:,1)=-v(:,1);
patch('Faces',f,'Vertices',v*R,'FaceColor',colour);
end

