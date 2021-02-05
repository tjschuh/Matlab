function [ship,beacon] = spiralpath(xymin,xymax,npoints,nturns,waves)
% ship = SPIRALPATH(xymin,xymax,npoints,nturns,waves)
%
% INPUT:
%
% xymin           min value for rng to pick x and y starting coordinates for ship
% xymax           max value for rng to pick x and y starting coordinates for ship
% npoints         # of data points in ship (integer value) (default is 100)
% nturns          # of turns in ship spiral path (integer value) (default is 3)
% waves           switch (1 or 0) to turn on/off "waves" feature (default is off)
%
% OUTPUT:
%
% ship   matrix containing (x,y,z,t) coordinates of a "ship" traveling in a sprial
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 11/13/2020
% Last modified by tschuh@princeton.edu, 2/5/2021

% This function creates an RNG spiral path of a ship on the
% ocean and a geodetic beacon falling to the seafloor  
  
% min x/y-value for ship rng
defval('xymin',-100);

% max x/y-value for ship rng
defval('xymax',100);

% min z-value for ship rng [m]
zmin = 975;

% max z-value for ship rng [m]
zmax = 1025;

% nominal ocean depth [m]
z0 = 1000;

% number of data points
defval('npoints',100);

% number of turns
defval('nturns',3);

% by default, waves are turned off
defval('waves',0);

% start ship and beacon "timer" at 0 seconds
t = 0;
% time interval between each location [sec]
tint = 60;

if exist('ship','var') == 0
  % randomly produce ship in a spiral manner with "waves"
  pos = [0 0; xymin+(xymax-xymin)*rand xymin+(xymax-xymin)*rand]; %[startpoint;endpoint]
  % sprial path engine
  dp = diff(pos,1,1);
  R = hypot(dp(1), dp(2));
  phi0 = atan2(dp(2), dp(1));
  phi = linspace(0, nturns*2*pi, npoints);
  r = linspace(0, R, numel(phi));
  ship(:,1) = pos(1,1) + r .* cos(phi + phi0); %ship x-coordinate
  ship(:,2) = pos(1,2) + r  .* sin(phi + phi0); %ship y-coordinate

  % waves section
  if waves == 0 %if user doesn't want waves, all z-coordinates are equal 
    ship(:,3) = z0; %ship z-coordinate
  else %if user wants waves, z-coordinates are randomly chosen between zmin and zmax
    ship(:,3) = zmin + (zmax-zmin)*rand(1,100); %ship z-coordinate between (zmin,zmax)
  end

  ship = flipud(ship);

  % time section
  for i = 1:size(ship,1)
    ship(i,4) = t;
    t = t + tint;
  end
end

% calculate beacon locations assuming beacon is dropped off
% from the very first ship point

% beacon drop-off point (x0,y0,z0,t0)                                            
drop = [ship(1,1) ship(1,2) z0 t];

% beacon descend velocity [m/sec]
bv = 1.5;

beacon(1,:) = drop;
j = 2;
for time = tint:tint:ship(end,4)
  beacon(j,:) = [drop(1) drop(2) z0-bv*time time];
  if beacon(j,3) <= 0
    beacon(j,3) = 0;
    break
  end
  j = j + 1;
end

clf

% end with a plot of the spiral ship path and beacon location
% if you didnt request output
if nargout == 0
  scatter3(ship(:,1),ship(:,2),ship(:,3),'^','filled');
  zlim([0 1000])
  hold on
  scatter3(beacon(:,1),beacon(:,2),beacon(:,3),'*')
end
