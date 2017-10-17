function re_rlp=fu_mod_filter(re_r,len,nb0,bb0,reFs,Fs)
 
  nb=nb0; bn=bb0;
  s0=zeros(1,len+nb/2);
  s0(1:len)=re_r(1:len);
  s1=filter(bn,1,s0);
  s2(1:len)=s1(nb/2+1:nb/2+len); %fprintf(' ratio = %5.3f \t', min(s2)/max(s2))
  clear s0; s0=s2; clear s2
%% Upsampling
  
  re_rlp=resample(s0,Fs,reFs);
  if any(re_rlp<0)
    re_rlp=re_rlp+abs(min(re_rlp));
  end