function varargout = mesh3d(bound,int,cplanes)
% MESH3D(bound,int,cplanes)
%
% Create a 3D mesh in x,y,z with each coordinate going from -bound to
% +bound with a spacing of int
%
% INPUT:
%
% bound       boundary of mesh, bound > 0 (default: 10)
% int         spacing between each mesh point, must evenly divide 2*bound (default: 5)
% cplanes     switch to turn on/off cross-plane generation (default: 1/on) 
%
% OUTPUT:
%
% xyz       3 column mesh with x y z coordinates
%
% EXAMPLE:
%
% xyz=mesh3d(5,2,1);
%
% Originally written by tschuh-at-princeton.edu, 03/15/2022
% Last modified by tschuh-at-princeton.edu, 04/25/2022

defval('bound',10)
defval('int',5)
defval('cplanes',1)

if mod(2*bound,int) ~= 0
    error('int must evenly divide 2*bound')
end

xn = -bound:int:bound;
yn = -bound:int:bound;
zn = -bound:int:bound;

xyz = zeros(length(xn)*length(yn)*length(zn),3);

counter = 1;
for i=1:length(xn)
    for j=1:length(yn)
        for k=1:length(zn)
            xyz(counter,1) = xn(i);
            xyz(counter,2) = yn(j);
            xyz(counter,3) = zn(k);
            counter = counter + 1;
        end
    end
end

% if cplanes is turned on, output only cross-planes
if cplanes == 1
    % only save cross-planes where x = 0, y = 0, z = 0
    x0 = xyz(xyz(:,1) == 0,:);
    y0 = xyz(xyz(:,2) == 0,:);
    z0 = xyz(xyz(:,3) == 0,:);
    % get rid of duplicate rows
    xyz = unique([x0; y0; z0],'rows');
end

% optional output
varns={xyz};
varargout=varns(1:nargout);