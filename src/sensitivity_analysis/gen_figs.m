path = fullfile('sc_output', ...
    'sc_processed_tsim-300_tIinjstop-300_T-15_k-0-2');

ks = linspace(0.0, 2.0, 50);
sc_points = [3, 5, 7, 9];
var_percents = [5., 10., 20., 50.];
n_rows = numel(var_percents);
n_cols = numel(sc_points);

total_means = zeros(numel(ks), n_rows+n_cols);
total_vars = zeros(numel(ks), n_rows+n_cols);

% 4x4 plot, all combinations of CIs and SC points
figure('Renderer', 'painters', 'Position', [16 16 900 600])
plt_idx = 1;
for i = 1:n_rows
    ci = var_percents(i);
    for j = 1:n_cols
        sc = sc_points(j);
        mean_file = ['MEAN_CI', num2str(ci), '_SC_', num2str(sc), '.mat'];
        filepath = fullfile(path, mean_file);
        load(filepath);  % M variable with expected values
        total_means(:, plt_idx) = M;
        var_file = ['VAR_CI', num2str(ci), '_SC_', num2str(sc), '.mat'];
        filepath = fullfile(path, var_file);
        load(filepath);  % V variable with variances
        total_vars(:, plt_idx) = V;
        subplot(n_rows, n_cols, plt_idx);
        plot(ks, M, 'b.-');
        hold on
        plot(ks, M-sqrt(V), 'b-', ks, M+sqrt(V), 'b-');
        hold off
        xlabel('k');
        ylabel('E(<ISI>)(k)');
        title(['SC = ', num2str(sc), ', CI = ', num2str(ci), '%']);
        plt_idx = plt_idx + 1;
    end
end

% convergence of expected values and means of mean ISIs
figure('Renderer', 'painters', 'Position', [8 8 900 600])
start_plot_idx = 1;
end_plot_idx = start_plot_idx+3;
for i = 1:n_rows
    ci = var_percents(i);
    subplot(2, 2, i);
    plot(ks, total_means(:, start_plot_idx:end_plot_idx));
    xlabel('k');
    ylabel('E(<ISI>)(k)');
    title(['CI = ', num2str(ci), '%']);
    legend('3 SC points', '5 SC points', '7 SC points', '9 SC points');
    grid on;
    start_plot_idx = end_plot_idx+1;
    end_plot_idx = start_plot_idx+3;
end
figure('Renderer', 'painters', 'Position', [8 8 900 600])
start_plot_idx = 1;
end_plot_idx = start_plot_idx+3;
for i = 1:n_rows
    ci = var_percents(i);
    subplot(2, 2, i);
    plot(ks, total_vars(:, start_plot_idx:end_plot_idx));
    xlabel('k');
    ylabel('var(<ISI>)(k)');
    title(['CI = ', num2str(ci), '%']);
    legend('3 SC points', '5 SC points', '7 SC points', '9 SC points');
    grid on;
    start_plot_idx = end_plot_idx+1;
    end_plot_idx = start_plot_idx+3;
end

% sensitivity analysis for 5 sc points
figure('Renderer', 'painters', 'Position', [8 8 900 600])
for i = 1:n_rows
    ci = var_percents(i);
    anova_file = ['SA_ANOVA_indices_CI', num2str(ci), '_SC_5.mat'];
    filepath = fullfile(path, anova_file);
    load(filepath);
    subplot(2, 2, i);
    plot(ks, SS(:, 7:9));
    xlabel('k');
    ylabel('total effect sensitivity index');
    title(['CI = ', num2str(ci), '%']);
    legend('gNa sens. idx', 'gK sens. idx', 'gL sens. idx');
    grid on;
end