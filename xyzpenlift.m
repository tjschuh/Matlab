function xyzpenlift(file,xcol,tcol,velo,loop)
% XYZPENLIFT(file,xcol,tcol,velo,loop)
%
% Computes Euclidean distance between
% consecutive XYZ points and if the
% jump is too big it replaces the
% second point with a NaN
% done in a user-defined for loop
% to catch the max number of jumps
%
% INPUT:
%
% file   data file containing XYZ coordinates
% xcol   column number in file where XYZ-LLH data begins [default: 19]
% tcol   column number in file where time begin [default: 7]
% velo   ship speed used to compute threshold distance triggering NaN replacement [default: 3]
% loop   number of loop iterations to perform [default: 500] 
%
% OUTPUT:
%
% modified file data.ppp
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 08/20/2021
% Last modified by tschuh-at-princeton.edu, 08/31/2021

% should make inputs like Frederik's penlift.m
% s.t. you can input ascii or mat file

% load in data file
data = load(file);

% we want XYZ cols and LLH cols to turn to NaNs
defval('xcol',19);

% we also want time columns to keep time
defval('tcol',7);

% ship speed really is 1.03 m/s
defval('velo',3);

% number of loop iterations to perform
defval('loop',50);

% remove entire NaN rows that
% may exist in data from start
rows=any(isnan(data),2);
data(rows,:)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% to remove entire sections of glitches that might be stacked
% on one another we use a for loop such that the first time thru
% a glitch may be caught, but others which appear right on top
% of it only seconds later in the data are not caught
% to counter this, we turn gltiches to NaNs, remove entire
% rows containing NaNs, then run the loop again bearing in
% mind the sampling rate between some data points has increased

for k = 1:loop

% Distance between two consecutive points on the sphere
d = sqrt([diff(data(:,xcol))].^2 + [diff(data(:,xcol+1))].^2 + [diff(data(:,xcol+2))].^2);

% duration in seconds between consecutive points (use seconds function)
dat = datetime(data(:,tcol:tcol+5));
t = seconds(diff(dat));

% for every d value check to see if > dlev (threshold distance)
% if so, that point in the data is a glitch so turn it to NaN
% dlev is computed based on the ship velocity AND how much time
% is in-between data points i.e. if 3 seconds have gone by, then
% the ship could have moved a max 3*velo meters
for j = 1:length(d)
    % dlev is the threshold distance
    % dlev = ship speed [m/s] * data sampling rate [s]
    % dlev = shipspeed*diff between consecutive times
    dlev = velo*t(j);
    if dlev < 1
        dlev = velo;
    end    
    if d(j) > dlev
        data(j+1,xcol:xcol+5) = NaN;
    end
end

% remove entire NaN rows that
% were just created during loop
rows=any(isnan(data),2);
data(rows,:)=[];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% output generation
% save final data file to data.ppp
save('data.ppp','data','-ascii')
