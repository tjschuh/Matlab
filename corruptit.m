function A=corruptit(A,N)
% A=CORRUPTIT(A,N)
%
% INPUT:
%
% A      A matrix
% N      A measure for the number of data drops
%
% OUTPUT:
%
% A      Channel-corruption of it
%
% TESTED ONN9.8.0.1451342 (R2020a) Update 5
% 
% Last modified by fjsimons-at-alum.mit.edu, 09/11/2020

defval('A',repmat([1 2 3 4],randi(1000),1))
defval('N',3)

% A random number of random numbers the size of A is used to skip
c=unique(randi(prod(size(A)),1,randi(N)));
% The data drop and channel switch and padded at the end
A=reshape([A(skip(1:prod(size(A)),c)) nan(1,length(c))],size(A,1),[]);
