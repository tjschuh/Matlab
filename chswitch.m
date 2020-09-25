% This is the channel switcher
% If a file has a "jump" in it,
% this script is called to find
% the jump and correctly adjust
% the channel order

% Things to improve:
% -Not a function, still just a script

OneChan = FourChan(1,:);
D = diff(OneChan);
thresh = 1500;
for p = 1:size(D,2)
    if abs(D(p)) > thresh
       %this may be a jump point, will check
       dd = FourChan(2,p+1) - FourChan(2,p);
       ddd = FourChan(3,p+1) - FourChan(3,p);
       dddd = FourChan(4,p+1) - FourChan(4,p);
       if abs(dd) > thresh && abs(ddd) > thresh && abs(dddd) > thresh
          %this is definitely a jump point
          Front = FourChan(:,1:p);
          Back = FourChan(:,p+1:end);
          break
       elseif abs(dd) > thresh && abs(ddd) > thresh
	  %still may be a jump point, but need to check surrounding points
	  abvdddd = FourChan(4,p+2) - FourChan(4,p+1);
	  beldddd = FourChan(4,p) - FourChan(4,p-1);
          if abs(abvdddd) > thresh
	     FourChan(4,p+1) = FourChan(4,p+2);
             Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
             break
	  elseif abs(beldddd) > thresh
             FourChan(4,p) = FourChan(4,p-1);
             Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
             break
	  else
	     Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
             break
	  end
       elseif abs(dd) > thresh && abs(dddd) > thresh
          %still may be a jump point, but need to check surrounding points
          abvddd = FourChan(4,p+2) - FourChan(4,p+1);
          belddd = FourChan(4,p) - FourChan(4,p-1);
          if abs(abvddd) > thresh
      	     FourChan(4,p+1) = FourChan(4,p+2);
             Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
      	     break
          elseif abs(belddd) > thresh
      	     FourChan(4,p) = FourChan(4,p-1);
             Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
      	     break
	  else
             Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
             break
          end
       elseif abs(ddd) > thresh && abs(dddd) > thresh
          %still may be a jump point, but need to check surrounding points
          abvdd = FourChan(4,p+2) - FourChan(4,p+1);
          beldd = FourChan(4,p) - FourChan(4,p-1);
          if abs(abvdd) > thresh
      	     FourChan(4,p+1) = FourChan(4,p+2);
             Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
      	     break
          elseif abs(beldd) > thresh
      	     FourChan(4,p) = FourChan(4,p-1);
             Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
      	     break
	  else
             Front = FourChan(:,1:p);
             Back = FourChan(:,p+1:end);
             break
          end
       else
	  %this is not actually a jump point
       end
    else
       if p == size(D,2)
          %didnt find any jump points
	  %this is a failsafe, but need to make
	  %sure that the script always finds a jump
	  Front = FourChan(:,1:1000);
          Back = FourChan(:,1001:end);
       else
          %this is not a jump point, continue looking
       end
    end
end

OneMat = ones(1,size(Front,2)); %builds an array of 1's with length=#ofCols of Front
for f = 1:4
    OneChan = Front(f,:);
    Low = (OneChan > 4900 & OneChan < 5400);
    High = (OneChan > 5400 & OneChan < 5700);
    if Low + High == OneMat
       break
    else
      
    end
end

% these if/else statements correctly organize the rows of the FourChan
% matrix, creating the shift matrix in the process
if f == 1
      FrontPrime(1,:) = Front(3,:);
      FrontPrime(2,:) = Front(4,:);
      FrontPrime(3,:) = Front(1,:);
      FrontPrime(4,:) = Front(2,:);
elseif f == 2
      FrontPrime(1,:) = Front(4,:);
      FrontPrime(2,:) = Front(1,:);
      FrontPrime(3,:) = Front(2,:);
      FrontPrime(4,:) = Front(3,:);
elseif f == 3
      FrontPrime = Front;
elseif f == 4
      FrontPrime(1,:) = Front(2,:);
      FrontPrime(2,:) = Front(3,:);
      FrontPrime(3,:) = Front(4,:);
      FrontPrime(4,:) = Front(1,:);
else
      FrontPrime = Front;
end

OneMat = ones(1,size(Back,2)); %builds an array of 1's with length=#ofCols of Back
for b = 1:4
    OneChan = Back(b,:);
    Low = (OneChan > 4900 & OneChan < 5400);
    High = (OneChan > 5400 & OneChan < 5700);
    if Low + High == OneMat
       break
    else
       if b == 4
          %must be a second jump, need to send Back
          %matrix through algortithm and split and stitch it
          %run chdoubswitch.m
       else

       end
    end
end

% these if/else statements correctly organize the rows of the FourChan
% matrix, creating the shift matrix in the process
if b == 1
      BackPrime(1,:) = Back(3,:);
      BackPrime(2,:) = Back(4,:);
      BackPrime(3,:) = Back(1,:);
      BackPrime(4,:) = Back(2,:);
elseif b == 2
      BackPrime(1,:) = Back(4,:);
      BackPrime(2,:) = Back(1,:);
      BackPrime(3,:) = Back(2,:);
      BackPrime(4,:) = Back(3,:);
elseif b == 3
      BackPrime = Back;
elseif b == 4
      BackPrime(1,:) = Back(2,:);
      BackPrime(2,:) = Back(3,:);
      BackPrime(3,:) = Back(4,:);
      BackPrime(4,:) = Back(1,:);
else
      BackPrime = Back;
end

FourChan = [FrontPrime BackPrime];

clear Front
clear Back
clear FrontPrime
clear BackPrime
