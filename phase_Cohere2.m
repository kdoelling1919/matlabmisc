function [ Coherence ] = phase_Cohere2( phaseNeural, dim )
%phase_Cohere2 Calculates intertrial coherence as implemented in Luo &
%Poeppel, 2007.
%   Trials must be last dimension.
%   Input must be at least three dimensons (e.g. freq x time x trials, or
%   time x freq x trials)
%   Can contain other dimensions (e.g. time x freq x channels x trials)

if length(size(phaseNeural)) <= 3 
    error('Input must have at least three dimension: e.g. time X frequency X trials')
end
if nargin < 2
    dim = ndims(phaseNeural);
end

cos_fq = cos(phaseNeural);
sin_fq = sin(phaseNeural);

cos_fq = nanmean(cos_fq,dim);
sin_fq = nanmean(sin_fq,dim);

Coherence = cos_fq.^2 + sin_fq.^2;
end


