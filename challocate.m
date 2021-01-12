function [FourChanT1,jumps] = challocate(FourChan)
% [FourChanT1,jumps] = CHALLOCATE(FourChan)
%
% INPUT:
%
% FourChan     the 4-row matrix containing the raw, reshaped data from file
%
% OUTPUT:
%
% FourChanT1   4-row matrix that has rows correctly shifted around so the
%              timestamp channel is always in row 1, the raw acoustic data
%              always in row 2, the bandpassed acoustic data always in row 3,
%              and the low-frequency hydrophone always in row 4 
% jumps        the number of times the data "jumped" and needed to be corrected
%              a jump is where all the rows suddenly rearrange themselves
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 10/09/2020
% Last modified by tschuh@princeton.edu, 12/15/2020
  
% This is the channel allocator
% It goes through each row of FourChan, looks for the "Timestamp"
% channel, and organizes the other channels based on its location

% The timestamp channel then becomes the first row, the raw acoustic
% data becomes the second row, the bandpassed acoustic data becomes
% the third row, and the low-frequency hydrone becomes the fourth row

% If there is a "jump" in the FourChan data where the rows suddenly
% shift themselves without explanation, the chswitch function is
% called to find the jump(s) and make the appropriate corrections
  
buffer = 0;
jumps = 0;
while buffer == 0
OneMat = ones(1,size(FourChan,2)); %builds an array of 1's with length=#ofCols of FourChan 
for j = 1:4
    OneChan = FourChan(j,:);
    Low = (OneChan > 4900 & OneChan <= 5300);
    High = (OneChan > 5300 & OneChan < 5700);
    if Low + High == OneMat %if this is true, then this is the timestamp channel
       buffer = 1;
       break
    else
       if j == 4
          %means there was a channel jump and we need to call chswitch
          jumps = 1;
          [FourChan,jumps] = chswitch(FourChan,jumps);
	  break
       else
	  %j<4, so keep looking for timestamp channel
       end
    end	
end
end
      
% these if/else statements correctly organize the rows of the FourChan
% matrix, creating the FourChanS matrix in the process

% use the value of j from above to organize the rows

% i.e. j = 1 means the first row was timestamp so move
% it to the third row and the other channels follow suit,
% hydrophone was row 2 and goes to row 4, raw acoustic
% data was row 3 and goes to row 1, and bandpassed
% acoustic data was row 4 and goes to row 2

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

% FourChanT1 switches the rows of FourChanS so that
% the timestamp channel is in the first row, the raw
% acoustic data is in the second row, the bandpassed
% acoustic data is in the third row, and the low
% frequency hydrophone is in the fourth row

FourChanT1(1,:) = FourChanS(3,:);
FourChanT1(2,:) = FourChanS(1,:);
FourChanT1(3,:) = FourChanS(2,:);
FourChanT1(4,:) = FourChanS(4,:);
