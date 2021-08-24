function varargout = xyzpenlift(file,xcol,dlev)
% XYZPENLIFT(file,xcol,dlev)
%
% Computes Euclidean distance between
% consecutive XYZ points and if the
% jump is too big it replaces the
% second point with a NaN
%
% INPUT:
%
% file   data file containing XYZ coordinates
% xcol   column number in file where XYZ-LLH data begins [default: 19]
% dlev   threshold distance, if exceeded replaced with a NaN [default: 3]
%   
% OUTPUT:
%
% modified file
%
% Originally written by tschuh-at-princeton.edu, 08/20/2021
% Last modified by tschuh-at-princeton.edu, 08/24/2021
    
% should make inputs like Frederik's penlift.m
% s.t. you can input ascii or mat file

% Problem:
% 10 consecutive points are clearly too far away
% currently only the first one gets turned to NaN
% because we are only comparing a point to the previous one
% Solution:
% turn function into a for loop that runs algorithm,
% then runs it again ignoring all NaN
    
% dlev is the threshold distance
% dlev = ship speed [m/s] * data sampling rate [s]
defval('dlev',3);

% load in data file
data = load(file);

% we want XYZ cols and LLH cols
defval('xcol',19);
XYZ = data(:,xcol:xcol+5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Distance between two consecutive points on the sphere
d = sqrt([diff(XYZ(:,1))].^2 + [diff(XYZ(:,2))].^2 + [diff(XYZ(:,3))].^2);

% Where do the NaN's go (linear index is enough here)
%p = find(d>dlev*nmn(d));
p = find(d>dlev);

% Using p, replace certain rows in XYZ with NaNs
for i = 1:length(p)
   XYZ(p(i)+1,:) = NaN;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data(:,xcol:xcol+5) = XYZ;

% Output generation
save('data.ppp','data','-ascii')
%varargout = {data};
end

function y = nmn(x)
    % count how many entries of your vector are nans 
    n = sum(~isnan(x));
    % replace the nans in your vector with zeroes 
    % such that they don't contribute to the sum    
    x(isnan(x)) = 0;
    % Divide the sum by number of non-nan elements
    y = sum(x)/n;
end