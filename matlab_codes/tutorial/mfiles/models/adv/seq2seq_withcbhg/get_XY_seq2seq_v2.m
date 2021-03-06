function [X, Yf, Yp, Y2, sl_enc, sl_dec] = get_XY_seq2seq_v2(train_batchdata, train_batchtargets, train_clv_s, train_clv_t, rp, i, Em, outvec1, outvec2)

X = train_batchdata(train_clv_s(rp(i)):train_clv_s(rp(i)+1)-1,:);
sl_enc = size(X,1);

Y = train_batchtargets(train_clv_t(rp(i)):train_clv_t(rp(i)+1)-1,outvec1);
Y2 = train_batchtargets(train_clv_t(rp(i)):train_clv_t(rp(i)+1)-1,outvec2);

sl_dec = size(Y,1);

% Put "r" frames together
if mod(sl_dec,2) == 0
    Ye = Y(2:2:end,:);
    Yo = Y(1:2:end,:);
else
    Y = Y(1:end-1,:);
    Y2 = Y2(1:end-1,:);
    Ye = Y(2:2:end,:);
    Yo = Y(1:2:end,:);
end

Yf = [Ye Yo];
sl_dec = size(Yf,1);

Yp = [zeros(1,size(Ye,2));Ye(1:end-1,:)];

end
