function [ dataOut,freqfilt,f ] = freqfiltbp(dataIn,cutoffs,Fs,numdev,dim)
% freqfiltbp filters the signal by transforming to the frequency domain and
% applying a gaussian of a certain width.
%   [dataOut,freqfilt,f] = freqfiltbp(dataIn,cutoffs,Fs,numdev,dim)
%
%   Makes a gaussian frequency filter
%   dataIn = time-series data to be filtered
%   cutoffs = lower and upper limit of filter
%   Fs = sampling rate
%   numdev = # of standard deviations each cutoff should be from the center
%           frequency
%   dim = dimension to act along
%   
%   dataOut = filtered data
%   freqfilt = frequency filter used
%   f = frequency axis to use to plot freqfilt
%
%   Created by: Keith Doelling
%   Date: June 23, 2014


%   get frequency axis
% dataIn(:,end) = [];
f = (1:size(dataIn,dim)) - 1;
f = f./length(f);
f = f.*Fs;

% build frequency filter
% if two cutoffs build bandpass
if length(cutoffs) == 2
    [~,indf(1)] = min(abs(f-cutoffs(1)));
    [~,indf(2)] = min(abs(f-cutoffs(2)));
    if ~mod(size(dataIn,dim),2)
        ff = normpdf(f(1:length(f)/2),f(indf(1)),numdev);
        ff2 = normpdf(f(1:length(f)/2),f(indf(2)),numdev);
        ff(indf(1):end) = max(ff);
        ff2(1:indf(2)) = max(ff2);
        if cutoffs(2) > cutoffs(1)
            freqfilt = min(ff,ff2);
        elseif cutoffs(2) <= cutoffs(1)
            freqfilt = max(ff,ff2);
        end
        freqfilt = freqfilt([1:length(f)/2 length(f)/2:-1:1]);
    else
        ff = normpdf(f,f(indf(1)),numdev);
        ff2 = normpdf(f,f(indf(2)),numdev);
        ff(indf(1):end) = max(ff);
        ff2(1:indf(2)) = max(ff2);
        freqfilt = min(ff,ff2);

        freqfilt((end+3)/2:end) = freqfilt((end-1)/2:-1:1);
    end
% If one cutoff build lowpass
else
    indf = nearest(f,cutoffs);
    if ~mod(length(dataIn),2)
        freqfilt = normpdf(f(1:length(f)/2),cutoffs,numdev);
        freqfilt(1:indf) = max(freqfilt);
        freqfilt = freqfilt([1:length(f)/2 length(f)/2:-1:1]);
    else
        freqfilt = normpdf(f(1:round(length(f)/2)),cutoffs,numdev);
        freqfilt(1:indf) = max(freqfilt);
        freqfilt = freqfilt([1:end end-1:-1:1]);  
    end
end
freqfilt = freqfilt./max(freqfilt);

% fit size to the matrix of dataIn
freqfilt = shiftdim(freqfilt,2-dim);
siz = size(dataIn);
siz(dim) = 1;
freqfilt = repmat(freqfilt,siz);

% apply filter to frequency data
fqdata = fft(dataIn,[],dim);
fqfiltdata = fqdata.*freqfilt;

% convert back to time signal
dataOut = ifft(fqfiltdata,[],dim,'symmetric');
end

