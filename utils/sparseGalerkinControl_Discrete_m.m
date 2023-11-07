function ykplus1 = sparseGalerkinControl_Discrete_m(t,y,u,lib_func,var1,var2,var3,p)

if isfield(p,'SelectVars')==0
    p.SelectVars = 1:length(y);
end
polyorder = p.polyorder;
usesine = p.usesine;
ahat = p.ahat;
lib_func = [y(var1) y(var2) y(var3)];
%yPool = poolData([y(p.SelectVars)' u],length(p.SelectVars)+1,polyorder,usesine)
yPool = poolData([lib_func u],length(p.SelectVars)+1,polyorder,usesine);
ykplus1 = (yPool*ahat)';