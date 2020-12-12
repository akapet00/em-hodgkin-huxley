function iinj = Iinj(A, t, t_start, t_stop)
%% Applied current
% The model of the current source in Hodgkin-Huxley model which represents
% the influence of ion pumps -- the movement of ions across a membrane
% against their concentration gradient through active transport.
%
% Arguments
%   A : scalar [1x1], amplitude [uA/cm^2]
%   t : scalar [1x1], discrete simulation time [ms]
%   t_start : scalar [1x1], discrete time point [ms] in which action starts
%   t_stop : scalar [1x1], discrete time point [ms] in which action ends
% 
% Returns
%   iinj : vector [1, length(t)], consntant current of `A` [uA/cm^2] over
%   discrete time up to `t_stop` moment
     
    iinj = A*(t>t_start) - A*(t>t_stop);
end