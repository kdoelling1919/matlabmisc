function [ brainOut, E, I ] = simosc( soundIn, SR, coupling, tau )
%simosc simulates an dynamical oscillatory system in response to envelope
%driving force
%   soundIn: should be an amplitude envelope from extracted from sound
%   likely using hilbert transformation
%
%   SR: should be sampling rate of the sound and expected sampling rate of
%   the brain. soundIn should be downsampled to preferred of sampling rate
%   before using this function
%
%   coupling: is a gain value to place on the auditory system
%
%   brainOut: will be the oscillatory dynamics output based on Wilson-Cowan
%   Model. the output will be a row vector.
%   E, I: are the excitatory and inhibitory populations
    
    % set parameters based on Flor's design
    Fs = 4410;
    if isempty(coupling)
        coupling = 1;
    end
    if isempty(tau)
        tau = 24;
    end
    delta_t = 1./SR;
    if ~isvector(soundIn)
        error('Sound amplitude envelope must be a single vector');
    end
    
    if size(soundIn,1) ~= 1
        soundIn = soundIn';
    end
    
    auditory=[zeros(1,50) soundIn zeros(1,50)];
    
    t_tot=length(auditory)*delta_t;
    sub_time = (1:length(auditory))*delta_t;
    
%     auditory=auditory+0.01;
    auditory = coupling*auditory;% + 0.1*randn(size(auditory));
    
    % Solve the phase_coupling set of equations.Options fixs the accepted value of error
    options = odeset('RelTol',1e-6,'AbsTol',[1e-6 1e-6 1e-6 1e-6 1e-6 1e-6]);
    Yant = [ 0 0];
    
    %%% Solve the diff equation in steps in order to not to get the cumulative
    %%% errors.
    
    % i'm fairly certain this should be the length of the auditory input
    steps = floor(t_tot/delta_t); 
    Y=[];
    T=[];
    
    for nStep=1:steps
        % use very small dt between steps to reduce error and approximate
        % continuous variable
        tspan = (nStep-1)*delta_t:1/Fs:nStep*delta_t;
        [Ttemp, Ytemp] = ode45(@wilsonCowan, tspan,...
            [Yant(1) Yant(2) auditory(nStep) 2.3 -3.2 tau], options); % Solve ODE (2.3 -3.2)
        Yant(1)=Ytemp(end,1);
        Yant(2)=Ytemp(end,2);
        Y = [Y; Ytemp];
        T = [T; Ttemp];
    end
    
    
    E = resample(Y(:,1), size(auditory,2), size(Y,1));
    I = resample(Y(:,2), size(auditory,2), size(Y,1));
    sg = E - I;
    brainOut = sg - mean(sg);
    brainOut = brainOut(51:end-50);
    E = E(51:end-50);
    I = I(51:end-50);
    
end

