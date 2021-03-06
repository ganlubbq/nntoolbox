%{
###########################################################################
##                                                                       ##
##                                                                       ##
##                       IIIT Hyderabad, India                           ##
##                      Copyright (c) 2015                               ##
##                        All Rights Reserved.                           ##
##                                                                       ##
##  Permission is hereby granted, free of charge, to use and distribute  ##
##  this software and its documentation without restriction, including   ##
##  without limitation the rights to use, copy, modify, merge, publish,  ##
##  distribute, sublicense, and/or sell copies of this work, and to      ##
##  permit persons to whom this work is furnished to do so, subject to   ##
##  the following conditions:                                            ##
##   1. The code must retain the above copyright notice, this list of    ##
##      conditions and the following disclaimer.                         ##
##   2. Any modifications must be clearly marked as such.                ##
##   3. Original authors' names are not deleted.                         ##
##   4. The authors' names are not used to endorse or promote products   ##
##      derived from this software without specific prior written        ##
##      permission.                                                      ##
##                                                                       ##
##  IIIT HYDERABAD AND THE CONTRIBUTORS TO THIS WORK                     ##
##  DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING      ##
##  ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT   ##
##  SHALL IIIT HYDERABAD NOR THE CONTRIBUTORS BE LIABLE                  ##
##  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    ##
##  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN   ##
##  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,          ##
##  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF       ##
##  THIS SOFTWARE.                                                       ##
##                                                                       ##
###########################################################################
##                                                                       ##
##          Author :  Sivanand Achanta (sivanand.a@research.iiit.ac.in)  ##
##          Date   :  Jul. 2015                                          ##
##                                                                       ##
###########################################################################
%}

%clear all; close all; clc;


%% Step 1 : Make Training data
temp_clv_s = [];
temp_clv_t = [];
train_batchdata = [];
train_batchtargets = [];
m = 0;
v = 0;

nb = dir(strcat(datadir,'train*'));
nb = length(nb);

for i = 1:nb
    
    fprintf('Loading batch %d ... \n',i);
    load(strcat(datadir,'train',num2str(i),'.mat'));
    
    % Step1: make training data
    data = single(data);
    targets = single(targets);
    
    if sum(sum(isnan(data)))
        disp('there are NaN eles in data');
        pause
    end
    
    if sum(sum(isnan(targets)))
        disp('there are NaN eles in targets');
        pause
    end
    
    % Input file preprocessing
    if intmvnf
        m = m + sum(data);
        v = v + sum(data.^2);
    end
    
    train_batchdata = single([train_batchdata;data]);
    train_batchtargets = single([train_batchtargets;targets]);
    
    clv_s = clv_s(:)';
    temp_clv_s = [temp_clv_s clv_s];
    
    clv_t = clv_t(:)';
    temp_clv_t = [temp_clv_t clv_t];
    
    clear data targets clv_s clv_t
end

[Nin,din] = size(train_batchdata);
[Nout,dout] = size(train_batchtargets);

train_clv_s = [1 temp_clv_s];
train_clv_s = cumsum(train_clv_s);

train_numbats = length(train_clv_s) - 1

train_clv_t = [1 temp_clv_t];
train_clv_t = cumsum(train_clv_t);

train_numbats = length(train_clv_t) - 1

% Input feature normalization
if intmvnf
    disp('Normalizing input feats using mean variance normalization ...')
    
    m = m/Nin;
    v = sqrt(v/(Nin-1) - m.^2);
    save(strcat(datadir,'mvni.mat'),'m','v');
    
    mini = min(train_batchdata) - 0.1;
    maxi = max(train_batchdata) - mini + 0.1;
    save(strcat(datadir,'maxmini.mat'),'maxi','mini');
    
    for i = mvnivec
        I1 = bsxfun(@minus,train_batchdata(:,i),m(:,i));
        I1 = bsxfun(@rdivide,I1,v(:,i)+1e-5);
        train_batchdata(:,i) = I1;
    end
    
    clear I1;
end

if intmmnf
    disp('Normalizing input feats using min max normalization ...')
    
    m = m/Nin;
    v = sqrt(v/(Nin-1) - m.^2);
    save(strcat(datadir,'mvni.mat'),'m','v');
    
    mini = min(train_batchdata) - 0.1;
    maxi = max(train_batchdata) - mini + 0.1;
    save(strcat(datadir,'maxmini.mat'),'maxi','mini');
    
    for i = mvnivec
        I1 = bsxfun(@minus,train_batchdata(:,i),mini(:,i));
        I1 = bsxfun(@rdivide,I1,maxi(:,i)+1e-5);
        train_batchdata(:,i) = I1;
    end
    
    clear I1;
end


% Output features normaization
if outtmvnf
    disp('Normalizing output feats using mean variance normalization ...');
    
    mo = mean(train_batchtargets);
    vo = std(train_batchtargets);
    save(strcat(datadir,'mvno.mat'),'mo','vo');
    
    minv = min(train_batchtargets) - 0.1;
    maxv = max(train_batchtargets) - minv + 0.1;
    save(strcat(datadir,'maxmino.mat'),'maxv','minv');
    
    for i = 1:dout
        I1 = bsxfun(@minus,train_batchtargets(:,i),mo(:,i));
        I1 = bsxfun(@rdivide,I1,vo(:,i)+1e-5);
        train_batchtargets(:,i) = I1;
    end
    
    clear I1
