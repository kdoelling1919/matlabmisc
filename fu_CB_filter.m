function xout=fu_CB_filter(isin,len,wnl,wnh,m)

nb=512;

  wn(1)=wnl(m); wn(2)=wnh(m);
  bn=fir1(nb,wn);
  
  s0=zeros(1,len+nb/2);
   s0(1:len)=isin(1:len);
  s1=filter(bn,1,s0);
  s2(1:len)=s1(nb/2+1:nb/2+len);
  clear s0 s1 bn nb;
  xout=s2; clear s2;