% part1_compare_irfs.m
% Hands-on driver for the first part: compare impulse responses across
% parameterizations of the running example (part1_model.mod).
%
% Robust workflow: Dynare preprocesses and solves the model ONCE; afterwards
% we change parameters with set_param_value and re-solve by calling
% stoch_simul directly, storing each run's IRFs before the next solve.
% This avoids the classic pitfall that a second "dynare" call clears the
% MATLAB workspace (unless the noclearall option is used) and overwrites
% previous results.
%
% Requirements: part1_model.mod in the current folder, Dynare on the path.

clear; close all; clc

export_figs = false;             % set true to write the slide figures to ../figures

% Plot style matching the lecture slides
accent  = [0.106 0.369 0.247];   % deep green
accent2 = [0.706 0.388 0.165];   % rust
muted   = [0.486 0.529 0.565];   % grey
palette = [accent; accent2; muted];
set(groot, 'defaultAxesFontName','Helvetica', 'defaultAxesFontSize',13, ...
           'defaultAxesXColor',[0.35 0.35 0.35], 'defaultAxesYColor',[0.35 0.35 0.35], ...
           'defaultAxesGridColor',[0.8 0.8 0.8], 'defaultAxesGridAlpha',0.6, ...
           'defaultAxesBox','off', 'defaultAxesTickDir','out', ...
           'defaultAxesColorOrder', palette, 'defaultLineLineWidth',2.5, ...
           'defaultFigureColor','w');

%% 1. Baseline run: preprocess, solve, and show Dynare's standard output
dynare part1_model nolog

options_.nograph = true;         % suppress Dynare's own IRF figures below
options_.noprint = true;         % ... and the console tables inside the loop

irf_horizon = options_.irf;      % 40 quarters, as set in the .mod file

%% 2. Experiment A: shock persistence (loop over rho)
rho_values = [0.95 0.50];        % baseline, then one alternative
irf_store  = cell(size(rho_values));

for j = 1:numel(rho_values)
    set_param_value('rho', rho_values(j));
    [info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);
    if info(1)
        error('stoch_simul failed for rho = %g (error code %d)', rho_values(j), info(1));
    end
    irf_store{j} = oo_.irfs;     % store this run's IRFs before the next solve
end

plot_vars  = {'c','i'};          % the split is the story; add 'y','k' to see more
plot_names = {'Consumption c','Investment i'};
linestyles = {'-','--'};

fig_a = figure('Name','Experiment A: persistence', ...
               'Units','inches', 'Position',[0 0 7.2 2.5]);
tl = tiledlayout(fig_a, 1, numel(plot_vars), 'TileSpacing','compact', 'Padding','compact');
for v = 1:numel(plot_vars)
    nexttile; hold on
    for j = 1:numel(rho_values)
        plot(0:irf_horizon-1, irf_store{j}.([plot_vars{v} '_e']), ...
             linestyles{j}, 'LineWidth', 2.5)
    end
    title(plot_names{v}, 'FontWeight','normal', 'Color', accent)
    grid on; axis tight
    xticks(0:20:irf_horizon)
    ax = gca; ax.YAxis.Exponent = 0;   % kill the stray x10^-3 label
    ytickformat('%.3f')                % plain decimals, few of them
    yticks(round(linspace(max(0,min(ylim)), max(ylim), 4), 3))
end
xlabel(tl, 'quarters after the shock', 'FontSize', 13, 'Color', [0.35 0.35 0.35])
lg = legend(arrayfun(@(r) sprintf('\\rho = %.2f', r), rho_values, ...
       'UniformOutput', false), 'Orientation','horizontal');
lg.Layout.Tile = 'south';
set(lg, 'Box','off')

%% 3. Experiment B: shock volatility (eta = 0.01 vs 0.02)
set_param_value('rho', 0.95);    % restore the baseline persistence

M_.Sigma_e(1,1) = 0.01^2;        % baseline volatility (eta = 0.01)
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);
irf_base = oo_.irfs;

M_.Sigma_e(1,1) = 0.02^2;        % double the volatility (eta = 0.02)
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);
irf_high = oo_.irfs;

fig_b = figure('Name','Experiment B: volatility', ...
               'Units','inches', 'Position',[0 0 9 4.5]);
plot(0:irf_horizon-1, irf_base.y_e, '-',  'LineWidth', 3); hold on
plot(0:irf_horizon-1, irf_high.y_e, '--', 'LineWidth', 3); grid on
title('Output response to a one-s.d. TFP shock', 'FontWeight','normal', 'Color', accent)
xlabel('quarters after the shock'); axis tight
lg = legend('\eta = 0.01', '\eta = 0.02 (same shape, twice the size)', ...
       'Location', 'northeast'); set(lg, 'Box','off')

M_.Sigma_e(1,1) = 0.01^2;        % restore the baseline before leaving

%% 4. Optional: export the figures used in the slides
if export_figs
    exportgraphics(fig_a, fullfile('..','figures','irf_persistence.pdf'), ...
                   'ContentType','vector');
    exportgraphics(fig_b, fullfile('..','figures','irf_volatility.pdf'), ...
                   'ContentType','vector');
end

% Notes:
% - Experiment A: rho controls how long a shock lasts, not how large it is on
%   impact. The half-life of the TFP process is ln(0.5)/ln(rho) quarters:
%   about 13.5 quarters at rho = 0.95, but only 1 quarter at rho = 0.50.
%   Add more values to rho_values to compare further parameterizations.
% - Experiment B: at first order the solution is linear in the shocks, so
%   doubling the shock s.d. exactly doubles the IRF to a one-s.d. shock
%   without changing its shape, and average behavior is unaffected
%   (certainty equivalence). This is exactly what breaks after the break:
%   welfare analysis requires going to second order.
