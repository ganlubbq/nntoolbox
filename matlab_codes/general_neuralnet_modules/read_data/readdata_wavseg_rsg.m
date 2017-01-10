
% read train waveform
Y = dlmread(strcat(datapath,'train_bkp.txt'));
Y = Y(1:1000);
Y = Y - mean(Y);

X = Y;
% set input and output dimensions
[N, din] = size(X);
[N, dout] = size(Y);

% set train/val/test number of batches
train_clv = cumsum([1 N]);
train_numbats = length(train_clv) - 1;
val_numbats = 0;
test_numbats = 0;

sl = N;
