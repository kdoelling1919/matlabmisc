function [ sse ] = psychlsqn( x,y,mu,sig,chance,ceil)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = x(:);
if ~ismember(length(x),size(y)) || ~ismatrix(y)
    error('Bad inputs')
end

if ~isequal(size(x,1),size(y,1))
    y = y';
end

% if ~isscalar(sig)
%     error('Bad Inputs')
% end
if length(mu) ~= size(y,2)
    error('Bad inputs')
end
nonans= isnan(x) | sum(isnan(y),2);
x = x(~nonans);
y = y(~nonans,:);

for i=1:size(y,2)
    yfit(:,i) = simpsych(x,mu(i),sig(i),chance(i),ceil(i)); 
end
err = yfit - y;
ss(i) = sum(err(:).^2);
sse = mean(ss);
end

