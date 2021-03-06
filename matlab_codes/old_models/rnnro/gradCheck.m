if gradCheckFlag
    
    % Compute numerical gradient
    argno = 1; [gWin] = compute_NumericalGrad(GWi,GWfr,Gbh,GU,GUfr,Gbo,X,Y,f,nl,a_tanh,b_tanh,sl,cfn,GWi,argno,gpu_flag,gt_flag);
    argno = argno + 1; [gWfrn]  = compute_NumericalGrad(GWi,GWfr,Gbh,GU,GUfr,Gbo,X,Y,f,nl,a_tanh,b_tanh,sl,cfn,GWfr,argno,gpu_flag,gt_flag);
    argno = argno + 1; [gbhn]  = compute_NumericalGrad(GWi,GWfr,Gbh,GU,GUfr,Gbo,X,Y,f,nl,a_tanh,b_tanh,sl,cfn,Gbh,argno,gpu_flag,gt_flag);
    argno = argno + 1; [gUn]  = compute_NumericalGrad(GWi,GWfr,Gbh,GU,GUfr,Gbo,X,Y,f,nl,a_tanh,b_tanh,sl,cfn,GU,argno,gpu_flag,gt_flag);
    argno = argno + 1; [gUfrn]  = compute_NumericalGrad(GWi,GWfr,Gbh,GU,GUfr,Gbo,X,Y,f,nl,a_tanh,b_tanh,sl,cfn,GUfr,argno,gpu_flag,gt_flag);
    argno = argno + 1; [gbon]  = compute_NumericalGrad(GWi,GWfr,Gbh,GU,GUfr,Gbo,X,Y,f,nl,a_tanh,b_tanh,sl,cfn,Gbo,argno,gpu_flag,gt_flag);
    
    % Compute the difference between numerical and back-prop gradients
    [dgWin] = compute_gradDiff_fn(gWin,gWi,'gWi');
    [dgWfrn] = compute_gradDiff_fn(gWfrn,gWfr,'gWfr');
    [dgbhn] = compute_gradDiff_fn(gbhn,gbh,'gbh');
    [dgUn] = compute_gradDiff_fn(gUn,gU,'gU');
    [dgUfrn] = compute_gradDiff_fn(gUfrn,gUfr,'gUfr');
    [dgbon] = compute_gradDiff_fn(gbon,gbo,'gbo');
    
    pause
    
end