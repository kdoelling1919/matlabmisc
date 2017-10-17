function [ varargout ] = bar2( varargin )
%bar2 adds further functionality to the matlab bar function
%   bar2(Y) functions exactly the same as bar(Y)
%   bar2(X,Y) is basically the same with the added feature that X can also
%   be a cell array of labels
%       
%       For Example:
%       bar2({'cats','dogs'},[5 3]) will create a figure with two bars one with
%       the label 'cats' and the other with 'dogs' along the x-axis
%   
%   bar2(X,Y,E) allows you to add errorbars. This is done by plotting a
%   line on top of bar graph using errorbar(X,Y,E) and then setting it's
%   linestyle to 'none' so that only the errorbars remain.
%   bar2 returns two handles one for the bar graph and one for the error
%   bars.
%   [bar_handle, errorbar_handle] = bar2({'cats','dogs'},[5 3],[.4 .2])

% error checking
if length(varargin)>3
    error('Too many input arguments')
else
    %check to make sure all inputs to var
    plotLngth = cellfun(@length,varargin);
    check = plotLngth == plotLngth(1);
    if ~all(check)
%         error('Values must all be of the same length!')
    end
    if nargout>1&& length(varargin)<3
        error('Only one output variable allowed with this number of inputs')
    end
end

if length(varargin) == 1
    bar_handle = bar(varargin{1});
else
    X=varargin{1};
    Y=varargin{2};
    if iscell(X)
        bar_handle = bar(Y);
        set(gca,'XTick',1:length(X));
        set(gca,'XTickLabel',X);
        if length(varargin) == 3
            hold on;
            E=varargin{3};
            if size(E,1) ~=1
                set(bar_handle,'BarWidth',.9);
                numgroups = size(Y, 1); 
                numbars = size(Y, 2); 

                groupwidth = min(0.8, numbars/(numbars+1.5));

                for i = 1:numbars
                    % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
                    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars); % Aligning error bar with individual bar
                    errorbar_handle(i) = errorbar(x, Y(:,i), E(:,i), 'k', 'linestyle', 'none');
                end
            else
                errorbar_handle=errorbar(1:length(X),Y,E, 'k', 'linestyle', 'none');
            end
        end
    else
        bar_handle = bar(X,Y);
        if length(varargin) == 3
            hold on;
            E=varargin{3};
            set(bar_handle,'BarWidth',.9);
            numgroups = size(Y, 1); 
            numbars = size(Y, 2); 

            groupwidth = min(0.8, numbars/(numbars+1.5));

            for i = 1:numbars
                % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
                x = X - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars); % Aligning error bar with individual bar
                errorbar_handle(i) = errorbar(x, Y(:,i), E(:,i), 'k', 'linestyle', 'none');
            end
        end
    end
    
    if nargout > 0
        varargout{1}=bar_handle;
        if nargout >1 && length(varargin) == 3
            varargout{2}=errorbar_handle;
        end
    end
    hold off
end

