# myfunction computes the simulated mean and variance of standard normal.
myfunction <- function(n){
  x <- rnorm(n)
  mu <- mean(x)
  v <- var(x)
  c(mu = mu, variance = v)
}

n <- 100
myfunction(n)
n <- 10000
myfunction(n)
n <- 1000000
myfunction(n)
# With the increase of simulation times, 
# the simulated mean/variances and theoretical mean/variance tend to be closer and closer.

# Use system.time() to compare the elaspsed times required for different functions
system.time(myfunction(n))

# empirical quantiles of a sample
x <- rnorm(1000)
quantile(x, probs = seq(0, 1, 0.25))

