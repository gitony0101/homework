runif(100,min=2,max=5)




pbinom(k,10,0.3)
# Ex2.5

Nsim = 10^4;lambda=100
spread=3*sqrt(lambda)
t=round(seq(max(0,lambda-spread),lambda+spread,1))
prob=ppois(t,lambda)
X=rep(0,Nsim)
for (i in 1:Nsim){
  u=runif(1)
  x[i]=t[1]+sum((prob<u))
}

# Ex 3.5 

Nsim=10^3
y=rexp(Nsim)+4.5
weit=dnorm(y)/dexp(y-4.5)
plot(cumsum(weit)/1:Nsim)
abline(a=pnorm(-4.5),b=0,col=10)

# Eg 6.1
a=2.7; b=6.3; c=2.669 # initial values 
Nsim=5000
X=rep(runif(1),Nsim) # initialize the chain
for (i in 2:Nsim){ 
  Y=runif(1)
  rho=dbeta(Y,a,b)/dbeta(X[i-1],a,b) 
  X[i]=X[i-1] 
  (Y-X[i-1])*(runif(1)<rho) 
}


