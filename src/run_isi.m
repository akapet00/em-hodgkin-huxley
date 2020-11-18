set_input;

%% read simulated data
data = readmatrix(fullfile('output', 'data', ...
    'tVmhnPhi_t-300_Itstop-300_T-5_k-0.9.csv'));
t = data(:, 1);
V = data(:, 2);

%% find spikes and associated spike times
[V_spike, t_spike] = findpeaks(V, t);

fig1 = figure('renderer', 'painters', 'position', [100, 200, 800, 800]);
plot(t, V, 'b-', t_spike, V_spike, 'rx');
xlabel('t [ms]'), ylabel('V [mV]');
ylim([min(V) - 0.1*max(V), 1.1*max(V)]);
title('action potential in time, V(t)');
legend('V(t)', 'local maxima');
grid on;

%% calculate inter-spike interval
isi = diff(t_spike);

fig2 = figure('renderer', 'painters', 'position', [100, 200, 900, 500]);
subplot(1, 2, 1)
h = histogram(isi, 'binmethod', 'fd', ...
    'edgecolor', 'k', 'facecolor', 'r');
xlabel('inter-spike interval [ms]'), ylabel('N');
title('ISI histogram');

subplot(1, 2, 2)
p = histogram(isi, 'binmethod', 'fd', 'normalization', 'probability', ...
    'edgecolor', 'k', 'facecolor', 'r');
pmf = p.Values(p.Values>0);
entropy = -sum(pmf .* log2(pmf));
xlabel('inter-spike interval [ms]'), ylabel('p');
title(['ISI PMF, entropy=', num2str(entropy)]);

if save_figures
    savefig(fig2, fullfile(figdir, ['isi_hist', '_t-', num2str(t_span(2)), ...
        '_Itstop-', num2str(t_stop), '_T-', num2str(T), ...
        '_k-', num2str(k), '.fig']));
end

%% calculate mean ISI vs. T
colors = ['r', 'g', 'b', 'k'];
markers = ['o', 's', 'x', '^'];
ks = [0.001, 0.1, 0.3, 0.9];
Ts = linspace(1, 30, 30);
mean_isis = zeros(length(ks)*length(Ts), 1);
isi_idx = 1;
plot_idx = 1;
fig3 = figure('renderer', 'painters', 'position', [100, 200, 900, 500]);
hold on;
for i = 1:length(ks)
    k = ks(i);
    for j = 1:length(Ts)
        T = Ts(j);
        filename = ['tVmhnPhi_t-300_Itstop-300_T-', num2str(T), '_k-', num2str(k), '.csv'];
        filepath = fullfile('output', 'data', filename);
        data = readmatrix(filepath);
        t = data(:, 1);
        V = data(:, 2);
        [V_spike, t_spike] = findpeaks(V, t);
        isi = diff(t_spike);
        mean_isis(isi_idx) = mean(isi);
        isi_idx = isi_idx+1;
    end
    plot(Ts, mean_isis(plot_idx:length(Ts)*i), ...
        [colors(i), markers(i), '-'], 'displayname', ['k=', num2str(k)]);
    xlabel('T [°C]'), ylabel('<ISI> [ms]');
    title('<ISI>(t)');
    plot_idx = plot_idx + length(Ts);
end
legend;
grid on;
hold off;

if save_figures
    savefig(fig3, fullfile(figdir, 'isi_vs_T_k-multiple.fig'));
    save
end