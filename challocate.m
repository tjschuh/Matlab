function [FourChanS,jumps] = challocate(FourChan)
% [FourChanS,jumps] = CHALLOCATE(FourChan)
%
% INPUT:
%
% FourChan     the 4-row matrix containing the raw, reshaped data from file
%
% OUTPUT:
%
% FourChanS    4-row matrix that has rows correctly shifted around
%              so the time channel is always in row 3
% jumps        the number of times the data "jumped" and needed to be corrected
%              a jump is where all the rows suddenly rearrange themselves
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Written by tschuh@princeton.edu, 10/09/2020

% This is the channel allocator
% It goes through each row of FourChan
% and looks for the "Time" channel

buffer = 0;
jumps = 0;
while buffer == 0
OneMat = ones(1,size(FourChan,2)); %builds an array of 1's with length=#ofCols of FourChan 
for j = 1:4
    OneChan = FourChan(j,:);
    Low = (OneChan > 4900 & OneChan <= 5300);
    High = (OneChan > 5300 & OneChan < 5700);
    if Low + High == OneMat
       buffer = 1;
       break
    else
       if j == 4
          %means there was a channel jump and we need to call chswitch
          jumps = 1;
          [FourChan,jumps] = chswitch(FourChan,jumps);
	  break
       else
	  %j<4, so keep looking for time channel
       end
    end	
end
end
      
% these if/else statements correctly organize the rows of the FourChan
% matrix, creating the FourChanS matrix in the process
if j == 1
      FourChanS(1,:) = FourChan(3,:);
      FourChanS(2,:) = FourChan(4,:);
      FourChanS(3,:) = FourChan(1,:);
      FourChanS(4,:) = FourChan(2,:);
elseif j == 2
      FourChanS(1,:) = FourChan(4,:);
      FourChanS(2,:) = FourChan(1,:);
      FourChanS(3,:) = FourChan(2,:);
      FourChanS(4,:) = FourChan(3,:);
elseif j == 3
      FourChanS = FourChan;
elseif j == 4
      FourChanS(1,:) = FourChan(2,:);
      FourChanS(2,:) = FourChan(3,:);
      FourChanS(3,:) = FourChan(4,:);
      FourChanS(4,:) = FourChan(1,:);
else
      FourChanS = FourChan;
end
