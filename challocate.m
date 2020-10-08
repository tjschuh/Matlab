function [shift,jumps] = challocate(FourChan)
% [shift,jumps] = CHALLOCATE(FourChan)
%
% INPUT:
%
% FourChan     the 4-row matrix containing the raw, reshaped data from file
%
% OUTPUT:
%
% shift        4-row FourChan matrix that has rows correctly shifted around
%              so the time channel is always in row 3
% jumps        the number of times the data "jumped" and needed to be corrected
%              a jump is where all the rows suddenly rearrange themselves
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Written by tschuh@princeton.edu, 09/04/2020

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
% matrix, creating the shift matrix in the process
if j == 1
      shift(1,:) = FourChan(3,:);
      shift(2,:) = FourChan(4,:);
      shift(3,:) = FourChan(1,:);
      shift(4,:) = FourChan(2,:);
elseif j == 2
      shift(1,:) = FourChan(4,:);
      shift(2,:) = FourChan(1,:);
      shift(3,:) = FourChan(2,:);
      shift(4,:) = FourChan(3,:);
elseif j == 3
      shift = FourChan;
elseif j == 4
      shift(1,:) = FourChan(2,:);
      shift(2,:) = FourChan(3,:);
      shift(3,:) = FourChan(4,:);
      shift(4,:) = FourChan(1,:);
else
      shift = FourChan;
end
