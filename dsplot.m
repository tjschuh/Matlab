function dsplot(fnames,u)
% DSPLOT(fnames,u)
%
% INPUT:
%
% fnames   input file names, must be 2 files in a cell array
% u        unit multiplier
%
% Example:
%
% dsplot({'oneofthem','theotherone'})
%  
% TESTED ON: 9.8.0.1451342 (R2020a) Update 5
%
% Originally written by tschuh@princeton.edu, 4/9/2021
  
defval('fnames',{'PORT-bdata30m-equal','STBD-bdata30m-equal'})
defval('u',1)

figure(gcf)
clf

for index=1:length(fnames)
  a{index} = load(fnames{index});
  c{index} = 30;%str2num(fnames{index}(11:12));
end  

diferm(c{1},c{2})

% Calculate the distance
d=sqrt([a{1}(:,1)-a{2}(:,1)].^2+[a{1}(:,2)-a{2}(:,2)].^2+[a{1}(:,3)-a{2}(:,3)].^2);

% No more loop
ah = gca;
% compute the 3d distance of these 3 points
f = mean(d);
p = plot([0:size(a{1},1)-1]*c{1},[d-f]*u);
grid on
title(sprintf('%s %s The Mean is %f',fnames{1},fnames{2},f))
 
% Cosmetics
longticks(ah)

set(p,'LineWidth',1.5)
