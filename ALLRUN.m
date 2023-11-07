%% Code for cluster regression model for control of nonlinear dynamics

% cite the following

% Brunton, Steven L., Joshua L. Proctor, and J. Nathan Kutz. "Discovering governing equations from data by sparse identification of nonlinear dynamical systems." Proceedings of the national academy of sciences 113.15 (2016): 3932-3937.
% Kaiser, Eurika, et al. "Cluster-based reduced-order modelling of a mixing layer." Journal of Fluid Mechanics 754 (2014): 365-414.
% Kaiser, Eurika, J. Nathan Kutz, and Steven L. Brunton. "Sparse identification of nonlinear dynamics for model predictive control in the low-data limit." Proceedings of the Royal Society A 474.2219 (2018): 20180335.
% Nair, Aditya G., et al. "Cluster-based feedback control of turbulent post-stall separated flows." Journal of Fluid Mechanics 875 (2019): 345-375.


clear; close all; clc
addpath('utils');
addpath('src/');

%% Parameters for data generation
dt = 0.001;
T = 20; %total time (training + validation) 
x0 = [-8; 8; 27]; %initial condition for Lorenz System with forcing

%% Parameters for clustering

K = 10; %number of clusters
num_var = 3; %variables corresponding to one cluster for dynamic model
Nvar = num_var*K; % total number of variables 3*K

%% Parameters for Regression Model

polyorder = 2;
usesine = 0;
lambda = 0;

%% Data generation

[x,x_V,u,u_V,tspan,tspan_V] = DATA_GENERATION (dt,T,x0);

%% Clustering 

[X,X_ORG,UU1,UU2,t,centroids,clusterIndices,trainPoints] = CLUSTER_DATA(K,x,x_V,u,u_V,tspan,tspan_V);

%% Cluster-based Decomposition

[Weight_matrix,Weight_matrix_V] = CLUSTER_DECO(X,centroids,trainPoints);

%% Regression Model (takes some time)

[cii,Theta,Xi,xaug,dx] = REGRESS_PARAM(Weight_matrix,UU1,polyorder,usesine,dt,Nvar,lambda);

%% calculate Dynamics for regression model through truncated basis

varList = zeros(1,num_var+1);

for i =2:2+num_var
    varList(1,i-1) = cii(1,i) - 1;
end

var1 = varList(1,1); var2 = varList(1,2); var3 = varList(1,3);

[xMODEL_train_m,xMODEL_test_m] = CALC_DYNAMICS_m(xaug,Weight_matrix,Weight_matrix_V,UU1,UU2,Nvar,Xi,polyorder,usesine,dt,var1,var2,var3);

%% plot model prediction
 PLOT_TRAIN_TEST_m(K,tspan,tspan_V,trainPoints,xMODEL_train_m,xMODEL_test_m,centroids,X_ORG)
 %% model predictive control
 % control of point outside the attractor

N = 10;                %control, prediction horizon
control_duration = 5; 
[xU,xHistory,tHistory,uHistory,exec_time] = CONTROL(K,centroids,Weight_matrix_V,x_V,Nvar,tspan_V,N,control_duration,polyorder,Xi,usesine,var1,var2,var3);
 %% control of point outside the attractor
 
 PLOT_MPC(K,xU,xHistory,tHistory,uHistory,centroids,X_ORG);
