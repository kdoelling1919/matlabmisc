function kd_brainview( time,data,layout,chan,win,step,movie )
% kd_brainview creates movie and gui for topographical viewing
%   data = channel x time series data (2-d matrix)
%   time = time axis (vector)
%   layout = the layout of channels as implemented by fieldtrip
%   chan = the channels to pick, (vector or scalar);
%   win = how larger a window to average over (scalar)
%   step = stepsize to move in through movie (scalar)
%   movie = logical determining whether you want move to play automatically

begseg = time(1):step:time(end);
endseg = time(1)+win:step:time(end);
if isempty(chan);
    chan = 1:157;
end
fh=figure;
if movie
    finish = length(endseg);
else
    finish = 1;
end
clim = max(abs(data(:)));
mult = .5;
for t = 1:finish;
    timerange = time >= begseg(t) & time <=endseg(t);
    clf(fh,'reset');
    topo = squeeze(mean(data(:,timerange),2));
    ax(1) = subplot(2,1,1);
    ft_plot_topo(layout.pos(1:length(topo),1),layout.pos(1:length(topo),2),topo,...
        'interpmethod','v4','style','isofill','clim',[-mult mult].*clim,...
        'mask',layout.mask,'outline',layout.outline,'gridscale',67,'isolines',10,...
        'shading','flat','interplim','mask');
    colorbar
    hold on;
    if isscalar(chan)
        [~,best] = sort(abs(topo),'descend');
        best = best(1:chan);
    else
        best = chan;
    end
    
    templay = layout;
    templay.pos = layout.pos(best,:);
    templay.width = templay.width(best);
    templay.height = layout.height(best);
    templay.label = layout.label(best);
    ft_plot_lay(templay,'pointsymbol','.','pointcolor','w','pointsize',10,'box','no','label','no');
    title([num2str(begseg(t)) ' seconds']);
    ax(2) = subplot(2,1,2);
    if isscalar(chan)
        plot(time,data(:,:));
    else
        plot(time,data(best,:));
    end
    ylim = get(gca,'ylim');
    hold on;
    tindx=plot((begseg(t)+endseg(t))/2.*[1 1],ylim,'--k');
    drawnow
%         pause(.2);

end

while ishandle(fh)
    axes(ax(2));
    [x,~]=ginput(1);
    delete(tindx);
    tindx = plot(x.*[1 1],ylim,'--k');
    cla(ax(1),'reset');
    timerange = time >= x-win/2& time <= x+win/2;
    topo = squeeze(mean(data(:,timerange),2));
    axes(ax(1));
    ft_plot_topo(layout.pos(1:length(topo),1),layout.pos(1:length(topo),2),topo,...
        'interpmethod','v4','style','isofill','clim',[-mult mult].*clim,...
        'mask',layout.mask,'outline',layout.outline,'gridscale',67,'isolines',10,...
        'shading','flat','interplim','mask');
    colorbar
    hold on;
    hold on;
    if isscalar(chan)
        [~,best] = sort(abs(topo),'descend');
        best = best(1:chan);
    else
        best = chan;
    end
    
    templay = layout;
    templay.pos = layout.pos(best,:);
    templay.width = templay.width(best);
    templay.height = layout.height(best);
    templay.label = layout.label(best);
    ft_plot_lay(templay,'pointsymbol','.','pointcolor','w','pointsize',10,'box','no','label','no');
    title([num2str(x) ' seconds']);
end


