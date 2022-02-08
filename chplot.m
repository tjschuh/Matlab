function chplot(firstfile,lastfile,rseg,plotver,xver)%,blah)
% CHPLOT(firstfile,lastfile)
%
% INPUT:
%
% firstfile    the running number of the first file, e.g. 0, 1, 99, 362
% lastfile     the running number of the last file
% rseg         size of segment length (default value is 5 seconds)
% plotver      switch (1 or 0) to on/off plotting feature (default is on)
% xver         switch (1 or 0) to turn on/off cross-correlation feature (default is off)
%
% OUTPUT:
%  
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Originally written by tschuh@princeton.edu, 10/09/2020
% Last modified by tschuh@princeton.edu, 12/17/2020
  
% By default, plotting feature is turned on
defval('plotver',1);
% By default, cross-correlation feature is turned off
defval('xver',0);
% Assume the record length in seconds
rlens = 60;
% Define a random segment length for inspection in seconds
defval('rseg',5);
% Assume the sampling rate
Fs = 400000;
% Moving average in seconds
mas = 1;
% Moving average left and right in units of samples
maslr = ([mas mas]/2)*Fs;

for file = firstfile:lastfile
  disp(sprintf('Working on file %3.4i (%3.4i of %3.4i)',file,file-firstfile+1,lastfile-firstfile+1))
  % Open file, turn it into matrix, and then
  % reshape it into a 4 "channel" matrix
  % Here is the filename
  fname = sprintf('file%d.data',file);
  sname=sprintf('file%d.datb',file);
  if exist(sname) ~= 2
    % Read the data
    fid = fopen(fname);
    FourChan = reshape(fread(fid,inf,'int16'),4,[]);
    fclose(fid);
    
    % Allocate the channels and identify jumps
    [FourChan,jumps] = challocate(FourChan);

    % Save it so next time you neither have to read it nor allocate it
    save(sname,'FourChan','jumps')
    fid = fopen(sname,'w');
    fwrite(fid,FourChan,'int16');
    fclose(fid);
  else
    disp(sprintf('loading file %s',sname))
    fid = fopen(sname);
    FourChan = reshape(fread(fid,inf,'int16'),4,[]);
    fclose(fid);
  end
  
  % Call cross-correlation function if xver is "on"
  if xver == 1
     [~,~,mc,mcloc] = chcross(FourChan,rlens,xver);
  end

  % Plotting section, called only if plotver is "on"
  if plotver == 1

  % Set default figure position, [left bottom width height]
  set(0,'defaultfigureposition',[550 150 850 650])
  %previously set as [500 500 600 600]
  
  % Define a random segment of a certain length
  lowbound = randi(size(FourChan,2)-rseg*Fs-1);
  upbound = lowbound + rseg*Fs-1;
  sub = FourChan(:,lowbound:upbound);
  bot = Fs*ceil(lowbound/Fs);
  top = Fs*floor(upbound/Fs);
  tensec = [bot:Fs:top];

  % Calculate some averages
  for i = 1:size(FourChan,1)
    avg(i) = mean(FourChan(i,:));
  end  
  mavgFourChan = movmean(FourChan(4,:),maslr);
  mavgsub = movmean(sub(4,:),maslr);

  % Open a figure to not overwrite cross-correlation plot
  f=figure;
  f.Position = [250 500 1100 600];

  % Colors
  color1 = [0 0 0];
  color2 = [0.4660 0.6740 0.1880];
  color3 = [0.6350 0.0780 0.1840];
  color4 = [0 0.4470 0.7410];

  % Plot PSD
  xtixl1 = 0:25:200;
  xtix1 = xtixl1*1000;
  xlimit1 = [0 Fs/2];
  titl1 = {'PSD Estimate'};
  
  subplot(4,3,1)
  [pxx,f] = periodogram(FourChan(1,:),hamming(length(FourChan(1,:))), ...
	    length(FourChan(1,:)),Fs);
  plot(f,10*log10(pxx),'color',color1)
  cosmo(gca,titl1{1},xlimit1,xtix1,[])

  subplot(4,3,4)
  [pxx,f] = periodogram(FourChan(2,:),hamming(length(FourChan(2,:))), ...
	    length(FourChan(2,:)),Fs);
  plot(f,10*log10(pxx),'color',color2)
  cosmo(gca,[],xlimit1,xtix1,[])
  
  subplot(4,3,7)
  [pxx,f] = periodogram(FourChan(3,:),hamming(length(FourChan(3,:))), ...
	    length(FourChan(3,:)),Fs);
  plot(f,10*log10(pxx),'color',color3)
  cosmo(gca,[],xlimit1,xtix1,[])
  
  subplot(4,3,10)
  [pxx,f] = periodogram(FourChan(4,:),hamming(length(FourChan(4,:))), ...
	    length(FourChan(4,:)),Fs);
  plot(f,10*log10(pxx),'color',color4)
  cosmo(gca,[],xlimit1,xtix1,xtixl1)
  xlabel('Frequency [kHz]')
  ylabel({'Power/frequency','[dB/Hz]'})
  
  % Plot FourChan
  xtixl2 = 0:5:60;
  xtix2 = xtixl2*Fs;
  xlimit2 = [0 rlens*Fs];
  titl2 = {'PPS & Timestamp', 'Pre-Amped 400 kHz Acoustic Data', ...
          '12.5 kHz Bandpassed Acoustic Data', 'Low-Frequency Hydrophone'};

  %ah(i) = subplot(4,2,2);
  subplot(4,3,2);
  plot(FourChan(1,:),'color',color1)
  ylim([4900 5700])
  yticks([5000 5600])
  cosmo(gca,titl2{1},xlimit2,xtix2,[])

  %ah(i) = subplot(4,2,5);
  subplot(4,3,5);
  plot(FourChan(2,:),'color',color2)
  ylim([min(FourChan(2,:))-abs(.05*min(FourChan(2,:))) ...
	max(FourChan(2,:))+(.05*max(FourChan(2,:)))])
  yticks([min(FourChan(2,:)) round(avg(2)) max(FourChan(2,:))])
  cosmo(gca,titl2{2},xlimit2,xtix2,[])

  subplot(4,3,8);
  plot(FourChan(3,:),'color',color3)
  ylim([min(FourChan(3,:))-abs(.01*min(FourChan(3,:))) ...
	max(FourChan(3,:))+(.01*max(FourChan(3,:)))])
  yticks([min(FourChan(3,:)) round(avg(3)) max(FourChan(3,:))])
  cosmo(gca,titl2{3},xlimit2,xtix2,[])

  subplot(4,3,11);
  plot(FourChan(4,:),'color',color4)
  hold on
  plot(mavgFourChan,'LineWidth',1.75)
  xlabel('Time [s]')
  ylim([min(FourChan(4,:))-abs(.001*min(FourChan(4,:))) ...
	max(FourChan(4,:))+(.001*max(FourChan(4,:)))])
  yticks([min(FourChan(4,:)) round(avg(4)) max(FourChan(4,:))])
  cosmo(gca,titl2{4},xlimit2,xtix2,xtixl2)
  
  % Plot sub
  xtixl3 = tensec/Fs;
  xtix3 = (bot-lowbound):Fs:((10*Fs)-1-(upbound-top));
  xlimit3 = [0 rseg*Fs];
  titl3 = {rseg + " Second Segment"};
  
  subplot(4,3,3)
  plot(sub(1,:),'color',color1)
  ylim([4900 5700])
  yticks([5000 5600])
  cosmo(gca,titl3{1},xlimit3,xtix3,[])

  subplot(4,3,6)
  plot(sub(2,:),'color',color2)
  cosmo(gca,[],xlimit3,xtix3,[])

  subplot(4,3,9);
  plot(sub(3,:),'color',color3) 
  cosmo(gca,[],xlimit3,xtix3,[])

  subplot(4,3,12);
  plot(sub(4,:),'color',color4)
  hold on
  plot(mavgsub,'LineWidth',1.75)
  xlabel('Time [s]')
  cosmo(gca,[],xlimit3,xtix3,xtixl3)
      
  sgtitle(['BIOSUnit2, Minute ',num2str(file)])

  if exist('jumps','var') ~= 0
    a = annotation('textbox',[0.77 0.94 0 0],'String',['# of jumps = ' num2str(jumps)],'FitBoxToText','on');
    a.FontSize = 12;
  else
    %jumps doesnt exist as a variable, so just ignore it
  end
  
  % Save a PDF
  figdisp(sprintf('file%3.4i',file),[],[],2,[],'epstopdf')
  
  if firstfile == lastfile || file == lastfile
    %if working with 1 file, or working on the last file of a set, don't clf
  else
    clf
  end
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
