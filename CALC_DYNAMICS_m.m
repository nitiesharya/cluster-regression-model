function [xMODEL_train_m,xMODEL_testing_m] = CALC_DYNAMICS_m(xaug,Weight_matrix,Weight_matrix_V,UU1,UU2,Nvar,Xi_m,polyorder,usesine,dt,var1,var2,var3)

%-------------------------------------training------------------------------

p.ahat = Xi_m(:,1:Nvar);
p.polyorder = polyorder;
p.usesine = usesine;
p.dt = dt;
p.SelectVars = 1:3;

[Np,Ns] = size(xaug(:,1:end-1));
%d0init = xaug(1,1:end-1); 
d0init = Weight_matrix(3,:);


xMODEL = zeros(Ns,Np); xMODEL(:,1) = d0init';lib_func = zeros(1,3);
UUU1 = UU1(3:end-3,1);



for ct=1:Np-1
    lib_func(1,:) = [xMODEL(var1,ct) xMODEL(var2,ct) xMODEL(var3,ct)];
    xMODEL(:,ct+1) = rk4u_m(@sparseGalerkinControl_Discrete_m,xMODEL(:,ct),UUU1(ct),dt,1,[],lib_func,var1,var2,var3,p);
end
xMODEL_train_m = xMODEL';
%--------------------------------------------------------------------------



%-----------------------TESTING--------------------------------------------

[Np,Ns] = size(Weight_matrix_V);  
d0init1 = Weight_matrix_V(1,:);

xMODEL_V = zeros(Ns,Np-5); xMODEL_V(:,1) = d0init1';lib_func = zeros(1,3);

for ct=1:Np-5
    lib_func(1,:) = [xMODEL_V(var1,ct) xMODEL_V(var2,ct) xMODEL_V(var3,ct)];
    xMODEL_V(:,ct+1) = rk4u_m(@sparseGalerkinControl_Discrete_m,xMODEL_V(:,ct),UU2(ct),dt,1,[],lib_func,var1,var2,var3,p);
end
xMODEL_testing_m = xMODEL_V';

end