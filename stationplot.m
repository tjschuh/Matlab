function novatel1(stbd,port,jax)
% Makes the first
%
% Written by 

defval('stbd',[278 28])
defval('port',[284 24])
defval('jax',[284 24])

% Define
legs={'starboard','port','Jaxport'};
cols={'b','r','g'};
symbs={'*','o','s'};

% Everywhere below is plotting
ah=krijetem(subnum(2,1));

for index=1:length(ah)
    axes(ah(index))
    plotcont([],[],7)
    plotplates
    hold on
    ps(index)=plot(stbd(1),stbd(2),symbs{1});
    pp(index)=plot(port(1),port(2),symbs{2});
    pj(index)=plot(port(1),port(2),symbs{3});
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
l=legend([ps(2) pp(2) pj(2)],legs);
longticks(ah)

for index=1:length(pp)
    set(ps(index),'MarkerFaceColor',cols{1})
    set(pp(index),'MarkerFaceColor',cols{2})
    set(pj(index),'MarkerFaceColor',cols{3})
end

end


