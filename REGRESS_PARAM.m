function [cii,Theta,Xi,xaug,dx] = REGRESS_PARAM(Weight_matrix,UU1,polyorder,usesine,dt,Nvar,lambda)
   

SelectVars = 1:Nvar;
  

dx = zeros(length(Weight_matrix)-5,Nvar);
for i=3:length(Weight_matrix)-3
    for k=1:Nvar
        %dx(i-2,k) = (1/(12*dt))*(-distance_matrix(i+2,SelectVars(k))+8*distance_matrix(i+1,SelectVars(k))-8*distance_matrix(i-1,SelectVars(k))+distance_matrix(i-2,SelectVars(k)));
        dx(i-2,k) = (1/(12*dt))*(-Weight_matrix(i+2,SelectVars(k))+8*Weight_matrix(i+1,SelectVars(k))-8*Weight_matrix(i-1,SelectVars(k))+Weight_matrix(i-2,SelectVars(k)));
    end
end


xaug = [Weight_matrix(3:end-3,SelectVars) UU1(3:end-3,:)];
dx(:,Nvar+1) = 0*dx(:,1);
n = size(dx,2);


Theta = poolData(xaug,n,polyorder,usesine);
rank(Theta)

%-----QR pivoting

[Q,R,p] = qr(Theta,'vector');
dr = abs(diag(R));
if dr(1)
    tol = 1e-10;
    r = find(dr>=tol*dr(1),1,'last');
    ci = p(1:r); % here is the index of independent columns
else
    r = 0;
    ci = [];
end
cii = sort(ci);
% Submatrix with r columns (and full column rank).
Theta=Theta(:,cii);

%Theta = orth(Theta);
Xi = sparsifyDynamics(Theta,dx,lambda,n-1);
%Xi_m = sparsifyDynamics(Theta_m,dx,lambda,n-1);
%newout = poolDataLIST_CONTROL({'p1','p2','p3','p4','p5','p6','p7','p8','p9','p10','q1','q2','q3','q4','q5','q6','q7','q8','q9','q10','r1','r2','r3','r4','r5','r6','r7','r8','r9','r10','u'},Xi,31,polyorder,usesine);
%newout = 0;
end