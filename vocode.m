function [ noisespeech ] = vocode( audio, Fs, freq_range, bandnum,noiseorsin )
% noisevocode takes an auditory input and replaces it with a noise-voded
% version of the original signal.
% audio = the signal to be vocoded
% Fs = sampling frequency
% freq_range = the frequency range over which to be vocoded
% bandnum = the number of bands to vocode over
% noiseorsin = whether you want the carrier to be narrowband noise or a
%              sinusoid at center frequency of each band
% 
% Created by Keith Doelling, 6/26/15
bw = Fs/2;
nbx = 512;
vn = 10./bw;
bn = fir1(nbx,vn);

fq = logspace(log10(freq_range(1)),log10(freq_range(2)),bandnum+1);
wnl = fq(1:end-1);
wnh = fq(2:end);

wnl=wnl/bw;
wnh=wnh/bw;

Len=round(length(audio)/1);
cbEnv = zeros(Len,length(wnl));

        carrier = zeros(length(audio),length(wnl));
        for m=1:length(wnl)
            len=Len;
            %% Critical Band filtering
            xout=fu_CB_filter(audio,len,wnl,wnh,m);
            pow(m) = sqrt(mean(xout.^2));
            %% Hilbert
            [r]=fu_Hilbert(xout,len);

            cbEnv(:,m) = IIRfilt(r,10*2/Fs,15*2/Fs,'cheby1',5,25);
            carrier(:,m) = fu_carrier(len,wnl,wnh,m,bw);
        end
switch noiseorsin
    case 'noise'
        buffer = carrier.*cbEnv;
    case 'sine'
        avgF = mean([wnl; wnh]);
        t = (1:Len)./Fs;
        sins = sin(pi*Fs*avgF'*t);
        buffer = sins'.*cbEnv;
end

normalizer = repmat(pow./sqrt(mean(buffer.^2)),size(buffer,1),1);
buffer = buffer.*normalizer;

% noisespeech = sum(buffer,2)./max(abs(sum(buffer,2)));
noisespeech = sum(buffer,2);
end

