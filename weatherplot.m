function test=weatherplot(file)
% WEATHERPLOT()
%
% INPUT:
%
% OUTPUT:
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 6/11/2021

wspd = load(file);
%t(:,1) = 1:length(wspd);
% col 1 is the time (every 10 minutes)
% col 2 is the wind speed measurements
%wspd = [t wspd];

switch n
    case 1 %hourly
        int = 6;
        counter = 1;
        for i=1:int:length(wspd)
            %take the average of every 6 data points to convert the data to hourly measurements
            test(counter,1) = mean(wspd(i:int*counter,1));
            counter = counter + 1;
        end
    case 2 %daily
        int=6*24;
end



%plot(wspd)