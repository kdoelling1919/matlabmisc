function [r theta]=fu_Hilbert(xout,len)

%% Hilbert
  z=hilbert(xout);
%   shouldn't be called 'hilbert' -- zout = analytic signal
%   z=x+i*h{x}
%   r=abs(z)
%   theta=angle(z)
%   => z=r*exp(i*theta)
%      z=[x*cos(theta)]-i*[h{x}*sin(theta)]

  f=real(z);
  h=imag(z);
  r=abs(z);
  theta=angle(z);
% xsyn=r*cos(theta);
