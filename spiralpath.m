function [ship,beacon] = spiralpath(xymin,xymax,npoints,nturns,waves,plt)
% [ship,beacon] = SPIRALPATH(xymin,xymax,npoints,nturns,waves,plt)
%
% Generates an RNG spiral path of a ship on the
% ocean and a geodetic beacon falling to the seafloor  
%
% INPUT:
%
% xymin           min value for rng to pick x and y starting coordinates for ship
% xymax           max value for rng to pick x and y starting coordinates for ship
% npoints         # of data points in ship (integer value) (default is 60)
% nturns          # of turns in ship spiral path (integer value) (default is 3)
% waves           switch (1 or 0) to turn on/off "waves" feature (default is off)
% plt             switch for plotting (1 for on, 0 for off)
%
% OUTPUT:
%
% ship            matrix containing (x,y,z,t) coordinates of a "ship" traveling in a sprial
% beacon          matrix containing (x,y,z,t) coordinates of the "beacon" sinking to seafloor
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 11/13/2020
% Last modified by tschuh@princeton.edu, 2/15/2022
  
% min x/y-value for ship rng
defval('xymin',-100);

% max x/y-value for ship rng
defval('xymax',100);

% min z-value for ship rng [m]
zmin = 5220;

% max z-value for ship rng [m]
zmax = 5230;

% nominal ocean depth [m]
z0 = 5225;

% number of data points
defval('npoints',60);

% number of turns
defval('nturns',3);

% by default, waves are turned off
defval('waves',0);

% by default, plotting is turned off
defval('plt',1);

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
    ship(:,3) = zmin + (zmax-zmin)*rand(1,tint); %ship z-coordinate between (zmin,zmax)
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

% initial drop time
t0 = 0;

% beacon drop-off point (x0,y0,z0,t0)                                            
drop = [ship(1,1) ship(1,2) z0 t0];

% beacon descend velocity [m/sec]
bv = 0.5;

% generate random x,y positions for the beacon as it descends with time
beacon(1,:) = drop;
x = drop(1);
y = drop(2);
spread = 10;
j = 2;
for time = tint:tint:ship(end,4)
    x = x+(rand*spread/2)-(rand*spread/2);
    y = y+(rand*spread/2)-(rand*spread/2);
    beacon(j,:) = [x y z0-bv*time time];
  if beacon(j,3) <= 0
    beacon(j,3) = 0;
    break
  end
  j = j + 1;
end

% need to make beacon have same number of rows as ship
for m = j+1:size(ship,1)
  beacon(m,1:3) = beacon(j,1:3);
  beacon(m,4) = ship(m,4);
end

if plt == 1
    f=figure;
    f.Position = [675 281 955 680];
    % end with a plot of the spiral ship path and beacon location
    scatter3(ship(:,1),ship(:,2),ship(:,3),'^','filled');
    zlim([0 1.1*max(ship(:,3))])
    hold on
    scatter3(beacon(:,1),beacon(:,2),beacon(:,3),'*')
    for k = 1:size(beacon,1)
        p1 = [ship(k,1) beacon(k,1)];
        p2 = [ship(k,2) beacon(k,2)];
        p3 = [ship(k,3) beacon(k,3)];
        plot3(p1,p2,p3,':','Color','k')
    end
    xlabel('x')
    ylabel('y')
    zlabel('z')

    figdisp([],[],'',2,[],'epstopdf')
end