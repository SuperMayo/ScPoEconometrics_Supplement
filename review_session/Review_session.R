# ======
# BIASES
# ======

# 1. Omitted variable bias:
# true DGP: Y = B_0 + B_1 X + B_2 Z + ε
# but we model
# Y = b_0 + b_1 X + e
# X is correlated with e which violates the Gauss Markov assumptions
# This will lead to a bias in b_1 which depends on the correlation between X and Z.

library("Ecdat")
data("Housing")

fit = lm(log(price) ~ bathrms, data = Housing)
summary(fit)
# Here we find that an additional bathroom increases the price by 35 % !!
# But maybe there are some variables that are correlated with the number of bathrooms that
# also have an effect on the price ?

cor(Housing[,c("price", "lotsize", "bedrooms", "bathrms", "stories")])
fit = lm(log(price) ~ bathrms + log(lotsize) + bedrooms + stories, data = Housing)
summary(fit)
# Now the estimated effect of the number of bathrooms on price is of 25% !
# Note that in both cases the coefficient was significant at 5%

# ======
# REVIEW
# ======

# Boxplots and distributions
# ==========================
ggplot(Housing %>% mutate(stories = factor(stories)),
       aes(x = stories, y = price)) +
  geom_boxplot() +
  theme_minimal()

# 50% of the distribution lies in the box
# The "whiskers" can go up to 1.5 times the interquartile range
# All remaining data will be plotted as points and considered outliers

# You can also plot it as histogram
ggplot(Housing %>% mutate(stories = factor(stories)),
       aes(price, fill = stories)) +
  geom_histogram()

# Stat & estimates
# ================

# MEAN
Mean = function(sample){
  return(
    sum(sample)/length(sample)
  )
}

# Variance
Variance = function(sample){
  return(
    mean( (sample - mean(sample))^2 )
  )
}

# Corrected variance (the one used by R)
Variance2 = function(sample){
  return(
    sum((sample - mean(sample))^2) / (length(sample) - 1)
  )
}

# Standard deviation
# Hint: If your data is normally distributed, the standard deviation ~= range/4
Stdev = function(sample){
  return(
    sqrt(Variance2(sample))
  )
}

# Covariance
Cov = function(sample1, sample2){
  n = length(sample1)
  return(
    Mean(
      (sample1 - Mean(sample1)) * (sample2 - Mean(sample2))
    ) * (n/(n-1))
  )
}

# Correlation
Corr = function(sample1, sample2){
  return(
    Cov(sample1, sample2) / (Stdev(sample1) * Stdev(sample2))
  )
}


# Estimation
# ==========
# In univariate case:
# model: y = b_0 + b_1 x + e
# b_0 = mean(y) - b_1 mean(x)
# b_1 = Cov(x,y)/Var(x)

reg_univariate = function(y, x){
  b_1 = Cov(x,y) / Variance2(x)
  b_0 = mean(y) - b_1 * mean(x)
  return(c(b_0, b_1))
}

# R2
R2 = function(fit){
  y   = fit$model[,1]
  SSE = sum( (predict(fit) - Mean(y) )^2)
  SST = sum( (y            - Mean(y) )^2)
  return(SSE/SST)
}

# Intercepts
# If the model only have dummies, them intercept is the conditional mean of the outcome variable
data("Wages")
fit = lm(lwage ~ sex, data = Wages)
summary(fit)
ggplot(Wages, aes(x = sex, y = lwage, color = sex)) +
  geom_point() +
  geom_hline(aes(yintercept=fit$coefficients[1], color = sex)) +
  geom_hline(aes(yintercept=sum(fit$coefficients), color = sex[2])) +
  geom_hline(aes(yintercept=mean(Wages$lwage)))

# As long as you introduce a continuous variable, the intercept is not as easy to interpret
data("Wages")
fit = lm(lwage ~ sex + ed, data = Wages)
df = cbind(Wages, pred = predict(fit))
ggplot(df, aes(x = ed, y = lwage, color = sex)) +
  geom_jitter() +
  geom_smooth(aes(y=pred), method='lm')


# Data Generating Process
# ======================
# Let's review the hypothesis
# - The explanatory variables are not linearly dependent
# - Explanatory variables are strictly exogenous
# - The data are drawn from a random sample
# - Homoskedasticity
# - error is normally distributed


# Confidence interval
# ===================

CI_mean = function(sample, confidence){
  N = length(sample)
  df = N - 1
  alpha = 1-((1-confidence)/2)
  c  = qt(alpha, df)
  lowerBound = Mean(sample) - c * Stdev(sample) / sqrt(N)
  upperBound = Mean(sample) + c * Stdev(sample) / sqrt(N)
  
  return(c(lowerBound, upperBound))
}