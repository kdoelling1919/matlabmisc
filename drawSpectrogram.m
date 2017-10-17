%last updated 09/22/2010
%draw log added on 09/10/2011 
%Yue Zhang
function drawSpectrogram(x,fs,frange,islog)

n=length(x);

rds=1;
if n>10000
    rds = floor(n/10000);
end

% [TFR,T,F]=TFRSP(X,T,N,H,TRACE) computes the Spectrogram 
%  	distribution of a discrete-time signal X. 
%   
%  	X     : signal.
%  	T     : time instant(s)          (default : 1:length(X)).
%  	N     : number of frequency bins (default : length(X)).
%  	H     : analysis window, H being normalized so as to
%  	        be  of unit energy.      (default : Hamming(N/4)). 
%  	TRACE : if nonzero, the progression of the algorithm is shown
%  	                                 (default : 0).
%  	TFR   : time-frequency representation. When called without 
%  	        output arguments, TFRSP runs TFRQVIEW.
%  	F     : vector of normalized frequencies.
    

N=4096;
if N>length(x)
    N = length(x);
    if rem(N,2)~=0, N = N+1; end
end
    
T = [1:rds:n];

% H=hamming(4096/16+1);
% [TFR,T,F]=tfrsp(x,T,N,H);

[TFR,T,F]=tfrsp(x,T,N);


if nargin==1
    fs=1;
end

F = F*fs;

if nargin<3
    frange(1)=F(1);
    frange(2)=F(N/2);
end

Fshowinx = find(F>=frange(1)&F<=frange(2));
    
% figure
    
    rms = mean(mean(TFR(Fshowinx,:).^2));
    rms = sqrt(rms);
    
    maxv = max(max(TFR(Fshowinx,:)));
    %imagesc(T/fs,log(F(Fshowinx)),flipud(TFR(Fshowinx,:)),[0 0.8*maxv]);
    TFRori = TFR(Fshowinx,:);
    if isequal(islog,'log')
        TFRlog = 20*log10(TFRori);
        imagesc(T/fs,F(Fshowinx),TFRlog);
    else
        imagesc(T/fs,F(Fshowinx),TFRori);
    end
    axis xy;
    
%     f1=F(Fshowinx(1));
%     lf1=log(f1);
%     nshow=length(Fshowinx);
%     f2=F(Fshowinx(nshow));
%     lf2=log(f2);
%     set(gca,'YTick',[f1 f2])
%     set(gca,'YTickLabel',{num2str(f2),num2str(f1)})
    xlabel('time(s)')
    ylabel('frequency(Hz)')
