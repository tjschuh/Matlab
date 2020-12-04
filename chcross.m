function [tsample,cross] = chcross(FourChan,rlens)
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

%first one-second time snippet from FourChan
%tsample1 = FourChan(3,1:400000);
%second one-second time snipet from FourChan
%tsample2 = FourChan(3,400001:800000);

%cross-correlation of tsample1 with itself, normalized
%autocross = xcorr(tsample1)/max(xcorr(tsample1)); 

%cross = xcorr(tsample1,tsample2)/max(xcorr(tsample1,tsample2));

%figure
%plot(autocross)
%title('Cross-Correlation')
%hold on
%plot(cross)

%first one-second time snippet from FourChan  


%loop that computes subsequent one-second time snippets
%from FourChan and then cross-correlates them with tsample1
%figure
%title('Cross-Correlation')
%for i = 1:rlens
    %tsample2 = FourChan(3,1+400000*(i-1):400000*i);
    %[c,lags] = xcorr(tsample1,tsample2);
    %stem(lags(1:10000:end),c(1:10000:end))
    %if i == rlens
     % hold off
    %else
     % hold on
    %end
%end

%working code
FourChan(3,:) = FourChan(3,:) - min(FourChan(3,:));
sampsize = 400000;
int = 10000;

for i = 1:rlens
  tsample1 = FourChan(3,1:sampsize);
  tsample2 = FourChan(3,1+sampsize*(i-1):sampsize*i);
  [c,lags] = xcorr(tsample1,tsample2);
  subplot(1,2,1)
  plot(lags(1:int:end),c(1:int:end))
  hold on
end

for i = 1:rlens
  tsample1 = FourChan(3,1:sampsize);
  tsample2 = FourChan(3,1+sampsize*(i-1):sampsize*i);
  [c,lags] = xcorr(tsample1,tsample2);
  dummy(i,:) = c;
  subplot(1,2,2)
  plot(lags(1:int:end),c(1:int:end))
  if i == rlens
    ylim([min(dummy(:,400000))-0.001*min(dummy(:,400000))  max(dummy,[],'all')+0.001*max(dummy,[],'all')])
  end
  hold on
end
