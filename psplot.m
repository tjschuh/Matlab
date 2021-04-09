function psplot(fname1,fname2)

defval('fname1','PORT-bdata30m-equal')
defval('fname2','STBD-bdata30m-equal')
  
a = load(fname1);
b = load(fname2);
c = str2num(fname1(11:12));
d = str2num(fname2(11:12));

f = mean(a(:,3));
g = mean(b(:,3));
u = 1e8;

ah(1) = subplot(2,1,1);
plot([0:size(a,1)-1]*c,[a(:,3)-f]*u)
grid on
%xlim([])
%ylim([])
title(sprintf('%s The Mean is %f',fname1,f))

% cosmetics
longticks(ah)
