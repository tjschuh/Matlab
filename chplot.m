function chplot(firstfile,lastfile)
% CHPLOT(firstfile,lastfile)
%
% INPUT:
%
% firstfile    the running number of the first file, e.g. 0, 1, 99, 362
% lastfile     the running number of the last file 
%
% OUTPUT:
%
% TESTED ON: 9.8.0.1417392 (R2020a) Update 4
%
% Written by tschuh@princeton.edu, 10/09/2020

% Assume the record length in seconds
rlens=60;
% Define a random segment length for inspection in seconds
rseg=10;
% Assume the sampling rate
Fs=400000;
% Moving average in seconds
mas=1;

% Moving average in left and right in samples
maslr=[mas mas]/2*Fs;

for file = firstfile:lastfile
  disp(sprintf('Working on file %3.3i / %3.3i',file,lastfile-firstfile+1))
  % Open file, turn it into matrix, and then
  % reshape it into a 4 "channel" matrix
  % Here is the filename
  fname=sprintf('file%d.data',file);
  sname=sprintf('file%d.mat',file);

  if exist(sname)~=2
    % Read the data
    fid = fopen(fname);
    FourChan = reshape(fread(fid,inf,'int16'),4,[]);
    fclose(fid);
    
    % Allocate the channels and identify jumps
    [FourChan,jumps] = challocate(FourChan);

    % Save it so next time you neither have to read it nor allocate it
    save(sname,FourChan,jumps)
  else
    load(sname)
  end
      
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
  % xtix={'0','5','10','15','20','25','30','35','40','45','50','55','60'};
  xtixl1=0:5:60;
  xtix1=xtixl1*Fs;
  xtixl2={tensec./Fs};
  %ylims=[1 2 ; 3 4 ; 5 6 ; 7 8];
  titl={'Pre-Amped Acoustic Data','Bandpassed Acoustic Data','Time','Low-Frequency Hydrophone'};

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
      priti(gca,xtixl1,titl{1},xtix1,[0 rlens*Fs])
      subplot(4,2,2)
      plot(sub(1,:),'color',[0.4660 0.6740 0.1880])
      priti(gca,xtixl2,[],(bot-lowbound):Fs:(Fs-1-(upbound-top)),[0 rseg*Fs])
    elseif i == 2
      subplot(4,2,3);
      plot(FourChan(2,:),'color',[0.6350 0.0780 0.1840])
      %yline(avg)
      ylim([min(FourChan(2,:))-abs(.01*min(FourChan(2,:))) max(FourChan(2,:))+(.01*max(FourChan(2,:)))])
      yticks([min(FourChan(2,:)) round(avg) max(FourChan(2,:))])
      priti(gca,xtixl1,titl{2},xtix1,[0 rlens*Fs])
      subplot(4,2,4)
      plot(sub(2,:),'color',[0.6350 0.0780 0.1840])
      priti(gca,xtixl2,[],(bot-lowbound):Fs:(Fs-1-(upbound-top)),[0 rseg*Fs])
    elseif i == 3
      subplot(4,2,5);
      plot(FourChan(3,:),'k')
      %yline(avg)
      ylim([4900 5700])
      yticks([5000 5600])
      priti(gca,xtixl1,titl{3},xtix1,[0 rlens*Fs])
      subplot(4,2,6);
      plot(sub(3,:),'k')
      priti(gca,xtixl2,[],(bot-lowbound):Fs:(Fs-1-(upbound-top)),[0 rseg*Fs])
    else
      subplot(4,2,7);
      plot(FourChan(4,:),'color',[0 0.4470 0.7410])
      hold on
      plot(mavgFourChan)
      %yline(avg)
      xlim([0 rlens*Fs])
      xlabel('Time [s]')
      ylim([min(FourChan(4,:))-abs(.01*min(FourChan(4,:))) max(FourChan(4,:))+(.01*max(FourChan(4,:)))])
      yticks([min(FourChan(4,:)) round(avg) max(FourChan(4,:))])
      priti(gca,xtixl1,titl{4},xtix1,[0 rlens*Fs])
      subplot(4,2,8);
      plot(sub(4,:),'color',[0 0.4470 0.7410])
      hold on
      plot(mavgsub)
      xlabel('Time [s])')
      priti(gca,xtixl2,[],(bot-lowbound):Fs:(Fs-1-(upbound-top)),[0 rseg*Fs])
    end
  end
  sgtitle(['Minute ',num2str(file)])
  a = annotation('textbox',[0.77 0.94 0 0],'String',['# of jumps = ' num2str(jumps)],'FitBoxToText','on');
  a.FontSize = 12;
  
  % Write the PDF image file
  saveas(gcf,sprintf('file%3.3i.pdf',file));

  %clf

end

% Cosmetics
function priti(ax,xtil,tit,xtic,xlimi)
ax.XGrid = 'on';
ax.YGrid = 'off';
ax.GridColor = [0 0 0];
ax.TickLength = [0 0];
xlim(xlimi)
xticks(xtic)
xticklabels(xtil)
title(tit)


