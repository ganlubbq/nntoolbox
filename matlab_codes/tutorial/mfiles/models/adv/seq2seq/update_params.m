% encoder

if enc_layers == 1
[p_lf_1] = update_params_lstm(p_lf_1,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lb_1] = update_params_lstm(p_lb_1,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);

elseif enc_layers == 2
[p_lf_1] = update_params_lstm(p_lf_1,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lb_1] = update_params_lstm(p_lb_1,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lf_2] = update_params_lstm(p_lf_2,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lb_2] = update_params_lstm(p_lb_2,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);

elseif enc_layers == 3
[p_lf_1] = update_params_lstm(p_lf_1,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lf_2] = update_params_lstm(p_lf_2,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lf_3] = update_params_lstm(p_lf_3,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lb_1] = update_params_lstm(p_lb_1,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lb_2] = update_params_lstm(p_lb_2,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lb_3] = update_params_lstm(p_lb_3,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
end


% attention
[p_f_3_0] = update_params_ll_ob(p_f_3_0,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_f_3_1] = update_params_ll_ow(p_f_3_1,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_f_3_2] = update_params_ll_ow(p_f_3_2,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);

% decoder
[p_lf_1_dec] = update_params_lstm(p_lf_1_dec,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lf_2_dec] = update_params_lstm(p_lf_2_dec,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_lf_3_dec] = update_params_lstm(p_lf_3_dec,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_f_4_1_dec] = update_params_ll(p_f_4_1_dec,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
[p_f_4_2_dec] = update_params_ll(p_f_4_2_dec,sgd_type,lr,mf,rho_hp,eps_hp,alpha,beta1,beta2,lam,num_up);
