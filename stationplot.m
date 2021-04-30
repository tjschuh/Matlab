function stationplot(stbd,port,ref)
% STATIONPLOT(stbd,port,ref))
%
% Plots starboard and portside GPS receiver locations
% relative to a fixed reference station
%    
% INPUT:
%
% stbd     starboard GPS receiver coordinates in lat/lon
% port     portside GPS receiver coordinates in lat/lon
% ref      reference station coordinates in lat/lon
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by fjsimons@princeton.edu & tschuh@princeton.edu, 4/23/2021
% Last modified by tschuh@princeton.edu, 4/30/2021

%defval('blah',[lat lon])    
defval('stbd',[30.21 -81.06])
defval('port',[30.19 -80.18])

% default is Jacksonville, Fl
defval('ref',[30.19 -81.39])

stbd(2) = lon2y(stbd(2));
port(2) = lon2y(port(2));
ref(2) = lon2y(ref(2));

% Define
legs={'starboard','port','Refport'};
cols={'b','r','g'};
symbs={'*','o','s'};

% Everywhere below is plotting
ah=krijetem(subnum(2,1));

for index=1:length(ah)
    axes(ah(index))
    plotcont([],[],7)
    plotplates
    hold on
    ps(index)=plot(stbd(2),stbd(1),symbs{1});
    pp(index)=plot(port(2),port(1),symbs{2});
    pj(index)=plot(ref(2),ref(1),symbs{3});
    hold off
    axis tight
    box on
    grid on
end

% Cosmetics
axes(ah(1))
axis([230 330 0 60])
axes(ah(2))
axis([274 286 23.25 33])
l=legend([ps(2) pp(2) pj(2)],legs,'Location','southeast');
longticks(ah)

for index=1:length(pp)
    set(ps(index),'MarkerFaceColor',cols{1})
    set(pp(index),'MarkerFaceColor',cols{2})
    set(pj(index),'MarkerFaceColor',cols{3})
end

function y = lon2y(lon)
% converts user input lon coordinate to desired y
% coordinate between [0 360]
% required for plotting

if lon < 0
    y = 360 + lon;
elseif lon > 0
    y = 180 + lon;
else
    y = lon;
end