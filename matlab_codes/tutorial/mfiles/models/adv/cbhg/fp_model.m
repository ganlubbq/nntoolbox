
% 2 - feedforward layers with dropout (pre-net)
hm_f_1 = fp_cpu_ll(X,p_f_1,f(1));
[hm_f_1,dm_f_1] = fp_dropout(hm_f_1,dp(1),nl(2));
hm_f_2 = fp_cpu_ll(hm_f_1,p_f_2,f(2));
[hm_f_2,dm_f_2] = fp_dropout(hm_f_2,dp(2),nl(3));

% Convolution bank 
hm_c_1 = fp_clb(hm_f_2,p_c_1,K_conv_l1,C_conv_l1,nl(3),'R',sl);
hm_c_2 = fp_cl(hm_c_1,p_c_2.U,K_conv_l2,C_conv_l2,K_conv_l1*C_conv_l1,'R',sl);
hm_c_3 = fp_cl(hm_c_2,p_c_3.U,K_conv_l2,C_conv_l2,C_conv_l2,'L',sl);
hm_c_4 = hm_c_3 + hm_f_2; % residual modification

% 4 - Highway layers
[tm_h_1,htm_h_1,hm_h_1] = fp_hl(hm_c_4,p_h_1,f(3));
[tm_h_2,htm_h_2,hm_h_2] = fp_hl(hm_h_1,p_h_2,f(4));
[tm_h_3,htm_h_3,hm_h_3] = fp_hl(hm_h_2,p_h_3,f(5));
[tm_h_4,htm_h_4,hm_h_4] = fp_hl(hm_h_3,p_h_4,f(6));

% 1 - BLSTM Layer
[zfm,ifm,ffm,cfm,ofm,hcfm,hfm] = fp_lstm(hm_h_4,p_lf_1,nl(8),sl,'frnn');
[zbm,ibm,fbm,cbm,obm,hcbm,hbm] = fp_lstm(hm_h_4,p_lb_1,nl(8),sl,'brnn');

% Final Output Layer
switch f(end)
    case 'L'
        ac = p_f_3_1.U*hfm' + p_f_3_2.U*hbm';        
        ac = bsxfun(@plus,ac,p_f_3_1.bu)';
        ym = ac;
    case 'M'
        ac = p_f_3_1.U*hfm' + p_f_3_2.U*hbm';
        ac = bsxfun(@plus,ac,p_f_3_1.bu)';
        ym = get_actf('M',ac);
end

