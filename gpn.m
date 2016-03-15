function [ pink ] = gpn( nSamp, desRMS )
%gpn generates pink noise of nSamp length with root mean square desRMS
%   Detailed explanation goes here

whiteNoise = randn(1,nSamp);

num_taps = 1000;

a = zeros(1,num_taps);
a(1) = 1;
for ii = 2:num_taps
a(ii) = (ii - 2.5) * a(ii-1) / (ii-1);
end
pink = filter(1,a,whiteNoise);

rmsNse = rms(pink);

pink = (desRMS/rmsNse).*pink';

end

