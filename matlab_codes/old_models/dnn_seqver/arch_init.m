
posN = strfind(arch_name1,'N');
posL = strfind(arch_name1,'L');
posE = strfind(arch_name1,'E');
posR = strfind(arch_name1,'R');
posM = strfind(arch_name1,'M');
posQ = strfind(arch_name1,'Q');
posP = strfind(arch_name1,'P');
posS = strfind(arch_name1,'S');
posfull = sort([posN,posL,posE,posR,posM,posQ,posP,posS]);
posfull = [0 posfull];

nl = [din];
for i = 1:length(posfull)-1
    nl = [nl str2num(arch_name1(posfull(i)+1:posfull(i+1)-1))];
    fl(i) = arch_name1(posfull(i+1));    
end

% Alternate way of initialzing the architecture 
% nl = [din 1500 1500 dout];
% f = [ 'R' 'R' 'L'];

% Do Not Change The Following Variables
nh = length(nl) - 1; % number of hidden layers

if (length(nl) - 1) ~= length(fl)
    disp('number of hidden o/p fns mus be same as number of hidden layers');
end

nlv = 1:nh;
wtl = [1 nl(nlv).*nl(nlv+1)];
wtl = cumsum(wtl);
btl = cumsum([1 nl(nlv+1)]);

arch_name1 = strcat(num2str(din),'L');
for i = 1:nh
    arch_name1 = strcat(arch_name1,num2str(nl(i+1)),fl(i));
end
