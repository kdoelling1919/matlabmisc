function [ y ] = simpsych( x, mu, sig, chance,ceil )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 4;
    chance = .5;
    ceil = 1;
elseif nargin <5
    ceil = 1;
end

% if chance < 0 || chance >1
%     error('Chance must be between 0 and 1');
% end

y = chance + (ceil-chance).*normcdf(x,mu,sig);
end

