# Scatter plots

library("tidyverse")

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color= class)) +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color= class)) +
  geom_smooth(method = "lm")

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  facet_wrap(~ class) +
  xlab("Displacement") +
  ylab("Miles per gallon (highway)") +
  ggtitle("Consumption by class, displacement and transmission type") +
  theme_light()

# Boxplot
boxplot(hwy ~ drv, mpg)

ggplot(mpg) +
  geom_boxplot(aes(drv, hwy))

# Histograms
ggplot(mpg) +
  geom_histogram(aes(cty), bins = 12, fill = "#56B4E9", color= "white") +
  theme_light()

# Density 2d
x = rnorm(1000, sd = 2)
y = rnorm(1000)
exampleData = data.frame(var1 = x, var2 = y)
ggplot(exampleData,aes(var1, var2)) +
  geom_density_2d() +
  scale_y_continuous(limits = c(-4, 4)) +
  scale_x_continuous(limits = c(-4, 4))
