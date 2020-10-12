function chplot(firstfile,lastfile,rseg)
% CHPLOT(firstfile,lastfile)
%
% INPUT:
%
% firstfile    the running number of the first file, e.g. 0, 1, 99, 362
% lastfile     the running number of the last file
% rseg         size of segment length, default value is 10 seconds
%
% OUTPUT:
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Written by tschuh@princeton.edu, 10/09/2020

% Assume the record length in seconds
rlens = 60;
% Define a random segment length for inspection in seconds
defval('rseg',10);
% Assume the sampling rate
Fs = 400000;
% Moving average in seconds
mas = 1;
% Moving average in left and right in samples
maslr = ([mas mas]/2)*Fs;

for file = firstfile:lastfile
  disp(sprintf('Working on file %3.3i (%3.3i of %3.3i)',file,file-firstfile+1,lastfile-firstfile+1))
  % Open file, turn it into matrix, and then
  % reshape it into a 4 "channel" matrix
  % Here is the filename
  fname = sprintf('file%d.data',file);
  %sname=sprintf('file%d.datb',file);
  %if exist(sname)~=2
    % Read the data
    fid = fopen(fname);
    FourChan = reshape(fread(fid,inf,'int16'),4,[]);
    fclose(fid);
    
    % Allocate the channels and identify jumps
    [FourChan,jumps] = challocate(FourChan);

    % Save it so next time you neither have to read it nor allocate it
    %save(sname,'FourChan','jumps')
    %fid = fopen(sname,'w');
    %fwrite(fid,FourChan,'int16');
    %fclose(fid);
  %else
    %disp(sprintf('loading file %s',sname))
    %load(sname)
    %fid = fopen(sname);
    %FourChan = reshape(fread(fid,inf,'int16'),4,[]);
    %fclose(fid)
  %end

  % Define a random segment of a certain length
  lowbound = randi(size(FourChan,2)-rseg*Fs-1);
  upbound = lowbound + rseg*Fs-1;
  sub = FourChan(:,lowbound:upbound);
  bot = Fs*ceil(lowbound/Fs);
  top = Fs*floor(upbound/Fs);
  tensec = [bot:Fs:top];

  % Plotting section
  % adjust min/max thing! [left bottom width height]
  set(0,'defaultfigureposition',[500 500 600 600])
  xtixl1 = 0:5:60;
  xtix1 = xtixl1*Fs;
  xlimit1 = [0 rlens*Fs];
  xtixl2 = tensec/Fs;
  xtix2 = (bot-lowbound):Fs:((10*Fs)-1-(upbound-top));
  xlimit2 = [0 rseg*Fs];
  titl = {'Pre-Amped Acoustic Data','Bandpassed Acoustic Data','Time','Low-Frequency Hydrophone'};
  
  % Loop over the panels 
  for i = 1:4
    avg = mean(FourChan(i,:));
    mavgFourChan = movmean(FourChan(4,:),maslr);
    mavgsub = movmean(sub(4,:),maslr);
    if i == 1
      subplot(4,2,1);
      plot(FourChan(1,:),'color',[0.4660 0.6740 0.1880])
      %yline(avg)
      ylim([min(FourChan(1,:))-abs(.05*min(FourChan(1,:))) max(FourChan(1,:))+(.05*max(FourChan(1,:)))])
      yticks([min(FourChan(1,:)) round(avg) max(FourChan(1,:))])
      cosmo(gca,titl{1},xlimit1,xtix1,xtixl1)
      subplot(4,2,2)
      plot(sub(1,:),'color',[0.4660 0.6740 0.1880])
      cosmo(gca,[],xlimit2,xtix2,xtixl2)
    elseif i == 2
      subplot(4,2,3);
      plot(FourChan(2,:),'color',[0.6350 0.0780 0.1840])
      %yline(avg)
      ylim([min(FourChan(2,:))-abs(.01*min(FourChan(2,:))) max(FourChan(2,:))+(.01*max(FourChan(2,:)))])
      yticks([min(FourChan(2,:)) round(avg) max(FourChan(2,:))])
      cosmo(gca,titl{2},xlimit1,xtix1,xtixl1)
      subplot(4,2,4)
      plot(sub(2,:),'color',[0.6350 0.0780 0.1840])
      cosmo(gca,[],xlimit2,xtix2,xtixl2)
    elseif i == 3
      subplot(4,2,5);
      plot(FourChan(3,:),'k')
      %yline(avg)
      ylim([4900 5700])
      yticks([5000 5600])
      cosmo(gca,titl{3},xlimit1,xtix1,xtixl1)
      subplot(4,2,6);
      plot(sub(3,:),'k')
      ylim([4900 5700])
      yticks([5000 5600])
      cosmo(gca,[],xlimit2,xtix2,xtixl2)
    else
      subplot(4,2,7);
      plot(FourChan(4,:),'color',[0 0.4470 0.7410])
      hold on
      plot(mavgFourChan)
      %yline(avg)
      xlabel('Time [s]')
      ylim([min(FourChan(4,:))-abs(.01*min(FourChan(4,:))) max(FourChan(4,:))+(.01*max(FourChan(4,:)))])
      yticks([min(FourChan(4,:)) round(avg) max(FourChan(4,:))])
      cosmo(gca,titl{4},xlimit1,xtix1,xtixl1)
      subplot(4,2,8);
      plot(sub(4,:),'color',[0 0.4470 0.7410])
      hold on
      plot(mavgsub)
      xlabel('Time [s]')
      cosmo(gca,[],xlimit2,xtix2,xtixl2)
    end
  end
  sgtitle(['Minute ',num2str(file)])
  a = annotation('textbox',[0.77 0.94 0 0],'String',['# of jumps = ' num2str(jumps)],'FitBoxToText','on');
  a.FontSize = 12;
  
  % Write the PDF image file
  saveas(gcf,sprintf('file%3.3i.pdf',file));

  if firstfile == lastfile || file == lastfile
    %if working with 1 file, or working on the last file of a set, don't clf
  else
    clf
  end

end

% Cosmetics
function cosmo(ax,titl,xlimit,xtix,xtixl)
ax.XGrid = 'on';
ax.YGrid = 'off';
ax.GridColor = [0 0 0];
ax.TickLength = [0 0];
title(titl)
xlim(xlimit)
xticks(xtix)
xticklabels(xtixl)
