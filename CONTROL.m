
function [xU,xHistory,tHistory,uHistory,tElapsed] = CONTROL(K,centroids,Weight_matrix_V,x_V,Nvar,tspan_V,N,control_duration,polyorder,Xi,usesine,var1,var2,var3)

Q = [1 1 1];                      % State weights
R = 0.0001;                        % du weights
Ru = 0.0001;                       % u weights
%C = eye(Nvar);
%D = 0;
LB = -50*ones(N,1);        % Lower bound of control input
UB = 50*ones(N,1);         % Upper bound of control input






%% MPC



options = optimoptions('fmincon','Algorithm','sqp','Display','none', ...
    'MaxIterations',1000);
%N  = 10;                        % Control / prediction horizon (number of iterations)
Duration = control_duration;                   % Run for 'Duration' time units
Ton = 0;                        % Time units when control is turned on

%getMPCparams

xtemp=x_V(end,:)';                 % Initial condition
x0n = Weight_matrix_V(end,:)';
%xref1 = [sqrt(p.BETA*(p.RHO-1));sqrt(p.BETA*(p.RHO-1));p.RHO-1];     % critical point
%xref1 = [-sqrt(p.BETA*(p.RHO-1));-sqrt(p.BETA*(p.RHO-1));p.RHO-1];
%xref1 = [0.2855;0.3106;0.5443];
xref1 = [0.1;0.4;0.5]; %-point outside the attractor
Tcontrol = tspan_V(end);             %



% Parameters True Model
p.SIGMA = 10;             % True system parameters
p.RHO = 28;
p.BETA = 8/3;



Ts = 0.01;%Models.SINDYc.dt;
controldt = 0.01;
%%



% Prepare variables
Nt = (Duration/Ts)+1;
uopt0    = 0;
xhat     = x0n;
uopt     = uopt0.*ones(N,1);
xHistory = zeros(Nvar,Nt);
xHistory(:,1) = xhat;
uHistory = zeros(1,Nt); uHistory(1)   = uopt(1);
tHistory = zeros(1,Nt); tHistory(1)   = Tcontrol;


pest.ahat = Xi(:,1:Nvar);
pest.polyorder = polyorder;
pest.usesine = usesine;
pest.dt = controldt;
pest.SelectVars = 1:3;



% Start simulation
fprintf('Control sequence initiated.  Please wait for about 40-50 seconds...\n')
tic
for ct = 1:(Duration/Ts)
    % Set references
    xref = xref1;

    % NMPC with full-state feedback
    COSTFUN = @(u) MyObjectiveFCN(u,xhat,N,xref,uopt(1),pest,diag(Q),R,Ru,K,centroids,var1,var2,var3);
    uopt = fmincon(COSTFUN,uopt,[],[],[],[],LB,UB,[],options);


    % Integrate system
    %xtemp = rk4u(@lorenzcontrol_discrete,xtemp,uopt(1),Ts/10,10,[],p);
    lib_func(1,:) = [xhat(var1) xhat(var2) xhat(var3)];
    xhat = rk4u_m(@sparseGalerkinControl_Discrete_m,xhat,uopt(1),Ts/10,10,[],lib_func,var1,var2,var3,pest);
    %xhat = controlXtoCoeffs(xtemp,centroids,K);
    %xhat = xhat.';
    xHistory(:,ct+1) = xhat;
    uHistory(:,ct+1) = uopt(1);
    tHistory(:,ct+1) = ct*Ts+Tcontrol;


end
fprintf('Control sequence finished....plot the results!\n')
%
tElapsed = toc
xHistory = xHistory.';

% %% Unforced
[tU,xU] = ode45(@(t,x)LorenzSys(t,x,0,p),tHistory,x_V(end,1:3),options);   % true model

end