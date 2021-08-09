function pvp(file)
% PVP(file)
%
% compare pre-processed and post-processed positions
% by adding XYZ coordinates together of both data and
% taking the difference. plot a 0 if data is unchanged
% after processing (zero difference), and a 1 if it is
% changed (non-zero difference)
%
% INPUT:
%
% file     columnized data file containing XYZ pre-processed (approx) and post-processed positions
%
% OUTPUT:
%
% histogram-like plot of 0's and 1's (0 = no change via processing, 1 = change)
%
% Originally written by tschuh-at-princeton.edu, 07/08/2021
% Last modified by tschuh-at-princeton.edu, 08/09/2021

% load data (data.ppp)
ppp=load(file);

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