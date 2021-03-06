function [gWn] = compute_NumericalGrad(Wi,Wfr,bh,U,bo,gn,bn,X,Y,f,nl,a_tanh,b_tanh,sl,cfn,W_toCheck,argno,gpu_flag,lr_fw,dr_fw)

W1 = Wi;
W2 = Wfr;
W3 = bh;
W4 = U;
W5 = bo;
W6 = gn;
W7 = bn;

% perturbation magnitude at x
h = 1e-6;

% Compute the numerical gradient
[nr,nc]  = size(W_toCheck);

if gpu_flag
    gWn      = gpuArray(zeros(nr,nc));
else
    gWn      = (zeros(nr,nc));
end

for cc = 1:nc
    for cr = 1:nr
        
        switch argno
            case 1
                W1 = W_toCheck; W1(cr,cc) = W1(cr,cc) + h;
            case 2
                W2 = W_toCheck; W2(cr,cc) = W2(cr,cc) + h;        
            case 3
                W3 = W_toCheck; W3(cr,cc) = W3(cr,cc) + h;
            case 4
                W4 = W_toCheck; W4(cr,cc) = W4(cr,cc) + h;        
            case 5
                W5 = W_toCheck; W5(cr,cc) = W5(cr,cc) + h;
            case 6
                W6 = W_toCheck; W6(cr,cc) = W6(cr,cc) + h;
            case 7
                W7 = W_toCheck; W7(cr,cc) = W7(cr,cc) + h;
                
        end
        
        
        [f_xph] = compute_Fofx(X,Y,W1,W2,W3,W4,W5,W6,W7,f,nl,a_tanh,b_tanh,sl,cfn,lr_fw,dr_fw);
        
        switch argno
            case 1
                W1 = W_toCheck; W1(cr,cc) = W1(cr,cc) - h;
            case 2
                W2 = W_toCheck; W2(cr,cc) = W2(cr,cc) - h;        
            case 3
                W3 = W_toCheck; W3(cr,cc) = W3(cr,cc) - h;
            case 4
                W4 = W_toCheck; W4(cr,cc) = W4(cr,cc) - h;        
            case 5
                W5 = W_toCheck; W5(cr,cc) = W5(cr,cc) - h;
            case 6
                W6 = W_toCheck; W6(cr,cc) = W6(cr,cc) - h;
            case 7
                W7 = W_toCheck; W7(cr,cc) = W7(cr,cc) - h;
                
        end
        
        [f_xnh] = compute_Fofx(X,Y,W1,W2,W3,W4,W5,W6,W7,f,nl,a_tanh,b_tanh,sl,cfn,lr_fw,dr_fw);
        
        gWn(cr,cc) = (f_xph-f_xnh)/(2*h);
    end
end


end