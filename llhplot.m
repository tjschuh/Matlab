function llhplot(file,llhc,tc)
% LLHPLOT(file,llhc,tc)
%
% Takes in data file containing llh positions
% Produces a 2D lat vs lon position plot
%
% INPUT:
%
% file     columnized data with lats/lons
% llhc     column number of file where lat,lon,ht data begins [default: 22]
% tc       column number of file where time begins [default: 7]
%    
% OUTPUT:
%
% 2D plot of lat vs lon
% plot of height relative to WGS84 vs time
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 07/06/2021
% Last modified by tschuh-at-princeton.edu, 08/31/2021

% Problem:
% not plotting ascii file created from xyzpenlift.m
% scatter works, but not plot/surface
% seems to be an issue with the NaNs
% I think I fixed this with rows part

% load in data file (data.ppp)
data=load(file);

% remove entire NaN rows
rows=any(isnan(data),2);
data(rows,:)=[];

defval('llhc',22);
latc=llhc;
lonc=llhc+1;
htc=llhc+2;

defval('tc',7);
dat=datetime(data(:,tc:tc+5));

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
st=datestr(dat(1));
md=datestr(dat(ceil(length(data)/2)));
ed=datestr(dat(end));
colorbar('southoutside','Ticks',[1,ceil(length(data)/2),length(data)],...
         'TickLabels',{st,md,ed})
colormap(jet)
hold on
scatter(lon',lat','filled','k')
grid on
longticks
tt=title('June 16, 2020 24 Hours Lat/Lon Ship Coordinates');
xlabel('Longitude [degrees]')
ylabel('Latitude [degrees]')

% plot height
figure
plot(time,data(:,htc),'r')
hold on
scatter(time,data(:,htc),'filled','r')
grid on
longticks
ttt=title("June 16, 2020 24 Hours Ship Heights relative to WGS84");
xlabel("Time [s]")  
ylabel("Height relative to WGS84 [m]")
xlim([0 length(data)])
ylim([-max(abs(data(:,htc)))-0.1*max(abs(data(:,htc))) ...
      max(abs(data(:,htc)))+0.1*max(abs(data(:,htc)))])

% cosmetics
%movev(tt,0.003)
%figdisp([],[],'',2,[],'epstopdf')