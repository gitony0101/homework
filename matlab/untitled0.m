%%
for i=1:10
    x=linspace(0,10,101);
    plot(x,sin(x+i));
    print(gcf,'-deps',stract('plot',num2str(i),'.ps'));
end
%%
a = 3
if rem(1,2) ==0
    disp('a is even')
else
    disp ('a is odd')
end
%%
input_num = 1;
switch input_num
    case -1 
        disp('negative 1');
    case 0
        disp('zero');
    case 1 
        disp('other value');
end
%%
n = 1;
while prod(1:n) < 1e100 ;n = n +1;
end
%%
n = 1;
while sum(1:n) < 1000 n = n +1;
end
%%
 for n = 1:10
a(n)=2^n;
 end
 disp(a)
%%
x=2;k=0;error=inf;
error_threshold = 1e-32;
while error > error_threshold
    if k > 100
        break
    end
    x = x - sin(x)/cos(x);
    error= abs(x-pi);
    k = k+1;
end


