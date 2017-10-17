function [ varargout ] = ca_coherence( cerebro, acoustic, time, freqoi, timeoi, ingred )
%ca_coherence Coherence calculation from brain signal to stimulus
%   Detailed explanation goes here
    % error checking
    if size(cerebro, 2) ~= size(acoustic, 2) || size(acoustic, 2) ~= length(time)
        error('Must have same number of time points on both sides');
    end
    if ~isvector(acoustic)
        error('Acoustic must be a single row vector');
    end
    if isempty(timeoi)
        timeoi = time;
    end
    % number of channels
    numChan = size(cerebro, 1);
    % put neural and stim together so that wavelet is done on both at the
    % same time
    CA = [cerebro; acoustic];
    % run wavelet analysis
    [spec, freqoi, timeoi] = ft_specest_wavelet(CA, time, 'width', 7,...
        'freqoi', freqoi, 'timeoi', timeoi);
    % split the spectra back up
    spec_c = spec(1:numChan,:,:);
    spec_a = repmat(spec(end,:,:),numChan,1);
    % extract power
    pow_c = abs(spec_c).^2;
    pow_a = abs(spec_a).^2;
    % calculate phase difference using csd
    csd_ca = spec_c.*conj(spec_a);
    phasediff = angle(csd_ca);
    
    if ~ingred || isempty(ingred)
        % calculate cacoh
        cacoh = abs(nansum(exp(1i.*phasediff).*sqrt(pow_c.*pow_a),3))./sqrt(nansum(pow_c,2).*nansum(pow_a,3));
        varargout = {cacoh, freqoi, timeoi};
    else
        varargout = {pow_c, pow_a, phasediff, freqoi, timeoi};
    end
end