end

if outtmmnf
    disp('Normalizing output feats using min max normalization ...');
    
    mo = mean(train_batchtargets);
    vo = std(train_batchtargets);
    save(strcat(datadir,'mvno.mat'),'mo','vo');
    
    minv = min(train_batchtargets) - 0.1;
    maxv = max(train_batchtargets) - minv + 0.1;
    save(strcat(datadir,'maxmino.mat'),'maxv','minv');
    
    for i = 1:dout
        I1 = bsxfun(@minus,train_batchtargets(:,i),minv(:,i));
        I1 = bsxfun(@rdivide,I1,maxv(:,i));
        train_batchtargets(:,i) = I1;
    end
    
    clear I1
end

train_batchtargets = train_batchtargets(:,outvec);

totnum = size(train_batchdata,1);
fprintf(1, 'Size of the training dataset %5d \n', totnum);

if sum(sum(isnan(train_batchdata)))
    disp('there are NaN eles in train data');
    pause
end

if sum(sum(isnan(train_batchtargets)))
    disp('there are NaN eles in train targets');
    pause
end

%% Step 2 : Make Validation data

load(strcat(datadir,'val.mat'));
val_batchdata = single(data);
if intmvnf
    I1 = bsxfun(@minus,val_batchdata(:,mvnivec),m(:,mvnivec));
    I1 = bsxfun(@rdivide,I1,v(:,mvnivec)+1e-5);
    val_batchdata(:,mvnivec) = I1;
    clear I1
end

if intmmnf
    I1 = bsxfun(@minus,val_batchdata(:,mvnivec),mini(:,mvnivec));
    I1 = bsxfun(@rdivide,I1,maxi(:,mvnivec)+1e-5);
    val_batchdata(:,mvnivec) = I1;
    clear I1
end


val_batchtargets = single(targets);
if outtmvnf
    I1 = bsxfun(@minus,val_batchtargets,mo);
    I1 = bsxfun(@rdivide,I1,vo+1e-5);
    val_batchtargets = I1;
end

if outtmmnf
    I1 = bsxfun(@minus,val_batchtargets,minv);
    I1 = bsxfun(@rdivide,I1,maxv);
    val_batchtargets = I1;
    clear I1
end

val_batchtargets = single(val_batchtargets(:,outvec));
clv_s = clv_s(:)';
val_clv_s = cumsum([1 clv_s]);
val_numbats = length(val_clv_s) - 1
clv_t = clv_t(:)';
val_clv_t = cumsum([1 clv_t]);
val_numbats = length(val_clv_t) - 1

clear data targets clv_s clv_t

if sum(sum(isnan(val_batchdata)))
    disp('there are NaN eles in val data');
    pause
end

if sum(sum(isnan(val_batchtargets)))
    disp('there are NaN eles in val targets');
    pause
end

%% Step 3 : Make Test data

load(strcat(datadir,'val.mat'));
test_batchdata = single(data);
if intmvnf
    I1 = bsxfun(@minus,test_batchdata(:,mvnivec),m(:,mvnivec));
    I1 = bsxfun(@rdivide,I1,v(:,mvnivec)+1e-5);
    test_batchdata(:,mvnivec) = I1;
    clear I1
end

if intmmnf
    I1 = bsxfun(@minus,test_batchdata(:,mvnivec),mini(:,mvnivec));
    I1 = bsxfun(@rdivide,I1,maxi(:,mvnivec)+1e-5);
    test_batchdata(:,mvnivec) = I1;
    clear I1
end



test_batchtargets = single(targets);
if outtmvnf
    I1 = bsxfun(@minus,test_batchtargets,mo);
    I1 = bsxfun(@rdivide,I1,vo+1e-5);
    test_batchtargets = I1;
    clear I1
end
if outtmmnf
    I1 = bsxfun(@minus,test_batchtargets,minv);
    I1 = bsxfun(@rdivide,I1,maxv);
    test_batchtargets = I1;
    clear I1
end

test_batchtargets = single(test_batchtargets(:,outvec));
clv_s = clv_s(:)';
test_clv_s = cumsum([1 clv_s]);
test_numbats = length(test_clv_s) - 1

clv_t = clv_t(:)';
test_clv_t = cumsum([1 clv_t]);
test_numbats = length(test_clv_t) - 1

clear data targets clv_s clv_t

if sum(sum(isnan(test_batchdata)))
    disp('there are NaN eles in test data');
    pause
end

if sum(sum(isnan(test_batchtargets)))
    disp('there are NaN eles in test targets');
    pause
end

disp('size of train i/o data');
[Nin,din] = size(train_batchdata)
[Nout,dout] = size(train_batchtargets)

disp('Number of Train, Validation and Test Batches ...')
train_numbats
val_numbats
test_numbats





