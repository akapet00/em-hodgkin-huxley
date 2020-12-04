function iinj = Iinj_periodic(noise_var, A_hf, A_lf, w_hf, w_lf, t, t_stop)
%% Applied current
% The model of the current source in Hodgkin-Huxley model which represents
% the influence of ion pumps -- the movement of ions across a membrane
% against their concentration gradient through active transport.
%
% Arguments
%   A_n : scalar [1x1], noisey amplitude [uA/cm^2]
%   A_hf : scalar [1x1], high-frequency amplitude [uA/cm^2]
%   A_lf : scalar [1x1], low-frequency amplitude [uA/cm^2]
%   w_hf : scalar [1x1], high angular frequncy [Hz]
%   w_lf : scalar [1x1], low angular frequncy [Hz]
%   t : scalar [1x1], discrete simulation time [ms]
%   t_stop : scalar [1x1], discrete time point [ms] in which action ends
% 
% Returns
%   iinj : vector [1, length(t)], consntant current of `A` [uA/cm^2] over
%   discrete time up to `t_stop` moment
    noise = sqrt(noise_var)*randn(size(t));
    amp = A_hf*cos(w_hf*t) + A_lf*cos(w_lf*t); 
    iinj = amp.*(t>0) - amp.*(t>t_stop) + noise;
end