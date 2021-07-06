function velopro()
%VELOPRO()
%
% Takes in data file containing XYZ positions and timestamps
% Produces a velocity profile from the position data by
% computing the distance between each position and dividing
% the result by the time interval between each position
%
% INPUT:
%
%
%
% OUTPUT:
%
%
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 06/23/2021
% Last modified by tschuh-at-princeton.edu, 07/06/2021

% load in data file
% column order: X Y Z  YYYY MM DD HH MM SS  YYYY MM DD HH MM SS
load obsfiles.pos
pos=obsfiles(:,1:3);
t1=datetime(obsfiles(:,4:9));
t2=datetime(obsfiles(:,10:15));

% compute euclidean distance between each xyz position
% divide by appropriate time interval for desired units
% default: knots 
dist=zeros(length(pos)-1,1);
velo=zeros(length(pos)-1,1);
for i=2:length(pos)
    dist(i-1,1)=sqrt((pos(i,1)-pos(i-1,1))^2 + (pos(i,2)-pos(i-1,2))^2 + (pos(i,3)-pos(i-1,3))^2);
end

% already in m/hr
% m/min --> /60
% m/sec --> /3600
velo=dist;

% 1 knot = 1852 m/hr
velo=velo./1852;

% plotting
% entire velocity profile
e=figure;
plot(t1(2:end),velo,'LineWidth',1.5)
cosmo
ylim([0 ceil(max(velo))])
xt=xticks;

% 1st leg (beginning) of cruise velo profile
f=figure;
plot(t1(2:84),velo(1:83),'LineWidth',1.5)
cosmo
ylim([0 ceil(max(velo(1:83)))])
xticks(xt(1)-hours(6):hours(6):xt(end))

% 2nd leg (campaign) of cruise velo profile
g=figure;
plot(t1(85:110),velo(84:109),'LineWidth',1.5)
cosmo
ylim([0 ceil(max(velo(84:109)))])
xticks(xt(1):hours(4):xt(end))

% 3rd leg (end) of cruise velo profile
h=figure;
plot(t1(110:end),velo(109:end),'LineWidth',1.5)
cosmo
ylim([0 ceil(max(velo(109:end)))])
xticks(xt(1):hours(6):xt(end)+hours(6))

set(e,'renderer','painters')
set(f,'renderer','painters')
set(g,'renderer','painters')
set(h,'renderer','painters')

function cosmo
xlabel('Time')
ylabel('Velocity [knots]')
title('Velocity Profile of RV Atlantic Explorer ')
grid on
axis tight
longticks

