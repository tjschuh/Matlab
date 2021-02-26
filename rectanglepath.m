function [] = rectanglepath(xymin,xymax,nturns)
% [] = RECTANGLEPATH()
%
% INPUT:
%
% OUTPUT:
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 2/25/2021
% Last modified by tschuh@princeton.edu, 2/25/2021

% This function creates an RNG rectangular path of a ship on the
% ocean and a geodetic beacon falling to the seafloor

% min x/y-value for ship rng
defval('xymin',-100);

% max x/y-value for ship rng
defval('xymax',100);

% number of turns
defval('nturns',3);

% length of turns
turns = 3;

% distance between edges of rectangle
range = 8;

step = 5;

ship(1,1) = xymin+(xymax-xymin)*rand;
ship(1,2) = xymin+(xymax-xymin)*rand;

for r = 1:range-1
  ship(r+1,1) = ship(r,1);
  ship(r+1,2) = ship(r,2)+step;
end

for t = range:range+turns-2
  ship(t+1,1) = ship(t,1)+step;
  ship(t+1,2) = ship(t,2);
end  
%keyboard
%for i=1:1%nturns
 % t1 = [start(1,1) start(1,2)+range];
 % t2 = [t1(1)+(height/4) t1(2)];
%end



scatter(ship(:,1),ship(:,2),'^','filled')
%hold on
%scatter(t1(1),t1(2),'^','filled')
%scatter(t2(1),t2(2),'^','filled')
