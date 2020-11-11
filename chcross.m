function [tsample,cross] = chcross(FourChan)
% CHPLOT(FourChan)
%
% INPUT:
%
% FourChan   the 4-row matrix containing the reshaped, correctly allocated data from file   
%
% OUTPUT:
%
% tsample    a 1-second time sample taken from the time channel of FourChan
% cross      cross-correlation data of tsample
%  
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Written by tschuh@princeton.edu, 10/30/2020

tsample = FourChan(3,1:400000);
cross = xcorr(tsample,tsample);

figure
plot(cross)
