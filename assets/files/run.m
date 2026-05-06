% housekeeping
clc
clear

% eta values of interest
vector_eta = 0.01:0.01:0.05;
number_eta = length(vector_eta);

% welfare place holder
welfare_results = zeros(5,number_eta);

% indicator of adjusted a
ind_unadjusted_a = false;

for eta_i = 1:number_eta
    
    % specify particular value of eta
    eta = vector_eta(eta_i);
    welfare_results(1,eta_i) = eta;

    % run
    if ind_unadjusted_a == true
        dynare neoclassical_fixed_labor_unadjusted_a.mod noclearall nolog

        % shock index stored in Dynare results 
        a_index = strmatch('A',M_.endo_names,'exact');

        % retrieve mean of shock
        welfare_results(2,eta_i) = oo_.mean(a_index);
    else
        dynare neoclassical_fixed_labor.mod noclearall nolog

        % shock index stored in Dynare results 
        a_index = strmatch('a',M_.endo_names,'exact');

        % retrieve mean of shock
        welfare_results(2,eta_i) = oo_.mean(a_index);
    end

    % welfare index stored in Dynare results 
    welfare_index = strmatch('V',M_.endo_names,'exact');

    % non-stochastic welfare
    welfare_ss = oo_.dr.ys(welfare_index);
    welfare_results(3,eta_i) = welfare_ss;

    % unconditional welfare
    welfare_uncon = oo_.mean(welfare_index);
    welfare_results(4,eta_i) = welfare_uncon;

    % conditional welfare
    if options_.order == 1
        welfare_con = welfare_ss;
    else
        welfare_con = welfare_ss + 0.5*oo_.dr.ghs2(oo_.dr.inv_order_var(welfare_index));
    end
    welfare_results(5,eta_i) = welfare_con;
end

% show results
rowNames = {'eta','E(A)','V_ss','E(V)','E_ss(V)'};
colNames = {'1','2','3','4','5'};
welfare_table = array2table(welfare_results,'RowNames',rowNames,'VariableNames',colNames);
display(welfare_table);