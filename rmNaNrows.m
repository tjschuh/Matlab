function data=rmNaNrows(data)
% data=RMNANROWS(data)
%
% given a matrix, if a row has
% a NaN in even a single column
% remove the entire row    
%
% INPUT:
%
% data            standard NxM data matrix
%
% OUTPUT:
%
% modified data   same input data matrix, but with no NaN rows
%
% TESTED ON: 9.4.0.813654 (R2018a)
%
% Originally written by tschuh-at-princeton.edu, 09/03/2021

rows=any(isnan(data),2);
data(rows,:)=[];    