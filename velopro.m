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
% Last modified by tschuh-at-princeton.edu, 06/23/2021

load approx_positions
pos=approx_positions;

velosc=zeros(length(pos)-1,1);
velohr=zeros(length(pos)-1,1);
for i=2:length(pos)
    velohr(i-1,1)=sqrt((pos(i,1)-pos(i-1,1))^2 + (pos(i,2)-pos(i-1,2))^2 + (pos(i,3)-pos(i-1,3))^2);
    velosc(i-1,1)=velohr(i-1,1)/3600;
end
plot(velohr,'LineWidth',1.5)
grid on
xlim([1 length(pos)-1])
xlabel('Time [hr]')
ylabel('Velocity [m/hr]')
%figure
%plot(velosc)