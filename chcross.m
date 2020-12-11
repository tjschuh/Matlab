function [tsample1,cross,mc,mcloc] = chcross(FourChan,rlens,xver)
% CHPLOT(FourChan)
%
% INPUT:
%
% FourChan   the 4-row matrix containing the reshaped, correctly allocated data from file   
% rlens      the record length in seconds, in most cases it is 60 seconds
%  
% OUTPUT:
%
% tsample1    a 1-second time sample taken from the time channel of FourChan
% cross      cross-correlation data of tsample
%  
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Written by tschuh@princeton.edu, 10/30/2020

%working code

%zero-out the time channel of FourChan  
FourChan(3,:) = FourChan(3,:) - min(FourChan(3,:));
%length of 1 second segment
sampsize = 400000;
%subsample
intv = 10000;

for i = 1:rlens
  %template segment
  tsample1 = FourChan(3,1:sampsize);
  %same size segment, incrementally offset by sampsize
  tsample2 = FourChan(3,1+sampsize*(i-1):sampsize*i);
  %cross-correlation
  [c,lags] = xcorr(tsample1,tsample2,'coeff');
  cross(i,:) = c;
  [mc(i),mcloc(i)] = max(c);
  mcloc(i) = mcloc(i) - sampsize;
  if xver == 1
    %plot cross-correlations
    subplot(1,2,1)
    plot(lags(1:intv:end),c(1:intv:end))
    title('Cross-Correlations of Second 1 with all other Seconds')
    hold on
    %plot same cross-correlations, but zoomed in
    subplot(1,2,2)
    plot(lags(1:intv:end),c(1:intv:end), ...
	 'LineWidth',1,'Color',[0 0 0]+i/(rlens+1))
    title(sprintf('%6.4f at %4i',mc(i),mcloc(i)),'FontSize',20)
    ylim([0.979 1.001])
    if i == rlens
      ylim([min(cross(:,sampsize))-0.001*min(cross(:,sampsize)) ...
		max(cross,[],'all')+0.001*max(cross,[],'all')])
    end
    hold on
    %pause
  end
end

%keyboard
