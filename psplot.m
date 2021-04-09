function psplot(fnames)

defval('fnames',{'PORT-bdata30m-equal','STBD-bdata30m-equal'})

figure(gcf)
clf

u = 1e8;

for index=1:length(fnames)
  a = load(fnames{index});
  c = str2num(fnames{index}(11:12));
  f = mean(a(:,3));

  ah(index) = subplot(length(fnames),1,index);

  plot([0:size(a,1)-1]*c,[a(:,3)-f]*u)
  grid on
  title(sprintf('%s The Mean is %f',fname{index},f))

  % Cosmetics
  longticks(ah)
end

