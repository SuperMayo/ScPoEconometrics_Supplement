library(Ecdat)
library(tidyverse)

#=============
# Chapter 1-2
#=============

# Load Dataframe and add new variables
data("Housing")
df = Housing %>%
  mutate(lprice = log(price),
         size = log(lotsize))

# I want to explore a bit my dataset
str(df)

# The table is useful, don't forget it !
prop.table(table(df$bedrooms)) * 100

# And cross tables
prop.table(table(df$bedrooms, df$stories, dnn=c("bedrooms", "stories"))) * 100

# PLOTS
# =====

# Distribution of prices
ggplot(df, aes(price)) +
  geom_histogram()

# Distribution of lotsize
ggplot(df, aes(lotsize)) +
  geom_histogram()

# Remember that you should use barplots to
# show the distribution of categorical variables
ggplot(df, aes(factor(bedrooms))) +
  geom_bar()

# Remember, you can change color accross a categorical variable
# to show more interesting stuff
ggplot(df, aes(price, fill=factor(stories))) + # I need to use factor() b/c stories is of type `num`
  geom_histogram(bins= 20)

# Don't forget to add a legend
ggplot(df, aes(price, fill=factor(stories))) + # I need to use factor() b/c stories is of type `num`
  geom_histogram(bins= 20) +
  ggtitle('Distribution of house prices in Windsor') +
  scale_x_continuous('Sale price of a house') +
  scale_fill_discrete(name="# Stories")
  
# You can also use boxplot to represent distributions.
# Choosing between histograms and boxplots is really up to you.
# It depends on your data, and on what you want to show.
ggplot(df, aes(x = factor(stories), y = price)) +
  geom_boxplot()

# Of course we also want to show some scatter plots !
ggplot(df, aes(x = lotsize, y = price)) +
  geom_point()

# Don't forget to show multiple dimensions using color !
ggplot(df, aes(x = lotsize, y = price, color = airco)) +
  geom_point()

# An exemple of the group_by + summarize functions
# We want to compute the average price and the average size depending on the house area.
df %>%
  group_by(prefarea) %>%
  summarize(AvgPrice = mean(price),
            AvgSize = mean(lotsize))

#=============
# Chapter 3
#=============

# We now want to know how some variables are related in our dataset
# We define some linear relationship
# log(price_i) = b_0 + b_1*log(lotsize_i) + e_i
# We want to find the "best" parameters b_0 and b_1
# We do so by minimizing the sum of squared residuals (SSR)
ggplot(df, aes(x = log(lotsize), y = log(price))) +
  geom_point()+
  geom_smooth(method=lm, se=FALSE)

# We can show the regression results with lm() & summary()
fit = lm(log(price) ~ log(lotsize), data = df)
summary(fit)

# We can also plot our residuals
ggplot(df, aes(x = log(lotsize), y = residuals(fit))) +
  geom_point()

# By construction, there will be no correlation between the residuals and the prediction
cor(residuals(fit), predict(fit))
plot(residuals(fit), predict(fit))
# ie the OLS takes all the information available in the data

# We also *need* our residuals to be normally distributed
hist(residuals(fit))

#=============
# Chapter 4
#=============
# Let's make some cross plots
plot(df[,c("lprice", "size", "bedrooms", "bathrms", "stories")])

# You can extend the univariate model with multiple regressors
fit = lm(log(price) ~ log(lotsize) + bedrooms + bathrms + stories, data = df)
summary(fit)

# You can try to add some interactions
# maybe having an extra floor increase the price even more for large house ?
fit = lm(log(price) ~ log(lotsize)*stories + bedrooms + bathrms, data = df)
summary(fit)

#=============
# Chapter 5
#=============
# We can add categorical variables
# They will behave as "intercept shifters"
fit =  lm(lprice ~ size + prefarea, data=df)
df_factor = cbind(df, pred = predict(fit))

ggplot(df_factor, aes(x = size, y = lprice, color = prefarea)) +
  geom_point() +
  geom_smooth(aes(y=pred), method='lm')

# We can now estimate a complete model
fit = lm(log(price) ~ log(lotsize) + stories + bedrooms + bathrms + prefarea + driveway + fullbase + airco, data = df)
summary(fit)

# Let's compare our predicted price with the actual price
df_full = cbind(df, pred = predict(fit))
ggplot(df_full, aes(lprice, pred))+
  geom_point() +
  geom_abline()