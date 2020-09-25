% This is the channel allocator
% It goes through each row of FourChan
% and looks for the "Time" channel

counter = 0;
OneMat = ones(1,size(FourChan,2)); %builds an array of 1's with length=#ofCols of FourChan
for j = 1:4
    OneChan = FourChan(j,:);
    Low = (OneChan > 4900 & OneChan < 5400);
    High = (OneChan > 5400 & OneChan < 5700);
    if Low + High == OneMat
       break
    else
      if j == 4
         %means there was a channel jump and we need to run chswitch.m
         counter = 1;
         run chswitch.m
	 break
      else
	%j<4, so keep looking for time channel
      end
    end	
end

if counter == 0
j
      
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
else
   % chswitch.m ran so shift was built in that script
end
	
