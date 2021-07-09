function pvp()
% PVP()
%
%
% INPUT:
%
% OUTPUT:
%
% Originally written by tschuh-at-princeton.edu, 07/08/2021

load data.ppp
ppp = data;

pre = zeros(length(ppp),1);
post = zeros(length(ppp),1);
test = zeros(length(ppp),1);
for i=1:length(ppp)
    pre(i,1) = ppp(i,1)+ppp(i,2)+ppp(i,3);
    post(i,1) = ppp(i,17)+ppp(i,18)+ppp(i,19);
    if pre(i,1) == post(i,1)
        test(i,1) = 0;
    else
        test(i,1) = 1;
    end
end

ppp = [ppp test];

% plotting
scatter(1:length(ppp),ppp(:,end),'filled')
grid on
longticks
yticks([0 1])
ylim([-0.1 1.1])
xlim([-6 length(ppp)+7])
title('BIOS Cruise Data Pre-Processing vs. Post-Processing')
xlabel('Data Point Number')
ylabel(sprintf('0 = No Change\n1 = Change'))