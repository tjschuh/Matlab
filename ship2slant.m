function shiplocations = ship2slant(path,c,z)
% []=SHIP2SLANT()
%
% INPUT:  
%
% path      Ship trajectory chosen by user, current options: spiral
% c,z       Sound speed profile [m/s,m]
%
% OUTPUT:
%
% sr        Slant range
% st        Slant time
%
% Originally written by tschuh@princeton.edu, 12/18/2020
% Last modified by tschuh@princeton.edu, 2/3/2021
  
% Default ship trajectory is spiral
defval('path','spiral')

% if path = spiral, call spiralpath to generate shiplocations and drop-off point
if strcmp(path,'spiral') == 1
  shiplocations = spiralpath();
  % beacon drop-off point (x0,y0,z0)
  drop = [shiplocations(1,1) shiplocations(1,2) shiplocations(1,3)];
end

% Default sound speed profile
defval('c',1500)
defval('z',NaN)

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
