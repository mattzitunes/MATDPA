function [vacsperion storepass] = integralmatt(x,y)

for i=1:length(x)-1
    storepass(i,1) = (x(i+1,1)-x(i,1))*(y(i+1,1)+y(i,1))/2;
end
storepass = storepass;
vacsperion = sum(storepass);