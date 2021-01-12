function [shiplocations,beacon] = testlocate(xymin,xymax,npoints,nturns)
% [shiplocations,beacon] = TESTLOCATE(xymin,xymax,npoints,nturns)
%
% INPUT:
%
% xymin           min value for rng to pick x and y starting coordinates for shiplocations
% xymax           max value for rng to pick x and y starting coordinates for shiplocations
% npoints         # of data points in shiplocations (integer value)
% nturns          # of turns in ship spiral path (integer value)
%
% OUTPUT:
%
% shiplocations   matrix containing (x,y,z) coordinates of a "ship" traveling in a sprial
% beacon          true location of "beacon" on seafloor
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 11/13/2020
% Last modified by tschuh@princeton.edu, 12/15/2020
  
%need to add time coordinate still!
  
%min x/y-value for shiplocations rng
defval('xymin',-100);

%max x/y-value for shiplocations rng
defval('xymax',100);

%min z-value for shiplocations rng
zmin = 975;

%max z-value for shiplocations rng
zmax = 1025;

%number of data points
defval('npoints',100);

%number of turns
defval('nturns',3);
  
if exist('shiplocations','var') == 0  
%true location of beacon on seafloor  
beacon = [xymin+(xymax-xymin)*rand xymin+(xymax-xymin)*rand 0];
  
% randomly produce shiplocations in a spiral manner with "waves"
pos = [0 0; xymin+(xymax-xymin)*rand xymin+(xymax-xymin)*rand]; %[startpoint;endpoint]
% sprial path engine
dp = diff(pos,1,1);
R = hypot(dp(1), dp(2));
phi0 = atan2(dp(2), dp(1));
phi = linspace(0, nturns*2*pi, npoints);
r = linspace(0, R, numel(phi));
shiplocations(:,1) = pos(1,1) + r .* cos(phi + phi0); %shiplocations x-coordinate
shiplocations(:,2) = pos(1,2) + r  .* sin(phi + phi0); %shiplocations y-coordinate
shiplocations(:,3) = zmin + (zmax-zmin)*rand(1,100); %shiplocations z-coordinate between (zmin,zmax)
end

%plot ship path and beacon location
scatter3(shiplocations(:,1),shiplocations(:,2),shiplocations(:,3),'^','filled');
hold on
scatter3(beacon(1),beacon(2),beacon(3),'*')
