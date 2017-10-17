function [ L ] = setLims( varargin )
%setLims sets the Limits of multiple axes subplotted in a figure to be
%the same
%   setLims(H, axis)
%   H: is the handle of the figure or of the axes you want to set straight
%   axis: is either 'xlim', 'ylim' or 'clim' and denotes the axis to adjust
%
%   this use will set the specified axis to the minimum and maximum of all
%   the color limits in the figure
%
%   setlims(H, axis, lims)
%   lims: [a b] where a and b are the min and max of the limits to set all axes to.
%
%   this use will set all of the axes to the limit specified by you rather than
%   automatically selected in the previous use case

if length(varargin) == 1;
    error('Not enough inputs. You must specify which axis you would like to be altered');
elseif length(varargin) > 3
    error('Too many inputs');
end

if isscalar(varargin{1})
    H = get(varargin{1},'Children');
else
    H = varargin{1};
end

% make sure H is only the axes
ax = get(H,'Type');
H = H(strcmp(ax,'axes'));

limTyp = varargin{2};
if nargin == 2
    
    lims = get(H,limTyp);
    if iscell(lims)
        lims = cell2mat(get(H,limTyp));
    end
    Lim = [min(lims(:,1)) max(lims(:,2))];

    set(H,limTyp,Lim);
    if nargout == 1
     L = Lim;
    end
elseif nargin == 3
    set(H,limTyp,varargin{3})
end

end
