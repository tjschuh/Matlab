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
% plot of height relative to WGS84 vs time
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 07/06/2021
% Last modified by tschuh-at-princeton.edu, 08/18/2021

% load in data file (data.ppp)
data=load(file);
defval('latc',22);
defval('lonc',23);
htc=24;

% plot lat and lon
figure
lon=transpose(data(:,lonc));
lat=transpose(data(:,latc));
z=zeros(size(lon));
time=1:length(data);
% plot line with color gradient signifying time
surface([lon;lon],[lat;lat],[z;z],[time;time],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',1.5);
% add start date and end date times to colorbar
colorbar('Ticks',[1,length(data)],...
         'TickLabels',{'Start','End'})
hold on
scatter(lon',lat','filled','k')
grid on
longticks
tt=title('June 16 Lat/Lon Ship Coordinates');
xlabel('Longitude [degrees]')
ylabel('Latitude [degrees]')

% plot height
figure
plot(time,data(:,htc),'r')
hold on
scatter(time,data(:,htc),'filled','r')
grid on
longticks
ttt=title("June 16 Ship Heights relative to WGS84");
xlabel("Time [s]")  
ylabel("Height relative to WGS84 [m]")
xlim([0 length(data)])
ylim([-max(abs(data(:,htc)))-0.1*max(abs(data(:,htc))) ...
      max(abs(data(:,htc)))+0.1*max(abs(data(:,htc)))])
keyboard

% cosmetics
%movev(tt,0.003)
%figdisp([],[],'',2,[],'epstopdf')