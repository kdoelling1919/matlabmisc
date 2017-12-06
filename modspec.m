function [ spec, f ] = modspec( rawsig, fs, fqbnds, bandno )
%MODSPEC Takes sound as input and outputs its modulation spectrum
%   input variables
%   rawsig = the audio sound
%   fs = the sampling rate of the signal
%   fqbnds = [minfreq maxfreq] where minfreq is the lowest frequency you
%       want to include and maxfreq the highest (default [100 5000];
%   bandno = number of bands to filter for envelope analysis (default is
%   16)
%   default parameters are good for typical speech usually.
%   
%   output variables
%   spec = modulation spectrum output
%   f = frequency axis for spec
%   
%   example:
%   % create a 1 kHz tone modulated at 4 Hz;
%   fs = 44100
%   t = 0:1./fs:12;
%   tone = sin(2.*pi.*1000.*t);
%   modulate = (sin(2.*pi.*4.*t)+1)./2;
%   modtone = tone.*modulate;
%   
%   % get mod spec and plot it
%   [spec, f] = modspec(modtone, fs, [900 1100], 1);
%   figure; plot(f, spec); set(gca, 'xlim', [0 10]);

    % set defaults
    if isempty(fqbnds)
        fqbnds = [100 5000];
    end
    if isempty(bandno)
        bandno = 15;
    end
    % get critical band envelopes using Oded's method
    env = OG_envelope(rawsig, fs, fqbnds, bandno);
    % sum over critical bands
    env = sum(env,2);
    % get modulation spectrum using fft
%     spec = abs(fft(env)).^2;
    [spec,f] = pwelch(env,[],[],[],fs);
    % get frequency axis.
%     f = (0:length(spec)-1)'.*fs./length(spec);

end

