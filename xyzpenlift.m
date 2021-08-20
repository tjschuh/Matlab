function varargout = xyzpenlift(file)
% XYZ=XYZPENLIFT(file)
%
% Computes Euclidean distance between
% consecutive XYZ points and if the
% jump is too big it replaces the
% second point with a NaN
%
% INPUT:
%
% file   data file containing XYZ coordinates
%
% OUTPUT:
%
% XYZ    3 column data file that has same dimensions as input file, but with added NaNs
%
% Originally written by tschuh-at-princeton.edu, 08/20/2021

% To do:    
% need to define dlev as an input
% need to change how data is input b/c right now
% code works on XYZ coordinates, but also need to
% change respective LLH coordinates 

% dlev is the threshold distance
% dlev = ship speed [m/s] * data sampling rate [s]
dlev = 3;

% load in data file
data = load(file);

% make this a defval
XYZ = data(:,19:21);
X = XYZ(:,1);
Y = XYZ(:,2);
Z = XYZ(:,3);

% Distance between two consecutive points on the sphere
d = sqrt([diff(X)].^2 + [diff(Y)].^2 + [diff(Z)].^2);

% Where do the NaN's go (linear index is enough here)
p = find(d>dlev*nmn(d));

% using p, replace certain rows in XYZ with NaNs
for i = 1:length(p)
   X(p(i)+1) = NaN;
   Y(p(i)+1) = NaN;
   Z(p(i)+1) = NaN;
end

% Output preparation
XYZ(:,1) = X;
XYZ(:,2) = Y;
XYZ(:,3) = Z;
vars = {XYZ};

% Actual output generation
varargout = vars;

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