function [X,X_ORG,UU1,UU2,t,c1_Centers,c1_Labels,trainPoints] = CLUSTER_DATA(K,x,x_V,u,u_V,tspan,tspan_V)

%% Normalize variables

xtemp1 = x(1:end-1,:);
xtemp = [xtemp1;x_V];

X_ORG = xtemp;

utemp1 = u(1:end-1,:);
utemp = [utemp1;u_V];

U_ORG = utemp;

ttemp1 = tspan(:,1:end-1);
t = [ttemp1 tspan_V];


U1 = [u;u_V];
x1 = xtemp(:,1);
x2 = xtemp(:,2);
x3 = xtemp(:,3);

X = [(x1(1:end) - min(x1(1:end)))/(max(x1(1:end)) - min(x1(1:end))) ...
    (x2(1:end) - min(x2(1:end)))/(max(x2(1:end)) - min(x2(12:end))) ...
    (x3(1:end) - min(x3(1:end)))/(max(x3(1:end)) - min(x3(1:end)))];

UU1 = (u(1:end) - min(U1(1:end)))/(max(U1(1:end)) - min(U1(1:end)));
UU2 = (u_V(1:end) - min(U1(1:end)))/(max(U1(1:end)) - min(U1(1:end)));

%t = dt:dt:20*dt;
trainPoints = size(x,1);

%% Prepare Data & options

Data2crom.dt = t(2)-t(1);
Data2crom.t  = t;
Data2crom.ts = X;
params_user.nRepetitions         = 10;
params_user.optimalClustering    = 'sparsity';
params_user.ClusterOrdering      ='transitions';
params_user.save                 = 1;
params_user.verbose              = 0;
params_user.plot                 = 0;
params_user.nClusters      	     = K; 

%% Run CROM (Cluster-based reduced order modeling)

CROMobj = CROM(Data2crom,params_user);
CROMobj.run;

%% Extract clustering centroids

ai         = CROMobj.Data.ts;
c1_Centers = CROMobj.c1_Centroids;
c1_Labels  = CROMobj.c1_Labels;

%% Plotting

Cluster_plot(K,x1,x3,x2,c1_Centers,c1_Labels,ai);

end