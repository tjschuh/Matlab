function chplot(firstfile,lastfile)
% CHPLOT(firstfile,lastfile)
%
% INPUT:
%
% firstfile    the first file the function will be used on
% lastfile      the last file the function will be used on
%
% OUTPUT:
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Written by tschuh@princeton.edu, 09/04/2020

for file = firstfile:lastfile
file
% Open file, turn it into matrix, and then
% reshape it into a 4 "channel" matrix
str = sprintf('file%d.data',file);
fid = fopen(str);
raw = fread(fid,inf,'int16');
FourChan = reshape(raw,4,[]);

[shift,jumps] = challocate(FourChan);

% Plotting section
% adjust min/max thing!
for i = 1:4
avg = mean(shift(i,:));
    if i == 1
      subplot(4,1,1);
      plot(shift(1,:),'color',[0.4660 0.6740 0.1880])
      yline(avg)
      title('Pre-Amped Acoustic Data')
      xlim([0 24000000])
      xticks(0:2000000:24000000)
      xticklabels({})
      ylim([min(shift(1,:))-abs(.05*min(shift(1,:))) max(shift(1,:))+(.05*max(shift(1,:)))])
      yticks([min(shift(1,:)) round(avg) max(shift(1,:))])
      ax = gca;
      ax.XGrid = 'on';
      ax.YGrid = 'off';
      ax.GridColor = [0 0 0];
      ax.TickLength = [0 0];
    elseif i == 2
      subplot(4,1,2);
      plot(shift(2,:),'color',[0.6350 0.0780 0.1840])
      yline(avg)
      title('Bandpassed Acoustic Data')
      xlim([0 24000000])
      xticks(0:2000000:24000000)
      xticklabels({})
      ylim([min(shift(2,:))-abs(.01*min(shift(2,:))) max(shift(2,:))+(.01*max(shift(2,:)))])
      yticks([min(shift(2,:)) round(avg) max(shift(2,:))])
      ax = gca;
      ax.XGrid = 'on';
      ax.YGrid = 'off';
      ax.GridColor = [0 0 0];
      ax.TickLength = [0 0];
    elseif i == 3
      subplot(4,1,3);
      plot(shift(3,:),'k')
      %yline(avg)
      title('Time')
      xlim([0 24000000])
      xticks(0:2000000:24000000)
      xticklabels({})
      ylim([4900 5700])
      yticks([5000 5600])
      ax = gca;
      ax.XGrid = 'on';
      ax.YGrid = 'off';
      ax.GridColor = [0 0 0];
      ax.TickLength = [0 0];
    else
      subplot(4,1,4);
      plot(shift(4,:),'color',[0 0.4470 0.7410])
      yline(avg)
      title('Low-Frequency Hydrophone')
      xlim([0 24000000])
      xticks(0:2000000:24000000)
      xticklabels({'0','5','10','15','20','25','30','35','40','45','50','55','60'})
      xlabel('Time (seconds)')
      ylim([min(shift(4,:))-abs(.01*min(shift(4,:))) max(shift(4,:))+(.01*max(shift(4,:)))])
      yticks([min(shift(4,:)) round(avg) max(shift(4,:))])
      ax = gca;
      ax.XGrid = 'on';
      ax.YGrid = 'off';
      ax.GridColor = [0 0 0];
      ax.TickLength = [0 0];
    end
end
sgtitle(['File ',num2str(file)])
a = annotation('textbox',[0.77 0.94 0 0],'String',['# of jumps = ' num2str(jumps)],'FitBoxToText','on');
a.FontSize = 12;

% this section adds leading zeros to the pdf names	 
if numel(num2str(file)) == 1
  filename = sprintf('file000%d.pdf',file);
elseif numel(num2str(file)) == 2
  filename = sprintf('file00%d.pdf',file);
elseif numel(num2str(file)) == 3
  filename = sprintf('file0%d.pdf',file);
else
  filename = sprintf('file%d.pdf',file);
end

saveas(gcf,filename);

fclose(fid);

clf

end
