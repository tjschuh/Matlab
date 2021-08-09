function llhplot(file,latc,lonc)
% LLHPLOT(file,latc,lonc)
%
% Takes in data file containing llh positions
% Produces a 2D lat vs lon position plot
%
% INPUT:
%
% file     columnized data with lats/lons
% latc     column number of file containing lat data [default:22]
% lonc     column number of file containing lon data [default:23]
%
% OUTPUT:
%
% 2D plot of lat vs lon
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 07/06/2021
% Last modified by tschuh-at-princeton.edu, 08/09/2021

% load in data file (data.ppp)
data=load(file);
defval('latc',22);
defval('lonc',23);

figure
plot(data(:,lonc),data(:,latc),'b')
hold on
scatter(data(:,lonc),data(:,latc),'filled','c')
grid on
longticks
tt=title('June 16 Lat/Lon Ship Coordinates');
xlabel('Longitude [degrees]')
ylabel('Latitude [degrees]')

% cosmetics
%movev(tt,0.003)
%figdisp([],[],'',2,[],'epstopdf')