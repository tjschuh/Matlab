function UTMmat = plotcontUTM(res)
% UTMmat = PLOTCONTUTM(res)
%
% Plot UTM zones and give the coordinates for each zone
%
% INPUT:
%
% res        0 ignore antarctica and artic for simplicity
%
% OUTPUT:
%
% UTMmat     matrix containing UTM zone info for each block
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 4/30/2021

defval('res',0)

% because the UTM zones in the antartic and artic latitudes
% don't behave the same as the other zones, res=0 omits them
if res == 0
    % plotting
    lonint = 6;
    latint = 8;
    bound = 80;

    axlim = plotcont;
    ylim([-bound bound])
    xlim([0 axlim(2)])
    hold on
    for i = lonint:lonint:axlim(2)-lonint
        xline(i,'r')
        hold on
    end
    for j = 0:latint:bound
        if j == 0
            yline(j,'r')
            hold on
        else
            yline(j,'r')
            hold on
            yline(-j,'r')
            hold on
        end
    end

    % calculate the UTM zone for each block
    % store the info in an array that follows
    % the order on the map
    r = 19;
    for la = 0:latint:2*(bound-latint)
        cf = 1;
        cr = 60;
        for lo = 0:lonint:(axlim(2)-lonint)/2
                [~,~,utmzon] = deg2utm(la-bound,lo);
                UTMmat{r,cf} = utmzon;
                [~,~,utmzon] = deg2utm(la-bound,-lo-lonint);
                UTMmat{r,cr} = utmzon;
                cf = cf + 1;
                cr = cr - 1;
        end
        r = r - 1;
    end
end

% future additions

% generate another matrix correpsonding to the UTMmat, but it has
% the bottom left lat,lon of of that UTM zone

% make function input one of the UTM zones and then you get
% a zoomed in plot of just that UTM zone