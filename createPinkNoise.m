% Creating pink (1/f) noise in the frequency domain
%
% Miki, 2011
% (Originally written to be used as modulated masker in
% a version of a CMR expt)

%% Setitng everything up

sampFreq = 44100; % sample frequency (Hz)
nyquistFreq = sampFreq/2;
stimDur = 0.3;                           % duration (s)
nSamp = sampFreq* stimDur;               % number of samples
rampDur = 0.05;  % 50 msec ramp

% Masker parameters
maskDur = 0.6;
maskSamp = sampFreq* maskDur;
m_rampDur = 0.01;  % 10 msec ramp

% Create ramp for Masker 
m_nRamp = floor(sampFreq * m_rampDur);

% Raised cosine ramp
r = .5 + .5*sin(linspace(-pi/2,pi/2,m_nRamp));  
%plot(r, 'b-');
maskRamp = [r, ones(1, maskSamp - m_nRamp * 2), fliplr(r)];

% Modulation frequency
mFreq = 10;

% Set modulator
mInd = 1;
m = (1:maskSamp) / sampFreq;               % modulator data preparation
m = 1 + mInd * sin(2 * pi * mFreq * m);    % sinusoidal modulation


%%

whiteNoise = randn(1,maskSamp);
y = fft(whiteNoise);


if mod( maskSamp, 2 )==0,
    
    % even case
    f = (1:maskSamp/2);
    f_= f(end-1:-1:1);
    
else
    
    % odd case
    f = (1:(maskSamp-1)/2);
    f_= f(end:-1:1);
    
end

y1= y./[1 f f_];  % be careful of whether its even or odd; 
pn = ifft(y1);

pinkN = pn';





