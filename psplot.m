function psplot(fnames,cn,u)

defval('fnames',{'PORT-bdata30m-equal','STBD-bdata30m-equal'})
defval('cn',3)
defval('u',[1e13 1e12 1e8 1]);

figure(gcf)

for index=1:length(fnames)
  a = load(fnames{index});
  c = str2num(fnames{index}(11:12));
  

  ah(index) = subplot(length(fnames),1,index);
  hold on
  if cn < 4
    f = mean(a(:,cn));
    p(index) = plot([0:size(a,1)-1]*c,[a(:,cn)-f]*u(cn));
  else
    % compute the 3d distance of these 3 points
    d = sqrt([a(:,1)-mean(a(:,1))].^2+[a(:,2)-mean(a(:,2))].^2+[a(:,3)-mean(a(:,3))].^2);
    f = mean(d);
    p(index) = plot([0:size(a,1)-1]*c,[d-f]*u(cn));
  end
  grid on
  title(sprintf('%s The Mean is %f',fnames{index},f))
 
  % Cosmetics
  longticks(ah)
end
set(p,'LineWidth',1.5)
