% weight initialization
p = []; [p_f_1] = wt_init_ll(p,gpu_flag,nl(2),nl(1),si,wtdir,wtinit_meth,sgd_type);
p = []; [p_f_2] = wt_init_ll(p,gpu_flag,nl(3),nl(2),si,wtdir,wtinit_meth,sgd_type);

p = []; [p_h_1] = wt_init_hl(p,gpu_flag,nl(4),nl(3),si,btbf,wtdir,wtinit_meth,sgd_type);
p = []; [p_h_2] = wt_init_hl(p,gpu_flag,nl(5),nl(4),si,btbf,wtdir,wtinit_meth,sgd_type);
p = []; [p_h_3] = wt_init_hl(p,gpu_flag,nl(6),nl(5),si,btbf,wtdir,wtinit_meth,sgd_type);
p = []; [p_h_4] = wt_init_hl(p,gpu_flag,nl(7),nl(6),si,btbf,wtdir,wtinit_meth,sgd_type);

p = []; [p_lf_1] = wt_init_lstm(p,nl(8),nl(7),si,fb_init,wtdir,wtinit_meth,sgd_type);
p = []; [p_lb_1] = wt_init_lstm(p,nl(8),nl(7),si,fb_init,wtdir,wtinit_meth,sgd_type);

p = []; [p_f_3_1] = wt_init_ll(p,gpu_flag,nl(end),nl(end-1),si,wtdir,wtinit_meth,sgd_type);
p = []; [p_f_3_2] = wt_init_ll(p,gpu_flag,nl(end),nl(end-1),si,wtdir,wtinit_meth,sgd_type);

% get full arch_name
get_fullarchname

% train the model
train_lstm