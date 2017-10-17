function bn=fu_filer_dsgn_stop(nb,bw0)

    p_abv=1.25; p_blw=.75;
%%
    f=[0 2 9 30 bw0]/bw0;
    a=[1 0 1 0];
    up=[p_abv 0.005 p_abv .005];
    lo=[p_blw -0.005 p_blw -.005];
    bn=fircls(nb,f,a,up,lo);
    
% iflag_plot=1;
% if iflag_plot == 1
%     [h,w]=freqz(bn,1,nb);
%     w=(w/pi)*bw0;
%     mag=abs(h);
%     semilogy(w,mag,'r-','linewidth',2);
%     axis([0 11 5e-2 2]); grid on; hold on; drawnow
%     clear h w w mag
% end
end