var k c a V A; 

varexo e; 

parameters gamma alpha beta delta rho eta;

gamma = 2; 
alpha = 1/3;
beta = 0.99;
delta = 0.025; 
rho = 0.95;
set_param_value('eta',eta);

model;
c^(-gamma) = beta*c(+1)^(-gamma)*(alpha*exp(a(+1))*k^(alpha-1)+(1-delta));
c+k = exp(a)*k(-1)^alpha+(1-delta)*k(-1);
a = rho*a(-1)+e;
V = c^(1-gamma)/(1-gamma)+beta*V(+1);
A = exp(a);
end;

steady_state_model;
k = (alpha/(1/beta-(1-delta)))^(1/(1-alpha));
c = k^alpha-delta*k;
a = 0;
V = (c^(1-gamma)/(1-gamma))/(1-beta);
A = exp(a);
end;

shocks; 
var e = eta^2;
end;

stoch_simul(order=1,nograph,noprint);