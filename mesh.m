function varargout = mesh(bound,int)
% MESH(bound,int)
%
% Create a 3D mesh in x,y,z with each coordinate going from -bound to
% +bound with a spacing of int
%
% INPUT:
%
% bound     boundary of mesh, bound > 0 (default: 10)
% int       spacing between each mesh point, must evenly divide 2*bound (default: 5)
%
% OUTPUT:
%
% xyz       3 column mesh with x y z 
%
% EXAMPLE:
%
% xyz=mesh(5,2);
%
% Originally written by tschuh-at-princeton.edu, 03/15/2022

defval('bound',10)
defval('int',5)

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

% optional output
varns={xyz};
varargout=varns(1:nargout);