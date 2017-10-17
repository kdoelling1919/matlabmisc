function [ delta_phi ] = phasedif_hilb( brain, auditory,  fq, fs, fw)
% phasedif_hilb uses hilbert to output different phases
%   Detailed explanation goes here
    % error checking
    if size(brain, 2) ~= size(auditory, 2) 
        error('Must have same number of time points on both sides');
    end
    if ~isvector(auditory)
        error('Acoustic must be a single row vector');
    end

    siz = size(brain);
    auditory = repmat(auditory, size(brain,1),1);
    delta_phi = zeros([siz(1) length(fq) siz(2)]); % put freq in 2nd place as ft_spec_wavelet would
    
    for f = 1:length(fq)
        
        brainfilt = freqfiltbp(brain, [fq(f) fq(f)], fs, fw, 2);
        audfilt = freqfiltbp(auditory, [fq(f) fq(f)], fs, fw, 2);
        
        phi_a = angle(hilbert2(audfilt'))';
        phi_b = angle(hilbert2(brainfilt'))';
        delta_phi(:,f,:) = exp((1i*phi_a))./exp((1i*phi_b));
    end
end

