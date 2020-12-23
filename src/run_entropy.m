set_input;
save_data = true;
t_stop = 2500;
k = 0.1;

%% low entropy regime -- tonic bursting achieved via noisy current stimulus
is_periodic = true;
basic_params = [A, t_start, t_stop, ...
    E_Na, E_K, E_L, gbar_Na, gbar_K, gbar_L, ... 
    C_m, T];
induction_params = [k, a, b, k1, k2];
y0 = [V0, m0, h0, n0, phi0];
t_span = [0, t_stop];
[t, y] = ode45(@(t, y) ... 
    HodgkinHuxley(t, y, basic_params, induction_params, is_periodic), ...
    t_span, y0);
I = Iinj_periodic(A/10, 0, A, 0, 100/t_stop, t, t_start, t_stop);
V = y(:, 1);
[V_spike, t_spike] = findpeaks(V, t, 'MinPeakHeight', -40);
isi = diff(t_spike);
fig1 = figure('renderer', 'painters', 'position', [50, 50, 1000, 700]);

subplot(2, 2, 1)
plot(t, V, 'b-', t_spike, V_spike, 'rx');
xlabel('t [ms]'), ylabel('V [mV]');
ylim([min(V) - 0.1*max(V), 1.1*max(V)]);
title('action potential dynamics, V(t)');
legend('V(t)', 'local maxima');
grid on;
 
subplot(2, 2, 2)
p = histogram(isi, 'binmethod', 'sqrt', 'normalization', 'probability', ...
    'edgecolor', 'k', 'facecolor', 'r');
pmf = p.Values(p.Values>0);
entropy = -sum(pmf .* log2(pmf));
xlabel('ISI [ms]'), ylabel('p');
title(['ISI probability mass function, entropy Hp = ', num2str(entropy)]);

if save_data
    filename = ['entropy', ...
        '_tsim-', num2str(t_span(2)), ...
        '_tIinj-', num2str(t_start), '-', num2str(t_stop), ...
        '_isPeriodic-', num2str(is_periodic), ...
        '_T-', num2str(T), ...
        '_k-', num2str(k), '.mat'];
        filepath =  fullfile('output', 'deterministic_model', ...
            'paper_figures', filename);
        save(filepath, 't', 'V', 'I', 't_spike', 'V_spike', 'isi');
end

%% high entropy regime -- tonic spiking, stimuls is dc current
is_periodic = false;
basic_params = [A, t_start, t_stop, ...
    E_Na, E_K, E_L, gbar_Na, gbar_K, gbar_L, ... 
    C_m, T];
induction_params = [k, a, b, k1, k2];
y0 = [V0, m0, h0, n0, phi0];
t_span = [0, t_stop];
[t, y] = ode45(@(t, y) ... 
    HodgkinHuxley(t, y, basic_params, induction_params, is_periodic), ...
    t_span, y0);
I = Iinj(A, t, t_start, t_stop);
V = y(:, 1);
[V_spike, t_spike] = findpeaks(V, t, 'MinPeakHeight', -35);
isi = diff(t_spike);

subplot(2, 2, 3)
plot(t, V, 'b-', t_spike, V_spike, 'rx');
xlabel('t [ms]'), ylabel('V [mV]');
ylim([min(V) - 0.1*max(V), 1.1*max(V)]);
title('action potential dynamics, V(t)');
legend('V(t)', 'local maxima');
grid on;
 
subplot(2, 2, 4)
p = histogram(isi, 'binmethod', 'sqrt', 'normalization', 'probability', ...
    'edgecolor', 'k', 'facecolor', 'r');
pmf = p.Values(p.Values>0);
entropy = -sum(pmf .* log2(pmf));
xlabel('ISI [ms]'), ylabel('p');
title(['ISI probability mass function, entropy Hp = ', num2str(entropy)]);

if save_data
    filename = ['entropy', ...
        '_tsim-', num2str(t_span(2)), ...
        '_tIinj-', num2str(t_start), '-', num2str(t_stop), ...
        '_isPeriodic-', num2str(is_periodic), ...
        '_T-', num2str(T), ...
        '_k-', num2str(k), '.mat'];
        filepath =  fullfile('output', 'deterministic_model', ...
            'paper_figures', filename);
        save(filepath, 't', 'V', 'I', 't_spike', 'V_spike', 'isi');
end

if save_figures
    figname = fullfile('output', 'deterministic_model', ...
        'paper_figures', ['entropy_dc_vs_noise', ...
        '_tsim-', num2str(t_span(2)), ...
        '_tIinj-', num2str(t_start), '-', num2str(t_stop), ...
        '_T-', num2str(T), ...
        '_k-', num2str(k)]);
    savefig(fig1, [figname, '.fig']);
    saveas(fig1, [figname, '.eps']);
end