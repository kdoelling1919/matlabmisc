function [ mixedsig, adjsignal, adjnoise ] = adjustSNR( signal, noise, snr, sigornoise, desRMS, varargin )
%adjustSNR Mixes signal and noise so that Signal-to-Noise Ratio = SNR
%   Noise must be at least as long as signal. If signal is shorter than
%   noise then offset is needed to determine where the signal should be
%   placed
%   mixedsig = adjustSNR(signal,noise,SNR,sigornoise,offset);
%   sigornoise specifies which channel ('signal' or 'noise') should be
%   adjusted.

if nargin < 5
    error('not enough inputs!');
elseif nargin > 6
    error('too many inputs!');
end

if ~isvector(signal) || ~isvector(noise)
    error('Signal and noise must both be vectors!')
end

if length(noise) < length(signal)
    error('Noise must be longer or equal to the signal')
elseif length(noise) > length(signal)
    if isempty(varargin)
        error('Noise and signal are not the same length, must input an offset');
    elseif ~isposintscalar(varargin{1})
        error('Offset must be a positive integer')
    elseif length(signal)+varargin{1} > length(noise)
        error(['Offset makes signal end after noise, decrease offset to at most ' num2str(length(noise)-length(signal))])
    end
end

rmsNse = rms(noise);

noise = (desRMS/rmsNse).*noise;

if length(varargin) == 1
    offset = varargin{1};
else
    offset = 0;
end
Ps = sum(abs(signal).^2)/length(signal);
Pn = sum(abs(noise(1+offset:length(signal)+offset)).^2)/length(signal);

if strcmp(sigornoise,'noise')
    Pm = Ps/(10^(snr/10));
    adjnoise = sqrt(Pm/Pn).*noise;
    adjsignal = signal;
elseif strcmp(sigornoise,'signal')
    Pm = Pn*(10^(snr/10));
    adjnoise = noise;
    adjsignal = sqrt(Pm/Ps).*signal;
else
    error('sigornoise must be either ''signal'' or ''noise''')
end

zerofront = zeros(offset,1);

zeroback = zeros(length(noise)-(offset+length(signal)),1);

mixedsig = adjnoise + [zerofront;adjsignal;zeroback];
end

