function varargout = xyzpenlift(file,xcol,dlev)
% XYZ=XYZPENLIFT(file,xcol,dlev)
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
% XYZ    3 column data file that has same dimensions as input file, but with added NaNs
%
% Originally written by tschuh-at-princeton.edu, 08/20/2021

% To do:
% need to change output so it overwrites original input file

% dlev is the threshold distance
% dlev = ship speed [m/s] * data sampling rate [s]
defval('dlev',3)

% load in data file
data = load(file);

% we want XYZ cols and LLH cols
defval('xcol',19)
XYZ = data(:,xcol:xcol+5);

% Distance between two consecutive points on the sphere
d = sqrt([diff(XYZ(:,1))].^2 + [diff(XYZ(:,2))].^2 + [diff(XYZ(:,3))].^2);

% Where do the NaN's go (linear index is enough here)
p = find(d>dlev*nmn(d));

% Using p, replace certain rows in XYZ with NaNs
for i = 1:length(p)
   XYZ(p(i)+1,:) = NaN;
end

% Output generation
varargout = {XYZ};

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