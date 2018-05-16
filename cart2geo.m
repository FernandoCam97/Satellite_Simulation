function [GEO] = cart2geo(x,y,z)
%Convert orbit cartesian parameters to polar for use in world magnetic
%field map. Compatible with vectors or scalars.
% WGS84 ellipsoid constants:
x=x*1000;
y=y*1000;
z=z*1000;
a = 6378137;
e = 8.1819190842622e-2;

% calculations:
b   = sqrt(a^2*(1-e^2));
ep  = sqrt((a^2-b^2)/b^2);
p   = sqrt(x.^2+y.^2);
th  = atan2(a*z,b*p);
lon = atan2(y,x);
lat = atan2((z+ep^2.*b.*sin(th).^3),(p-e^2.*a.*cos(th).^3));
N   = a./sqrt(1-e^2.*sin(lat).^2);
alt = p./cos(lat)-N;
% return lon in range [0,2*pi)
lon = mod(lon,2*pi);
alt=alt/1000; %back to km
GEO=[alt;lat;lon];
end

