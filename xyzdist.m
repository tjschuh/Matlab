function xyzdist(file1,file2,xc)
% XYZDIST(file1,file2,xc)
%
% Takes in 2 data files containing xyz positions
% and computes the 3D Euclidean distance between
% corresponding points in the data files
%
% INPUT:
%
% file1     columnized data with xyz positions in meters
% file2     columnized data with xyz positions in meters
% xc        column number of files where xyz data begins [default: 3]
%    
% OUTPUT:
%
% separation distance vs. time of the points in both files
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 09/29/2021

% this will eventually become perimeter calculation since
% that is probably more accurate than just 3D distance
% between 2 points
    
data1=load(file1);
data2=load(file2);    

defval('xc',3);
yc=xc+1;
zc=xc+2;

% will eventually need to adjust how we keep time
% in case we are missing any seconds (we actually are)
% this is fine for now though

%allocate memory for speed
for i = 1:length(data1)
    dist(i,1) = sqrt((data1(i,xc)-data2(i,xc))^2 + (data1(i,yc)-data2(i,yc))^2 + (data1(i,zc)-data2(i,zc))^2);
end

time=1:length(data1);

% plot 3D Euclidean distance
figure
plot(time,dist(:,1),'r')
grid on
longticks
ttt=title("June 11-12, 2020 distance between Units 1 and 3");
xlabel("Time [s]")  
ylabel("Distance [m]")
xlim([0 length(data1)])

figdisp([],sprintf('dist'),'',2,[],'epstopdf') 