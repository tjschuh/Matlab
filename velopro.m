function velohr=velopro()
%velo=VELOPRO()
%
% INPUT:
%
%
%
% OUTPUT:
%
%
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh-at-princeton.edu, 06/23/2021
% Last modified by tschuh-at-princeton.edu, 06/29/2021

load obsfiles.pos
pos=obsfiles(:,1:3);
t1=datetime(obsfiles(:,4:9));
t2=datetime(obsfiles(:,10:15));

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

f=figure;
%plot(velo,'LineWidth',1.5)
plot(t1(2:end),velo,'-o','LineWidth',1.5)
grid on
axis tight
%xlim([1 length(pos)-1])
xlabel('Time')
ylabel('Velocity [knots]')
title('Velocity Profile of RV Atlantic Explorer ')
set(f,'renderer','painters')