function iinj = Iinj(A, t, t_stop)
%% Applied current
% The model of the current source in Hodgkin-Huxley model which represents
% the influence of ion pumps -- the movement of ions across a membrane
% against their concentration gradient through active transport.
%
% Arguments
%   A : scalar [1xN], amplitude [uA/cm^2]
%   t : scalar [1xN], discrete simulation time [ms]
%   t_stop : scaler [1xN], discrete time point [ms] in which action ends
% 
% Returns
%   iinj : vector [1, length(t)], consntant current of `A` [uA/cm^2] over
%   discrete time up to `t_stop` moment
    
    iinj = A*(t>0) - A*(t>t_stop);
end