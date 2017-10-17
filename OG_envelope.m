function [ cbEnv,cf,xout ] = OG_envelope( x,Fs,fminmax, bandno )
%OG_envelope takes in acoustic signal and returns critical band envelopes
%   It is done "properly"
%   
%   x = acoustic signal (must be a vector)
%   Fs = sampling frequency
%   fminmax = [min max] of frequency range you want
%   bandno = number of critical bands you'd like (logarithmically spaced)
%
%   cbEnv = critical band envelopes
%   cf = center frequency of each band
%   xout = signal filtered into each critical band

if size(x,2) ~= 1
    x = x';
    if size(x,2) ~= 1
        error('x must be a vector')
    end
end

if numel(fminmax) ~= 2 && diff(fminmax) <= 0
    error('fminmax must be a 2-element vector with second element larger than first');
end

if bandno <= 0 || mod(bandno,1)
    error('bandno must be a positive integer')
end

bandlim = logspace(log10(fminmax(1)),log10(fminmax(2)),bandno+1);
bandlim = bandlim*2/Fs;

wnl = bandlim(1:end-1);
wnh = bandlim(2:end);
cf = (wnl+wnh)./2;
cf = cf*Fs/2;

cbEnv = zeros(length(x),length(wnl));
xout = cbEnv;

for m = 1:length(wnl)
    % filter the critical bands
    xout(:,m) = fu_CB_filter(x,length(x),wnl,wnh,m);
    cbEnv(:,m) = abs(hilbert(xout(:,m)));
end

end

