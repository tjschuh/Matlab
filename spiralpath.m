function shiplocations = spiralpath(xymin,xymax,npoints,nturns,waves)
% shiplocations = SPIRALPATH(xymin,xymax,npoints,nturns,waves)
%
% INPUT:
%
% xymin           min value for rng to pick x and y starting coordinates for shiplocations
% xymax           max value for rng to pick x and y starting coordinates for shiplocations
% npoints         # of data points in shiplocations (integer value) (default is 100)
% nturns          # of turns in ship spiral path (integer value) (default is 3)
% waves           switch (1 or 0) to turn on/off "waves" feature (default is off)
%
% OUTPUT:
%
% shiplocations   matrix containing (x,y,z) coordinates of a "ship" traveling in a sprial
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 11/13/2020
% Last modified by tschuh@princeton.edu, 2/3/2021

% This function creates an RNG spiral path of a "ship on the ocean"

%need to add time coordinate still!
  
% min x/y-value for shiplocations rng
defval('xymin',-100);

% max x/y-value for shiplocations rng
defval('xymax',100);

% min z-value for shiplocations rng [m]
zmin = 975;

% max z-value for shiplocations rng [m]
zmax = 1025;

% nominal ocean depth [m]
z0 = 1000;

% number of data points
defval('npoints',100);

% number of turns
defval('nturns',3);

% by default, waves are turned off
defval('waves',0);
  
if exist('shiplocations','var') == 0  
  % true location of beacon on seafloor  
  beacon = [xymin+(xymax-xymin)*rand xymin+(xymax-xymin)*rand 0];
  
  % randomly produce shiplocations in a spiral manner with "waves"
  pos = [xymin+(xymax-xymin)*rand xymin+(xymax-xymin)*rand; 0 0]; %[startpoint;endpoint]
  % sprial path engine
  dp = diff(pos,1,1);
  R = hypot(dp(1), dp(2));
  phi0 = atan2(dp(2), dp(1));
  phi = linspace(0, nturns*2*pi, npoints);
  r = linspace(0, R, numel(phi));
  shiplocations(:,1) = pos(1,1) + r .* cos(phi + phi0); %shiplocations x-coordinate
  shiplocations(:,2) = pos(1,2) + r  .* sin(phi + phi0); %shiplocations y-coordinate

  % waves section
  if waves == 0 %if user doesn't want waves, all z-coordinates are equal 
    shiplocations(:,3) = z0; %shiplocations z-coordinate
  else %if user wants waves, z-coordinates are randomly chosen between zmin and zmax
    shiplocations(:,3) = zmin + (zmax-zmin)*rand(1,100); %shiplocations z-coordinate between (zmin,zmax)
  end
end

clf

% end with a plot of the spiral ship path and beacon location
% if you didnt request output
if nargout == 0
  scatter3(shiplocations(:,1),shiplocations(:,2),shiplocations(:,3),'^','filled');
  hold on
  scatter3(beacon(1),beacon(2),beacon(3),'*')
end
