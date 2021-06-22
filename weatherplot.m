function weatherplot(bnum,fname,ccode)
% WEATHERPLOT(bnum,fname,ccode)
%
% INPUT:
%
% bnum      Buoy number (default: 41049)
% dtype     Data type 
%           1 Standard meteorological
%           2 Wave spectral density
%           3 Supplemental measurements
% dyear     Data year (default: 2020)
%
% OUTPUT:
%
%
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh-at-princeton.edu, 06/11/2021
% Last modified by tschuh-at-princeton.edu, 06/22/2021

% Make defaults
defval('bnum',41049)
defval('dtype',1)
defval('dyear',2020)

% call ndbc to open weather data
[t,d,h] = ndbc(bnum,dtype,dyear);

% col 1 of d is the wind direction [deg]
% col 2 of d is the wind speed [m/s]
% col 4 of d is the wave height [m]

% calculate monthly wind speed and wave height averages
wswh=zeros(12,2);
for i=1:12
    rn=find(any(t.Month==i,2));
    counter=1;
    for k=rn(1,1):rn(end,1)
	if d{4}(k) ~= 99
           vals(counter,1) = d{4}(k);
           counter=counter+1;
        end
    end
    wswh(i,1)=mean(d{2}(rn(1,1):rn(end,1)));
    wswh(i,2)=mean(vals);
    clear vals
end

% for each month create a polar histogram of wind direction
figure
for j=1:12
    rn=find(any(t.Month==j,2));
    wdir=d{1}(rn(1,1):rn(end,1));
    subplot(4,3,j)
    polarhistogram(wdir*pi/180+pi)
    %m=month(t(rn(1,1)),'name');
    %title(sprintf('%d',m{:}))
    ax=gca;
    ax.ThetaDir='clockwise';
    ax.ThetaZeroLocation='top';
    thetaticks([0 45 90 135 180 225 270 315])
    thetaticklabels({'N','NE','E','SE','S','SW','W','NW'})
    clear wdir rn
end

% plotting wspd
figure
bar(wswh(:,1))
int=2;
title(sprintf('Average Monthly Wind Speed for Year %d',t.Year(1)))
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
ylim([floor(min(wswh(:,1)))-(int/2) max(wswh(:,1))+(int/2)])
ylabel('Wind Speed [m/s]')
longticks
grid on

% plotting wvht
figure
bar(wswh(:,2))
int=0.5;
title(sprintf('Average Monthly Wave Height for Year %d',t.Year(1)))
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
ylim([floor(min(wswh(:,2)))-(int/2) max(wswh(:,2))+(int/2)])
ylabel('Wave Height [m]')
longticks
grid on
