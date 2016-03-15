function [ y ] = rms( x,dim )
% y = rms Calculates the root mean square of a time signal
%   Detailed explanation goes here

if nargin < 2
    y = sqrt(nanmean((x).^2));
else
    y = sqrt(nanmean((x).^2,dim));
end
end

