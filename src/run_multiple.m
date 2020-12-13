set_input;

%% multiple experiments with different temps and induction coefs
fig3 = figure('renderer', 'painters', 'position', [100, 200, 1000, 1000]);
Ts = [0.3, 6.3, 22.3, 28.3];
ks = [0, 0.001, 0.01, 0.3,];
nrows = length(ks);
ncols = length(Ts);
nplot = 1;
for i = 1:nrows
    k = ks(i);
    for j = 1:ncols
        T = Ts(j);
        basic_params = [A, t_start, t_stop, ...
            E_Na, E_K, E_L, gbar_Na, gbar_K, gbar_L, ... 
            C_m, T];
        induction_params = [k, a, b, k1, k2];
        y0 = [V0, m0, h0, n0, phi0];
        t_span = [0, t_stop];
        [t, y] = ode45(@(t, y) ... 
            HodgkinHuxley(t, y, basic_params, induction_params, ...
                is_periodic), ...
            t_span, y0);
        subplot(nrows, ncols, nplot)
        plot(t, y(:, 1), 'b-');
        xlabel('t [ms]'), ylabel('V [mV]');
        title(['V(t), T=', num2str(T), '°C,  k=', num2str(k)]);
        nplot = nplot + 1;
    end
end

if save_figures
    figname = fullfile(figdir, ['MulAcPotDyn', ...
        '_tsim-', num2str(t_span(2)), ...
        '_tIinj-', num2str(t_start), '-', num2str(t_stop), ...
        '_noise-', num2str(is_periodic)]);
    savefig(fig3, [figname, '.fig']);
    saveas(fig3, [figname, '.eps']);
end