function [ y ] = simgauss( x, mu, sig,mn,mx )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 4;
    mn = .5;
    mx = 1;
elseif nargin <5
    mx = 1;
end

% if chance < 0 || chance >1
%     error('Chance must be between 0 and 1');
% end
buf = normpdf(x,mu,sig);
y = mn + (mx-mn).*buf./max(buf);
end

