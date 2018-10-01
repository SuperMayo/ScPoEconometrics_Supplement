# Create some fake data
x = runif(30) * 10
y = 5 + 2*x + 2*rnorm(30)

# Store the linear regression results
result = lm(y ~ x)
intercept = result$coefficient[1]
slope = result$coefficient[2]

# Create a data frame with data, prediction(yhat) and residuals(e)
data = data.frame(
  y = y,
  x = x,
  yhat = intercept + x * slope,
  e = y - (intercept + x * slope)
)

# Mean of y and prediction is the same
print(mean(data$y))
print(mean(data$yhat))

# The mean of error is zero
print(mean(data$e))

# The error and the prediction are uncorrelated
cor(data$yhat, data$e)

# Computing the R2
SSR = sum((data$y - data$yhat)^2)
SSR_bench = sum((data$y-mean(data$y))^2)
R2 = 1 - SSR/SSR_bench
print(R2)