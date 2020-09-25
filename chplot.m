for file = 0
file
% Open file, turn it into matrix, and then
% reshape it into a 4 "channel" matrix
str = sprintf('file%d.data',file);
fid = fopen(str);
raw = fread(fid,inf,'int16');
FourChan = reshape(raw,4,[]);

run challocate.m

% Plotting section
for i = 1:4
    if i == 1
      subplot(4,1,1);
      plot(shift(1,:),'color',[0.4660 0.6740 0.1880])
      title('Pre-Amped Acoustic Data')
      xlim([0 24000000])
      xticks(0:2000000:24000000)
      xticklabels({})
      %ylim([-250 250])
      ax = gca;
      ax.XGrid = 'on';
      ax.YGrid = 'off';
      ax.GridColor = [0 0 0];
      ax.TickLength = [0 0];
    elseif i == 2
      subplot(4,1,2);
      plot(shift(2,:),'color',[0.6350 0.0780 0.1840])
      title('Bandpassed Acoustic Data')
      xlim([0 24000000])
      xticks(0:2000000:24000000)
      xticklabels({})
      %ylim([7000 7600])
      ax = gca;
      ax.XGrid = 'on';
      ax.YGrid = 'off';
      ax.GridColor = [0 0 0];
      ax.TickLength = [0 0];
    elseif i == 3
      subplot(4,1,3);
      plot(shift(3,:),'k')
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
      title('Low-Frequency Hydrophone')
      xlim([0 24000000])
      xticks(0:2000000:24000000)
      xticklabels({'0','5','10','15','20','25','30','35','40','45','50','55','60'})
      xlabel('Time (seconds)')
      %ylim([3400 3550])
      ax = gca;
      ax.XGrid = 'on';
      ax.YGrid = 'off';
      ax.GridColor = [0 0 0];
      ax.TickLength = [0 0];
    end
end
sgtitle(['File ',num2str(file)])

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

%clearvars -except file

end
