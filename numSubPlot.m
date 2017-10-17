function [ rows,cols ] = numSubPlot( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


numPlots = varargin{1};
if nargin > 1
    rows = varargin{2};
else
    rows = [];
end
if nargin>2
    cols = varargin{3};
else
    cols = [];
end


if numPlots > 3 && isprime(numPlots)
    facSub = factor2(numPlots + 1);
else
    facSub = factor2(numPlots);
end

if isempty(rows) && isempty(cols)
    numFac = length(facSub);
    if ~mod(numFac,2)
        low = numFac/2;
        high = low+1;
    else
        low = (numFac+1)/2;
        high = low;
    end
    rows = facSub(low);
    cols = facSub(high);
elseif isscalar(rows) && isempty(cols)
    cols = ceil(numPlots./rows);
elseif isscalar(cols) && isempty(rows)
    rows = ceil(numPlots./cols);
else
    error('Rows and Cols must be scalar or empty');
end
end

