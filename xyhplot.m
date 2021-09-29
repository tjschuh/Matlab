function xyhplot(file,llhc)
% XYHPLOT(file,llhc)
%
% Takes in data file containing llh positions
% Produces a 2D lat vs lon position plot
%
% INPUT:
%
% file     columnized data with lats/lons
% llhc     column number of file where lat,lon,ht data begins [default: 22]
%    
% OUTPUT:
%
% 2D plot of x vs y with UTM zone
% plot of height relative to WGS84 vs time
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 09/22/2021

data=load(file);

defval('llhc',6);
latc=llhc;
lonc=llhc+1;
htc=llhc+2;

for i=1:length(data)
    data(i,lonc)=mod(data(i,lonc)+180,360)-180;  
end

% will eventually need to adjust how we keep time
% in case we are missing any seconds (we actually are)
% this is fine for now though
time=1:length(data);

% plot x,y coordinates in utm
%allocate memory for speed
for i = 1:length(data)
    % can also get utmzone, but need to make another array for that
    [x(i),y(i),utmzone] = deg2utm(data(i,latc),data(i,lonc));
end

x = x-455691.4;
y = y-3362215;

z=zeros(size(x));
figure
c = linspace(1,10,length(x(1:100:end)));
scatter(x(1:100:end)',y(1:100:end)',[],c,'filled')
hold on
plot(x(1:100:end)',y(1:100:end)','k','LineWidth',0.5)
colormap(jet)
colorbar('southoutside','Ticks',[1,10],...
         'TickLabels',{'start','end'})

grid on
longticks
tt=title('June 11-12, 2020 UTM Ship Coordinates, Unit 1');
xlabel('X [m]')
ylabel('Y [m]')

% plot height
figure
plot(time,data(:,htc),'r')
hold on
scatter(time,data(:,htc),'filled','r')
grid on
longticks
ttt=title("June 11-12, 2020 Ship Heights relative to WGS84, Unit 1");
xlabel("Time [hr]")  
ylabel("Height relative to WGS84 [m]")
xlim([0 length(data)])
xticks([0:3600:length(data)])
labels=[0:16];
xticklabels({'0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
