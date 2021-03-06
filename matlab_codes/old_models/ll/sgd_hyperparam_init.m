switch sgd_type
    case 'sgdcm'
        lr_vec = [1e-1];
        mf_vec = [0.0];
    case 'adadelta'
        rho_vec = [0.98];
        eps_vec = [1e-8 1e-9];
        mf_vec = [0];
    case 'adam'
        alpha_vec = [1e-3 1e-4];
        beta1_vec = [0.9];
        beta2_vec = [0.999];
        eps_hp = 1e-6;
        lam = 1 - eps_hp;
end
