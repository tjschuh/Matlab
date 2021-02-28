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
% Last modified by tschuh@princeton.edu, 2/26/2021

% This function creates an RNG rectangular path of a ship on the
% ocean and a geodetic beacon falling to the seafloor

% min x/y-value for ship rng
defval('xymin',-100);

% max x/y-value for ship rng
defval('xymax',100);

% number of turns
defval('nturns',2);

% length of turns
length = 3;

% distance between edges of rectangle
range = 8;

step = 5;

ship(1,1) = xymin+(xymax-xymin)*rand;
ship(1,2) = xymin+(xymax-xymin)*rand;

for i = 1:nturns
  if i == 1
    for a = 2:range+length-1
      if a <= range
	ship(a,1) = ship(a-1,1);
	ship(a,2) = ship(a-1,2)+step;
      elseif a > range
	ship(a,1) = ship(a-1,1)+step;
	ship(a,2) = ship(a-1,2);
      end
    end
  elseif i > 1
    for b = (range+length)*(i-1):((range+length)*i)-3
      if b < range+((range+length-1)*(i-1))
	ship(b,1) = ship(b-1,1);
	ship(b,2) = ship(b-1,2)+(((-1)^(i-1))*step);
      elseif b >= range+((range+length-1)*(i-1))
	ship(b,1) = ship(b-1,1)+step;
	ship(b,2) = ship(b-1,2);
      end
    end
  end  
end

%keyboard

scatter(ship(:,1),ship(:,2),'^','filled')
