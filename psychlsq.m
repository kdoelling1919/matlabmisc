function [ sse ] = psychlsq( x,y,mu,sig,chance,ceil)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = x(:);
y = y(:);

yfit = simpsych(x,mu,sig,chance,ceil);
err = yfit - y;
sse = sum(err.^2);


end

