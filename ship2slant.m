function [sr,st] = ship2slant(path,c,z)
% [sr,st]=SHIP2SLANT(path,c,z)
%
% INPUT:  
%
% path      Ship trajectory chosen by user, current options: spiral
% c,z       Sound speed profile [m/s,m]
%
% OUTPUT:
%
% sr        Slant range [m]
% st        Slant time [s]
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 12/18/2020
% Last modified by tschuh@princeton.edu, 2/25/2021
  
% Default ship trajectory is spiral
defval('path','spiral')

% when I eventually add more path options, use switch/case
% if path = spiral, call spiralpath to generate shiplocations and drop-off point
if strcmp(path,'spiral') == 1
  [ship,beacon] = spiralpath();
end

% v = d/t --> c = sr/st --> st = sr/c

% Default sound speed profile
defval('c',1500)
defval('z',NaN)

% Compute the slant range
for i = 1:size(ship,1)
  sr(i,1) = sqrt((ship(i,1)-beacon(i,1))^2 + ...
	  (ship(i,2)-beacon(i,2))^2 + (ship(i,3)-beacon(i,3))^2);
end

if nargout > 1
  % Compute the time
  if length(c)==1 ||  isnan(z)
    st=sr/c;
  else
    % Do a calculation that converts distance to time
    % Appoximately? Proper ray tracing?
  end
end


% Optional outputs
%varns={sr,st,t};
%vararagout=varns(1:nargout);

%keyboard
