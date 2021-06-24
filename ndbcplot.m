function ndbcplot(bnum,dtype,dyear)
% NDBCPLOT(bnum,dtype,dyear)
%
% Plots weather data from the National Data Buoy Center.
%
% INPUT:
%
% bnum      Buoy number (default: 41049)
% dtype     Data type (default: 1) (2 and 3 don't work yet)
%           1 Standard meteorological
%           2 Wave spectral density
%           3 Supplemental measurements
% dyear     Data year (default: 2020)
%
% OUTPUT:
%
%
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 06/11/2021
% Last modified by tschuh-at-princeton.edu, 06/24/2021

% Make defaults
defval('bnum',41049)
defval('dtype',1)
defval('dyear',2020)
defval('meth',1)

% Call ndbc to open weather data
[t,d,h] = ndbc(bnum,dtype,dyear);

% https://www.ndbc.noaa.gov/measdes.shtml
% In dtype 1 STANDARD mode
% col 1 of d is the WDIR wind direction [deg]
% col 2 of d is the WSPD wind speed [m/s]
% col 4 of d is the WVHT significant wave height [m]

% For the last two plots
ylabs={'Wind Speed [m/s]','Wave Height [m]'};
tits={'Wind Speed','Significant Wave Height'};

% Calculate monthly WIND SPEED and WAVE HEIGHT averages
wswh=zeros(12,2);
for i=1:12
  switch meth 
  case 1
    rn=find(t.Month==i);
    counter=1;
    for k=rn(1,1):rn(end,1)
	if d{4}(k) ~= 99
           vals(counter,1) = d{4}(k);
           counter=counter+1;
        end
    end
    wswh(i,1)=mean(d{2}(rn));
    wswh(i,2)=mean(vals);
    clear vals
case 2
    ri=t.Month==i;
    wswf(i,1)=mean(d{2}(ri));
    % Don't take the 'fake empty' values
    wswf(i,2)=mean(d{4}(ri & d{4}~=99));
end
end

% For each month create a polar histogram of WIND DIRECTION
f=figure(1); 
clf
rlims=0; 
for j=1:12
    rn=find(t.Month==j);
    wdir=d{1}(rn);
    % Make a straight plot
    ax=subplot(3,4,j);
    % Steal the position for a polar plot
    ah(j)=polaraxes('Position',get(ax,'Position')); delete(ax)
    % Plot the polar plot into the polar axis
    ho(j)=polarhistogram(ah(j),wdir*pi/180);
    % m=month(t(rn(1,1)),'name');
    % th(j)=title(sprintf('%s',m{:}));
    th(j)=title(sprintf('%s',cell2mat(month(t(rn(1,1)),'name'))));
    rlims=max([get(ah(j),'rlim') rlims]);
end

% Slap title... be aware that the first might be from the previous year 
diferm(t.Year(2),dyear)
tt1=supertit(ah(1:4),sprintf('Wind Direction for Year %d',t.Year(2)));

% Bunch of cosmetics
for j=1:12
    thetaticks(ah(j),[0 45 90 135 180 225 270 315])
    thetaticklabels(ah(j),{'N','NE','E','SE','S','SW','W','NW'})
    ah(j).ThetaDir='clockwise';
    ah(j).ThetaZeroLocation='top';
    % For some reason the structured input is not accessible
    set(ah(j),'rticklabel',[])
    set(th(j),'FontWeight','normal')
    shrink(ah(j),1.2,1.2)
    set(ah(j),'FontSize',6)
    % Maybe that's an option
    set(ah(j),'rlim',[0 rlims]);
end 

serre(reshape(ah,4,3),1/3,'down')
movev(tt1,-0.3)

% My FIGDISP 
set(f,'renderer','painters')
figdisp([],sprintf('%i_%i_%i_wdir',bnum,dtype,dyear),'',2,[],'epstopdf')

% bar graph of mean wind speed
figure(2)
int=[2 0.5];
fay=20;
fax=[1.25 1.3];
cols={'r','b'};

for index=1:2
    ax(index)=subplot(2,1,index);
    b(index)=bar(wswh(:,index));
    set(b(index),'FaceColor',cols{index})
    ylim([floor(min(wswh(:,index)))-(int(index)/2) max(wswh(:,index))+(int(index)/2)])
    longticks(ax(index),2)
    thh(index)=title(sprintf('Buoy %i Average Monthly %s for Year %d',...
                    bnum,tits{index},t.Year(2)));
    grid on
    movev(thh(index),range(ylim)/fay)
    moveh(thh(index),fax(index))
    xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
    ylabel(ylabs{index})
end
figdisp([],sprintf('%i_%i_%i_wswh',bnum,dtype,dyear),'',2,[],'epstopdf')

