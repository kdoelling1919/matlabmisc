function [ rows,cols ] = numSubPlot( numPlots )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if numPlots > 3 && isprime(numPlots)
    facSub = factor2(numPlots + 1);
else
    facSub = factor2(numPlots);
end

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

end

