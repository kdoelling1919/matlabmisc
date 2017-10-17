function cosf0=fu_carrier(len,wnl,wnh,m,bw)
Fs=2*bw;
%%
      cf=((wnl(m)+wnh(m))/2)*bw;
      tmp=randn(1,len);  
      nb=512;
      vn=(0.5*cf)/bw;
      bn=fir1(nb,vn);
      s0=zeros(1,len+nb/2);
       s0(1:len)=tmp(1:len);
      s1=filter(bn,1,s0);
      s2(1:len)=s1(nb/2+1:nb/2+len);
      clear s0 s1 bn nb;
      s2=s2-mean(s2); s2=s2/(max(abs(s2))+1.e-2);
      fmin=exp(log(cf)-log(1.5));
      fmax=exp(log(cf)+log(1.5)); if fmax >= bw; fmax=bw; end
      cosf0=vco(s2,[fmin fmax],Fs);
     %fprintf('%5.0f %5.0f %5.0f \n', fmin, cf, fmax)