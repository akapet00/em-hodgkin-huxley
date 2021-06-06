set_input;

%% experiment: temps and induction coef
fig1 = figure('renderer', 'painters', 'position', [100, 200, 1000, 1000]);
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
    savefig(fig1, [figname, '.fig']);
    saveas(fig1, [figname, '.eps']);
end

%% experiment: multiple k1s and k21 dependance
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-6);
f = waitbar(0, '1', 'Name', 'Simulating...', ...
    'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
k = 0.1;
A = 3;
k1s = linspace(0.0001, 0.01, 10);
k2s = linspace(0.001, 0.1, 10);
T = 6.3;
t_stop = 1000;
is_periodic = true;

nrows = numel(k1s);
ncols = numel(k2s);
steps = nrows * ncols;
step = 0;
mean_isis = zeros(nrows, ncols);
mean_sfs = zeros(nrows, ncols);
for i = 1:nrows
    k1 = k1s(i);
    for j = 1:ncols
        if getappdata(f, 'canceling')
            break
        end
        step = step + 1;
        prog_perc = step / steps;
        waitbar(prog_perc, f, [sprintf('%12.2f', prog_perc * 100), '%'])
        
        k2 = k2s(j);  
        basic_params = [A, t_start, t_stop, ...
            E_Na, E_K, E_L, gbar_Na, gbar_K, gbar_L, ... 
            C_m, T];
        induction_params = [k, a, b, k1, k2];
        y0 = [V0, m0, h0, n0, phi0];
        t_span = [0, t_stop];
        [t, y] = ode45(@(t, y) ... 
            HodgkinHuxley(t, y, basic_params, induction_params, ...
                is_periodic), ...
            t_span, y0, opts);
        t = t(:, 1);
        V = y(:, 1);
        [V_spike, t_spike] = findpeaks(V, t, 'MinPeakHeight', 0);
        isi = diff(t_spike(2:end));
        mean_isis(i, j) = mean(isi);
        mean_sfs(i, j) = numel(V_spike(2:end)) / (t_stop / 1000);
    end
end

close(f, 'force');

[K1_mesh, K2_mesh] = meshgrid(k1s, k2s);
fig2 = figure('renderer', 'painters', 'position', [100, 100, 600, 500]);
contourf(K1_mesh, K2_mesh, mean_isis);
c = colorbar;
c.Title.String = 'mISI [s]';
xlabel('k1'); ylabel('k2');

if save_data
    filename = ['k1k2_influence', ...
        '_tsim-', num2str(t_span(2)), ...
        '_tIinj-', num2str(t_start), '-', num2str(t_stop), ...
        '_isPeriodic-', num2str(is_periodic), ...
        '_T-', num2str(T), ...
        '_k-', num2str(k), '.mat'];
        filepath =  fullfile('output', 'deterministic_model', ...
            'data', filename);
        save(filepath, 'k1s', 'k2s', 'mean_isis', 'mean_sfs');
end

if save_figures
    figname = fullfile(figdir, ['k1k2_influence', ...
        '_tsim-', num2str(t_span(2)), ...
        '_tIinj-', num2str(t_start), '-', num2str(t_stop), ...
        '_noise-', num2str(is_periodic)]);
    savefig(fig2, [figname, '.fig']);
    saveas(fig2, [figname, '.eps']);
end