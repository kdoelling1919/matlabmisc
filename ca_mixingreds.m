function [ cacoh ] = ca_mixingreds( pow_c, pow_a, phasediff, dim )
%ca_mixingreds Take output of ca_coherence when output is ingredients and
%finish the job
%   Detailed explanation goes here

        cacoh = abs(nansum(exp(1i.*phasediff).*sqrt(pow_c.*pow_a),dim))./sqrt(nansum(pow_c,dim).*nansum(pow_a,dim));

end

