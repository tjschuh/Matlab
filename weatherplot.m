function weatherplot(bnum,dtype,dyear)
% WEATHERPLOT(bnum,dtype,dyear)
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

meth=1;
% calculate monthly wind speed and wave height averages
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
    wswf(i,2)=mean(d{4}(ri & d{4}~=99));
end
end

% for each month create a polar histogram of wind direction
f=figure(1);
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
end

% Slap title
tt1=supertit(ah(1:4),sprintf('Wind Direction for Year %d',t.Year(1)));

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
end 
serre(reshape(ah,4,3),1/3,'down')
movev(tt1,-0.3)

%f.Position=[10 10 540 600];
%saveas(gcf,'wdir.pdf')
% My FIGDISP 
set(f,'renderer','painters')
%print('-depsc',sprintf('%s_%i_%i_%i',mfilename,bnum,dtype,dyear))
figdisp([],sprintf('%i_%i_%i_wdir',bnum,dtype,dyear),'',2,[],'epstopdf')

% plotting wspd
% error when using figdisp ASK FREDERIK
figure(2);
bar(wswh(:,1))
int=2;
tt2=title(sprintf('Average Monthly Wind Speed for Year %d',t.Year(1)));
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
ylim([floor(min(wswh(:,1)))-(int/2) max(wswh(:,1))+(int/2)])
ylabel('Wind Speed [m/s]')
longticks
grid on
movev(tt2,+0.2)
figdisp([],sprintf('%i_%i_%i_wspd',bnum,dtype,dyear),'',2,[],'epstopdf')
%saveas(gcf,'wspd.pdf')

% plotting wvht
% error when using figdisp ASK FREDERIK
figure(3);
bar(wswh(:,2))
int=0.5;
tt3=title(sprintf('Average Monthly Wave Height for Year %d',t.Year(1)));
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
ylim([floor(min(wswh(:,2)))-(int/2) max(wswh(:,2))+(int/2)])
ylabel('Wave Height [m]')
longticks
grid on
movev(tt3,+0.04)
figdisp([],sprintf('%i_%i_%i_wvht',bnum,dtype,dyear),'',2,[],'epstopdf')
%saveas(gcf,'wvht.pdf');