function [ tone, time ] = sintone( fq, t, fs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

time = (1:fs*length(fq)*t)./fs;


rmpLngth = .1;
tRmp = (1:rmpLngth*fs)./fs;
ampFq = 1./(rmpLngth*4);

swpLngth = .05;
% tSwp = time(fs*t - swpLngth*fs + 1:fs*t);
tSwp = time(1:swpLngth*fs);

tone = zeros(size(time));
phi = 0;
for n = 1:length(fq)

    buffer = sin(2*pi*fq(n)*time(1:fs*t)+phi);
    if n == 1;
        buffer(1:rmpLngth*fs) = (sin(2*pi*ampFq*tRmp).^2).*buffer(1:rmpLngth*fs);
    elseif n == length(fq)
        buffer(end-rmpLngth*fs+1:end) = (cos(2*pi*ampFq*tRmp).^2).*buffer(end-rmpLngth*fs+1:end);
    end
    
    anglebuf = asind(buffer);
    
    if n ~= length(fq)
        buffer(end-length(tSwp)+1:end) = chirp(tSwp,fq(n),tSwp(end),fq(n+1),'li',anglebuf(end-length(tSwp)+1));
    end
    
    phi = asin(buffer(end));
    if phi > acos(buffer(end-1))
        phi = -phi; 
    end
tone((n-1)*fs*t+1:n*fs*t) = buffer;
end


tone = tone';
end

