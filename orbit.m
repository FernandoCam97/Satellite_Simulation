function [R,V,Rmag,Vmag] = orbit(h,i,RAAN,e,omega,theta,mu)
% Keplerian element to cartesian coordiante transformation
% Components of the state vector of a body relative to its perifocal
% reference
rx = h^2./mu.*(1./(1 + e.*cosd(theta))).*[cosd(theta);sind(theta);zeros(1,length(theta))];
vx = mu/h.*[-sind(theta); (e +cosd(theta));zeros(1,length(theta))];
% Direction cosine matrix
QXx = [cosd(omega), sind(omega),0;-sind(omega),cosd(omega),0;0,0,1]*...
    [1,0,0;0,cosd(i),sind(i);0,-sind(i),cosd(i)]*...
    [cosd(RAAN), sind(RAAN),0;-sind(RAAN),cosd(RAAN),0;0,0,1];
% Transformation Matrix
QxX = inv(QXx);
% Geocentric equatorial position vector R
R = QxX*rx;
Rmag = sqrt(sum(R.^2));
% Geocentric equatorial velocity vector V
V = QxX*vx;
Vmag = sqrt(sum(V.^2));

end