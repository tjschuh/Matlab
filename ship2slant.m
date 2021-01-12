function varargout=ship2slant(x,y,t,x0,y0,z0,c,z)
% [sr,st]=SHIP2SLANT(x,y,t,x0,y0,z0,c,z)
%
% INPUT:  
%
% x,y,t     Ship trajectory
% x0,y0     Beacon drop-off point 
% z0        Nominal ocean depth [m]
% c,z       Sound speed profile [m/s,m]
%
% OUTPUT:
%
% sr        Slant range
% st        Slant time
%
% Originally written by tschuh@princeton.edu, 12/18/2020
% Last modified by tschuh@princeton.edu, 12/18/2020

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
varns={sr,st,t};
vararagout=varns(1:nargout);

