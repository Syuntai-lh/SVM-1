function K=SVMkernel(x1,x2,c,var)
if(c=='L')
    K=(x1*x2');
elseif(c=='G')
    K=exp(-norm(x1-x2).^2/(2*var));
end
