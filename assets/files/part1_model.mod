/*
 * part1_model.mod --- the running example of the lecture (first part)
 *
 * Stochastic neoclassical growth model with fixed labor supply.
 *
 * This is EXACTLY the economy of example.mod, which is used after the break
 * for the welfare analysis. The only differences are cosmetic:
 *   - the welfare recursion V_t = u(C_t) + beta*E_t V_{t+1} is not here yet;
 *     adding that one line to this file gives example.mod;
 *   - output y and investment i are declared as definitions, so that Dynare
 *     reports impulse responses for them. They are accounting identities and
 *     do not change the equilibrium in any way.
 *
 *   max E_0 sum_t beta^t C_t^(1-gamma)/(1-gamma)
 *   s.t. C_t + K_{t+1} = A_t K_t^alpha + (1-delta) K_t
 *        ln A_{t+1}    = rho ln A_t + eta epsilon_{t+1}
 *
 * (In Dynare's timing convention K_{t+1} is written k and K_t is written
 *  k(-1): the capital stock chosen in period t carries the index t.)
 */

// ---- declarations -------------------------------------------------------
var k c a y i;              // capital, consumption, log TFP, output, investment
varexo e;                   // TFP innovation

parameters gamma alpha beta delta rho eta;

// ---- calibration (quarterly; identical to example.mod) ------------------
gamma = 2;                  // relative risk aversion
alpha = 1/3;                // capital share
beta  = 0.99;               // discount factor
delta = 0.025;              // depreciation rate
rho   = 0.95;               // TFP persistence
eta   = 0.01;               // s.d. of the TFP innovation (log units)

// ---- equilibrium conditions ---------------------------------------------
model;
// (1) Euler equation: households trade off consumption today and tomorrow
c^(-gamma) = beta*c(+1)^(-gamma)*(alpha*exp(a(+1))*k^(alpha-1)+(1-delta));
// (2) resource constraint: production is consumed or accumulated
c + k = exp(a)*k(-1)^alpha + (1-delta)*k(-1);
// (3) exogenous state: TFP follows an AR(1) in logs
a = rho*a(-1) + e;
// definitions (reported by Dynare, no effect on the equilibrium)
y = exp(a)*k(-1)^alpha;
i = k - (1-delta)*k(-1);
end;

// ---- analytical steady state --------------------------------------------
steady_state_model;
k = (alpha/(1/beta-(1-delta)))^(1/(1-alpha));
c = k^alpha - delta*k;
a = 0;
y = k^alpha;
i = delta*k;
end;

steady;                     // compute and display the steady state
check;                      // eigenvalues / Blanchard-Kahn conditions

// ---- shock size ----------------------------------------------------------
shocks;
var e = eta^2;
end;

// ---- solve (first order) and produce IRFs --------------------------------
stoch_simul(order=1, irf=40) y c i k a;
