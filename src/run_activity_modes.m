set_input;
A = 0.1;
save_figures = true;

%% weak input stimulus for two cases: exposure vs non-exposure to H field
% basic parameters setup
basic_params = [A, t_start, t_stop, ...
    E_Na, E_K, E_L, gbar_Na, gbar_K, gbar_L, ... 
    C_m, T];

% induction parameters setup -- no exposure
k_noexposure = 0.0;
induction_params = [k_noexposure, a, b, k1, k2];
y0 = [V0, m0, h0, n0, phi0];
t_span = [0, t_stop];

[t_noexposure, y_noexposure] = ode45(@(t, y) ... 
    HodgkinHuxley(t, y, basic_params, induction_params, is_periodic), ...
    t_span, y0);

% induction parameters setup -- strong exposure
k_exposure = 1.0;
induction_params = [k_exposure, a, b, k1, k2];
y0 = [V0, m0, h0, n0, phi0];
t_span = [0, t_stop];

[t_exposure, y_exposure] = ode45(@(t, y) ... 
    HodgkinHuxley(t, y, basic_params, induction_params, is_periodic), ...
    t_span, y0);

t = t_exposure;
if is_periodic
    iinj = Iinj_periodic(A/10, 0, A, 0, 100/t_stop, t, t_start, t_stop);
else
    iinj = Iinj(A, t, t_start, t_stop);
end

fig1 = figure('renderer', 'painters', 'position', [100, 200, 800, 800]);
subplot(3,1,1)
plot(t, iinj, 'b-', 'linewidth', 2);
xlabel('t [ms]'), ylabel('I [nA]');
title('stimulus current, I(t)');
ylim([min(iinj) - 0.1*max(iinj), 1.1*max(iinj)]);
grid on;

subplot(3,1,2)
plot(t_noexposure, y_noexposure(:,1), 'b-');
xlabel('t [ms]'), ylabel('V [mV]');
title(['Exposure scenario 1: k = ', num2str(k_noexposure)]);
grid on;

subplot(3,1,3)
plot(t_exposure, y_exposure(:,1), 'b-');
xlabel('t [ms]'), ylabel('V [mV]');
title(['Exposure scenario 2: k = ', num2str(k_exposure)]);
grid on;

if save_figures
    figname = 'multiple_modes_activity';
    filepath =  fullfile('output', 'deterministic_model', ...
            'figures', figname);
    savefig(fig1, [filepath, '.fig']);
    saveas(fig1, [filepath, '.eps']);
end