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

function [pacm,bacm,acm,hcm,muv,sigv,ym] = fp_cpu_test(X,Wi,W,U,Wy,bh,bo,gn,bn,ff,nl,a_tanh,b_tanh,sl)

pacm = (zeros(sl,nl(2)));
bacm = (zeros(sl,nl(2)));
acm = (zeros(sl,nl(2)));
hcm = (zeros(sl,nl(2)));
hp = (zeros(nl(2),1));
muv = (zeros(nl(2),1));
sigv = (zeros(nl(2),1));
yp = zeros(nl(3),1);
ym = (zeros(sl,nl(3)));

X = X';
is = bsxfun(@plus,Wi*X, bh);

switch ff
    case 'NL'
        for k = 1:sl
            % forward prop
            ac = W*hp + Wy*yp + is(:,k);
            
            % layer normalization
            [pac, bac, ac, mu, sig] = layer_norm(ac, gn, bn);
            
            hc = a_tanh*tanh(b_tanh*ac);
            hp = hc;
            
            yc = U*hc + bo;
            yp = yc;
            
            % store params for T time steps
            pacm(k,:) = pac';
            bacm(k,:) = bac';
            acm(k,:) = ac';
            hcm(k,:) = hc';
            muv(k) = mu;
            sigv(k) = sig;
            ym(k,:) = yc';
        end
        
        
    case 'SL'
        for k = 1:sl
            % forward prop
            ac = W*hp + Wy*yp + is(:,k);
            
            % layer normalization
            [pac, bac, ac, mu, sig] = layer_norm(ac, gn, bn);
            
            hc = 1./(1+(a_tanh*exp(-(b_tanh*ac))));
            hp = hc;
            
            yc = U*hc + bo;
            yp = yc;
            
            % store params for T time steps
            pacm(k,:) = pac';
            bacm(k,:) = bac';
            acm(k,:) = ac';
            hcm(k,:) = hc';
            muv(k) = mu;
            sigv(k) = sig;
            ym(k,:) = yc';
        end
        
    case 'RL' % ReLU components
        
        for k = 1:sl
            % forward prop
            ac = W*hp + Wy*yp + is(:,k);
            
            % layer normalization
            [pac, bac, ac, mu, sig] = layer_norm(ac, gn, bn);
            
            hc = max(0,ac);
            hp = hc;
            
            yc = U*hc + bo;
            yp = yc;
            
            % store params for T time steps
            pacm(k,:) = pac';
            bacm(k,:) = bac';
            acm(k,:) = ac';
            hcm(k,:) = hc';
            muv(k) = mu;
            sigv(k) = sig;
            ym(k,:) = yc';
        end
        
    case 'EL' % ELU components
        
        for k = 1:sl
            % forward prop
            ac = W*hp + Wy*yp + is(:,k);
            
            % layer normalization
            [pac, bac, ac, mu, sig] = layer_norm(ac, gn, bn);
            
            hc = max(0,ac);
            hc(ac<=0) = exp(ac(ac<=0))-1;
            hp = hc;
            
            yc = U*hc + bo;
            yp = yc;
            
            % store params for T time steps
            pacm(k,:) = pac';
            bacm(k,:) = bac';
            acm(k,:) = ac';
            hcm(k,:) = hc';
            muv(k) = mu;
            sigv(k) = sig;
            ym(k,:) = yc';
        end
        
    case 'LL'
        for k = 1:sl
            % forward prop
            ac = W*hp + Wy*yp + is(:,k);
            
            % layer normalization
            [pac, bac, ac, mu, sig] = layer_norm(ac, gn, bn);
            
            hc = ac;
            hp = hc;
            
            yc = U*hc + bo;
            yp = yc;
            
            % store params for T time steps
            pacm(k,:) = pac';
            bacm(k,:) = bac';
            acm(k,:) = ac';
            hcm(k,:) = hc';
            muv(k) = mu;
            sigv(k) = sig;
            ym(k,:) = yc';
        end
        
    otherwise
        disp('error: please enter a valid output function name (N/S/R/M/L)');
        return;
end

end
