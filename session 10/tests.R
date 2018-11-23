sample = 170 + rnorm(n = 21, mean = 0, sd = 10)

meanHeight = mean(sample)
hist(sample)

# ==========================
# Confidence Interval at 95%
# ==========================

N  = length(sample)
df = N - 1               # Degrees of freedom (here it is N - 1 because we estimate 1 parameter)
c  = qt(0.975, df)       # Critical value

lowerBound = meanHeight - c * sd(sample) / sqrt(N)
upperBound = meanHeight + c * sd(sample) / sqrt(N)

t.test(sample)

# ==================
# Hypothesis testing
# ==================
#
# H0: μ = 167
# H1: μ =/= 167
#
# You have two types of error
# Type 1: Rejecting H0 when H0 is true
# Type 2: We do not reject H0 when in fact H1 is true !
# We want to set the probability α of making type 1 error. (usually, α <= 5%)
#
# Again, we use the T statistics to perform the test.

t_H0 = sqrt(N) * (meanHeight - 167) / sd(sample)
c    = qt(0.975, df)

ifelse(t_H0 > c, "We reject H0 at 5% significance", "We fail to reject H0 at 5% significance")


# ======================
# In my regression model
# ======================
#
# We used hypothesis testing and confidence interval to assess the significance of a "mean" statistic
# But it works exactly the same way in a regression model

library(Ecdat)
data("Housing")

model = lm(log(price) ~ log(lotsize) + stories, data = Housing)
model

# Is the number of stories really relevant ?
# We See that the coefficient is close to 0
# Could we run a test ?
#
# H0: β_stories = 0
# H1: β_stories ≠ 0
#
b_stories = unname(model$coefficients["stories"])                         # Estimated parameter
N         = nrow(Housing)                                                 # Number of observations
model.df  = nrow(Housing) - length(model$coefficients)                    # Degrees of freedom

s2        = sum(model$residuals^2) / model.df                             # Residuals variance estimate
SST       = sum((Housing$stories - mean(Housing$stories))^2)              # Total sum of squares of stories
s_b       = sqrt( s2 / SST ) * N/model.df                                 # standard error estimate of b_stories
t_H0      = (b_stories - 0) / s_b                                         # t-stat

c         = qt(0.975, model.df)                                           # Critical value at 5%

ifelse(t_H0 > c, "We reject H0 at 5% significance", "We fail to reject H0 at 5% significance")

# ======================
# p-values
# ======================
#
# After the above example, one could ask itself "what is the smallest level α such that we reject H0 ?"
# -> You could also ask yourself "What is the largest α such that we fail to reject H0 ?"
# -> Or what is the level α such that t_H0 = critical value
#
# This value is the p-value !
# This is the most popular significance statistic that we use

summary(model)

# =======
# WARNING
# =======
#
# Having a lot of stars in your regression doesn't mean that your model is good.
# It only means that given the DGP you defined, your estimated parameter is not likely to be equal to 0

