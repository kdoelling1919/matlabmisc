function [ xsyn, Fs ] = OG_vocode( audio, Fs, freq_range, bandnum, condition, chan, nomod )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
LowCutoff=10;

%% Load input signal
if ischar(audio)
    [isin, Fs] = audioread(audio);
elseif isvector(audio) && isnumeric(audio)
    isin = audio;
end
Len=round(length(isin));
nbx=512;
bw=Fs/2;
bw0=100;
reFs=2*bw0; 

[wnl, wnh] = bandspacing(freq_range, bandnum);
wnl=wnl/bw;
wnh=wnh/bw;


%% Analysis
    %% Modulation filter design
    nb=nbx;
    if strcmp(condition, 'control') || isempty(condition)
        bn = fu_filer_dsgn(nb,bw0,LowCutoff);
    elseif strcmp(condition, 'stop')
        bn = fu_filer_dsgn_stop(nb,bw0);
    end
    nb0=nb; bb0=bn;

    xx=zeros(1,Len); xout=zeros(1,Len);
    for m=1:bandnum
        len=Len;
        %% Critical Band filtering
        xout=fu_CB_filter(isin,len,wnl,wnh,m);
        xx=xx+xout;
        %% Hilbert
        [r theta]=fu_Hilbert(xout,len);
        %% Downsampling -- Upsampling inside fu_mod_filter
        reLen=round(len/(Fs/reFs));
        re_r=resample(r,reFs,Fs);
        %% Modulation Spectrum
        rlp=fu_mod_filter(re_r,reLen,nb0,bb0,reFs,Fs);
        rlp_mem(m,:)=rlp;
    end
    xx=xx/(max(abs(xx)+1.e-2)); % sanity check

%% Synthesis    
    xsyn=zeros(1,Len);
    for m=1:bandnum
        clear rlp
        if ~nomod || isempty(nomod)
            if strcmp(chan, 'narrow') || isempty(chan)
                s0 = rlp_mem(m,:);
            elseif strcmp(chan, 'broad')
                s0 = mean(rlp_mem, 1).*mean(rlp_mem(m,:))./mean(mean(rlp_mem, 1));
            end
        else
            s0 = mean(rlp_mem(m,:)).*ones(size(rlp_mem(m,:)));
        end
        len=min(length(theta),length(s0));
        rlp(1:len)=s0(1:len); clear s0
        %% Carrier
        cosf0=fu_carrier(len,wnl,wnh,m,bw);
        %% Synthesis
        s0=rlp.*cosf0;
        xsyn(1:len)=xsyn(1:len)+s0(1:len);
        clear cosf0 s0
    end
    xsyn=xsyn/(max(abs(xsyn)+1.e-2));
%     audiowrite([filename(1:end-4) '_xsyn.wav'],xsyn,Fs);

end

