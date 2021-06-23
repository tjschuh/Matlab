function velo=velopro()
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

velo=zeros(length(pos)-1,1);
for i=2:length(pos)
    velo(i-1,1)=sqrt((pos(i,1)-pos(i-1,1))^2 + (pos(i,2)-pos(i-1,2))^2 + (pos(i,3)-pos(i-1,3))^2);
    velo(i-1,1)=velo(i-1,1)/3600;
end

plot(velo)