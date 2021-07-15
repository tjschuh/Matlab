function llhplot()
%LLHPLOT()
%
% Takes in data file containing llh positions
% Produces a 2D lat vs lon position plot
%
% INPUT:
%
% OUTPUT:
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 07/06/2021
% Last modified by tschuh-at-princeton.edu, 07/15/2021

% load in data file
load solutions1h
files1=solutions1h; 
lat1=4;
lon1=5;

load solutions30m
files2=solutions30m;
lat2=4;
lon2=5;

figure
plot(files1(:,lon1),files1(:,lat1),'b')
hold on
plot(files2(:,lon2),files2(:,lat2),'r')
hold on
scatter(files1(:,lon1),files1(:,lat1),'filled','c')
hold on
scatter(files2(:,lon2),files2(:,lat2),'filled','m')
grid on
longticks
tt=title('June 16 Lat/Lon Ship Coordinates');
xlabel('Longitude [degrees]')
ylabel('Latitude [degrees]')

% cosmetics
%movev(tt,0.003)
%figdisp([],[],'',2,[],'epstopdf')