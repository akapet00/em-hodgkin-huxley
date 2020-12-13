set_input;

%% Interspike Interval (ISI) for a fixed induction coef and a fixed temp
data = readmatrix(fullfile('output', 'deterministic_model', 'data', ...
    'tVmhnPhi_tsim-300_tIinj-0-300_A-10_noise-0_T-6_k-0.27.csv'));
t = data(:, 1);
V = data(:, 2);

% find local maxima
[V_spike, t_spike] = findpeaks(V, t);

% derive ISI, its probability mass function and associated entropy
isi = diff(t_spike);

fig1 = figure('renderer', 'painters', 'position', [100, 200, 800, 800]);
subplot(2, 2, [1, 2])
plot(t, V, 'b-', t_spike, V_spike, 'rx');
xlabel('t [ms]'), ylabel('V [mV]');
ylim([min(V) - 0.1*max(V), 1.1*max(V)]);
title('action potential dynamics, V(t)');
legend('V(t)', 'local maxima');
grid on;

subplot(2, 2, 3)
h = histogram(isi, 'binmethod', 'sqrt', ...
    'edgecolor', 'k', 'facecolor', 'r');
xlabel('ISI [ms]'), ylabel('N');
title('inter-spike interval (ISI) histogram');

subplot(2, 2, 4)
p = histogram(isi, 'binmethod', 'sqrt', 'normalization', 'probability', ...
    'edgecolor', 'k', 'facecolor', 'r');
pmf = p.Values(p.Values>0);
entropy = -sum(pmf .* log2(pmf));
xcor = 0.9 * max(get(gca, 'xlim'));
ycor = 0.9 * max(get(gca, 'ylim'));
text(xcor, ycor, {'entropy', ['Hp = ', num2str(entropy)]});
xlabel('ISI [ms]'), ylabel('p');
title('ISI probability mass function');

if save_figures
    figname = fullfile(figdir, ['ISI', ...
        '_tsim-300_tIinj-0-300_A-10_noise-0', ...
        '_T-', num2str(T), ...
        '_k-', num2str(k)]);
    savefig(fig1, [figname, '.fig']);
    saveas(fig1, [figname, '.eps']);
end

%% ISI, multiple temps and several induction coefs
colors = ['b', 'k', 'r', 'g'];
markers = ['o', 's', 'x', '^'];
ks = [0.03, 0.09, 0.27, 0.81];
Ts = linspace(1.0, 30.0, 30);
mean_isis = zeros(length(ks)*length(Ts), 1);
isi_idx = 1;
plot_idx = 1;
fig2 = figure('renderer', 'painters', 'position', [100, 200, 900, 500]);
hold on;
for i = 1:length(ks)
    k = ks(i);
    for j = 1:length(Ts)
        T = Ts(j);
        filename = ['tVmhnPhi_tsim-300_tIinj-0-300_A-10_noise-0', ...
            '_T-', num2str(T), ...
            '_k-', num2str(k), '.csv'];
        filepath = fullfile('output', 'deterministic_model', 'data', ...
            filename);
        data = readmatrix(filepath);
        t = data(:, 1);
        V = data(:, 2);
        [V_spike, t_spike] = findpeaks(V, t);
        isi = diff(t_spike);
        mean_isis(isi_idx) = mean(isi);
        isi_idx = isi_idx+1;
    end
    plot(Ts, mean_isis(plot_idx:length(Ts)*i), ...
        [colors(i), markers(i), '-'], 'displayname', ...
        ['k = ', num2str(k)]);
    xlabel('T [°C]'), ylabel('<ISI> [ms]');
    title('<ISI>(T)');
    plot_idx = plot_idx + length(Ts);
end
legend;
grid on;
hold off;

if save_figures
    figname = fullfile(figdir, ['mean_ISI', ...
        '_tsim-300_tIinj-0-300_A-10_noise-0', ...
        '_T-multiple_values', ...
        '_k-', sprintf('%.2f-', ks)]);
    savefig(fig2, [figname, '.fig']);
    saveas(fig2, [figname, '.eps']);
end

%% ISI, multiple induction coefs and several temps
colors = ['b', 'k', 'r', 'g'];
markers = ['o', 's', 'x', '^'];
ks = linspace(0.0, 5.0, 100);
Ts = [5.0, 10.0, 15.0, 20.0];
mean_isis = zeros(length(ks)*length(Ts), 1);
isi_idx = 1;
plot_idx = 1;
fig3 = figure('renderer', 'painters', 'position', [100, 200, 900, 500]);
hold on;
for i = 1:length(Ts)
    T = Ts(i);
    for j = 1:length(ks)
        k = ks(j);
        filename = ['tVmhnPhi_tsim-300_tIinj-0-300_A-10_noise-0', ...
            '_T-', num2str(T), ...
            '_k-', num2str(k), '.csv'];
        filepath = fullfile('output', 'deterministic_model', 'data', ...
            filename);
        data = readmatrix(filepath);
        t = data(:, 1);
        V = data(:, 2);
        [V_spike, t_spike] = findpeaks(V, t);
        isi = diff(t_spike);
        mean_isis(isi_idx) = mean(isi);
        isi_idx = isi_idx+1;
    end
    plot(ks, mean_isis(plot_idx:length(ks)*i), ...
        [colors(i), markers(i), '-'], ...
        'displayname', ['T = ', num2str(T), '°C']);
    xlabel('k'), ylabel('<ISI> [ms]');
    title('<ISI>(k)');
    plot_idx = plot_idx + length(ks);
end
legend;
grid on;
hold off;

if save_figures
    figname = fullfile(figdir, ['mean_ISI', ...
        '_tsim-300_tIinj-0-300_A-10_noise-0', ...
        '_T-', sprintf('%d-', Ts), ...
        '_k-multiple_values']);
    savefig(fig3, [figname, '.fig']);
    saveas(fig3, [figname, '.eps']);
end