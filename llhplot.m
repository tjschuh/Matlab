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

% load in data file
load obsfiles.llh

f=figure;
plot(obsfiles(:,2),obsfiles(:,1))
hold on
scatter(obsfiles(:,2),obsfiles(:,1),'filled')
grid on
longticks
tt=title('June 16 Lat/Lon Ship Coordinates');
xlabel('Longitude [degrees]')
ylabel('Latitude [degrees]')

set(f,'renderer','painters')

% cosmetics
%movev(tt,0.003)
%figdisp([],[],'',2,[],'epstopdf')