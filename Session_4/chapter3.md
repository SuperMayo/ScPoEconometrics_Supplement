The linear model
========================================================
author: Antoine Mayerowitz
date: 2018-10-01
css: /styles/style.css
font-family: 'Helvetica'
autosize: true



About linear regression
========================================================
incremental: true

> Linear regression attempts to model the **relationship** between two (or more) variables by fitting a **linear equation** to observed **data**. One variable is considered to be an **explanatory variable**, and the other is considered to be a **dependent variable**.

If $y$ is our *dependent variable* and $x$ our *explanatory variable*.

- *relationship*:  $y = f(x)$
- *linear equation*:  $y = ax + b$
- *data*:  $y$ and $x$ are empirical data. In fact they are vectors representing our data
- Our goal is to find the **best** parameters $a$ and $b$.

Exemple: data on cars
========================================================
incremental: true

* Suppose we had data on car `speed` and stopping `dist` (ance):


```r
head(cars)
```

```
  speed dist
1     4    2
2     4   10
3     7    4
4     7   22
5     8   16
6     9   10
```

* How are `speed` and `dist` related?

Scatterplot of Cars
===================
incremental: true

<img src="chapter3-figure/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

- What is the best *linear equation* that could describe the data ?

- *ie.* what are the best coefficient $a$ and $b$ in the equation $$y = ax + b$$

The perfect line 
===================
incremental: true

As our model is linear, our equation will look like a line !

<img src="chapter3-figure/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />

Probably not this one. But how to find the perfect line ?

Writing down the problem
========================
incremental: true
We need to re-write our equation to be mathematicaly precise !

- If $y$ and $x$ are two vectors of size $N$ where $(y_i,x_i)_{i\in{1,\ldots,N}}$ are our observations.

- The relationship between the two is described by the following linear equation:
  $$y_i = b_0 + b_1 x_i + \varepsilon_i$$
  
- Where the parameters $b_0$ and $b_1$ are shared accross all observations.

- Where does $\varepsilon_i$ comes from ?

- How can we find the best parameters $b_0$ and $b_1$ to get the best line ?


Prediction and Errors
===============
incremental:true

* We need to denote the *output* of the line.
* We call the value $\widehat{y}_i$ the *predicted value*, after we choose values for $b_0,b_1$.
$$
\widehat{y}_i = b_0 + b_1 x_i
$$
* In general, we **expect** to make errors!
* But we would like to make as little as possible.

App Time!
=========


```r
library(ScPoEconometrics) # load our library
launchApp('reg_simple_arrows')
aboutApp('reg_simple_arrows')
```

Writing Down The Best Line
=============
incremental:true

* choose $(b_0,b_1)$ s.t. the sum $e_1^2 + \dots + e_N^2$ is **as small as possible**
* $e_1^2 + \dots + e_N^2$ is the *sum of squared residuals*, or SSR.
* Wait a moment... Why *squared* residuals?!

Minimizing square of residuals
==============================
incremental:true

* In previous plot, errors of different sign ($+/-$) cancel out!
* Squaring each $e_i$ solves that issue as $e_i^2 \geq 0, \forall i$
* Why don't we minimize the absolute value instead ?
  * It gives the best results when errors are *normally distributed*
  * Mathematically more simple
  * It gives extra penalty to outliers
  * Gives the same result as maximizing the likelihood function.

Best line and squared 
=====================



<img src="chapter3-figure/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" style="display: block; margin: auto;" />

App Time!
=========


```r
launchApp('reg_simple')
aboutApp('reg_simple')
```

Ordinary Least Squares (OLS)
=================
incremental:true

* OLS estimates the best line for us.
* In our single regressor case, there is a simple formula for the slope:
  $$
  b_1 = \frac{cov(x,y)}{var(x)}
  $$
* and for the intercept
  $$
  b_0 = \bar{y} - b_1\bar{x}
  $$
  
App Time!
=========

How does OLS actually perform the minimization problem?


```r
launchApp('SSR_cone')
aboutApp('SSR_cone')  # after
```

App Time!
=========

Let's do some more OLS!


```r
launchApp('reg_full')
aboutApp('reg_full')  # after
```

Common Restrictions on OLS
==========
incremental:true

* There are some common *flavors* of OLS.
* We will go through some of them.
* E.g. what happens without an intercept?
* Or, what happens if we *demean* both $y$ and $x$?

OLS without any Regressor
===============
incremental: true

Not very useful, mainly illustrative.

* Our line is flat at level $b_0$:
  $$
  y = b_0
  $$
* Our optimization problem is now
  $$
  b_0 = \arg\min_{\text{int}} \sum_{i=1}^N \left[y_i - \text{int}\right]^2,
  $$
* With solution
  $$
  b_0 = \frac{1}{N} \sum_{i=1}^N y_i = \overline{y}.
  $$
  
Regression without Intercept
=============
incremental: true

* Now we have a line anchored at the origin.
* The OLS slope estimate becomes
    $$
    \begin{align}
    b_1 &= \arg\min_{\text{slope}} \sum_{i=1}^N \left[y_i - \text{slope } x_i \right]^2\\
    \mapsto b_1 &= \frac{\frac{1}{N}\sum_{i=1}^N x_i y_i}{\frac{1}{N}\sum_{i=1}^N x_i^2} = \frac{\bar{x}     \bar{y}}{\overline{x^2}}
    \end{align}
    $$
    
App: Regressions w/o Slope or Intercept
=========


```r
launchApp('reg_constrained')
```

Centering a Regression
============
incremental: true

* *centering* or *demeaning* means to substract the mean.
* We get $\widetilde{y}_i = y_i - \bar{y}$.
* Let's run a regression *without* intercept as above using $\widetilde{y}_i,\widetilde{x}_i$
* We get
    $$
    \begin{align}
    b_1 &= \frac{\frac{1}{N}\sum_{i=1}^N \widetilde{x}_i \widetilde{y}_i}{\frac{1}{N}\sum_{i=1}^N \widetilde{x}_i^2}\\
        &= \frac{cov(x,y)}{var(x)}
    \end{align}
    $$
    
App: demeaned regression
=========


```r
launchApp('demeaned_reg')
```

Standardizing a Regression
============
incremental: true

* To standardize $z$ means to do $\breve{z}=\frac{z-\bar{z}}{sd(z)}$
* I.e. substract the variable's mean and divide by its standard deviation.
* Proceed as above, but with $\breve{y}_i,\breve{x}_i$
* We get
    $$
    \begin{align}
    b_1 &= \frac{\frac{1}{N}\sum_{i=1}^N \breve{x}_i \breve{y}_i}{\frac{1}{N}\sum_{i=1}^N \breve{x}_i^2}\\
        &= \frac{Cov(x,y)}{\sigma_x \sigma_y}=Corr(x,y)
    \end{align}
    $$

App: Standardized regression
=========


```r
launchApp('reg_standardized')
```

Predictions and Residuals
=====================
incremental: true

1. The error is $e_i = y_i - \widehat{y}_i$
1. The average of $\widehat{y}_i$ is equal to $\bar{y}$.
    $$
    \begin{align}
    \frac{1}{N} \sum_{i=1}^N \widehat{y}_i &= \frac{1}{N} \sum_{i=1}^N (b_0 + b_1 x_i) \\
    &= b_0 + b_1  \bar{x}  = \bar{y}\\
    \end{align}
    $$
1. Then,
    $$\frac{1}{N} \sum_{i=1}^N e_i = \bar{y} - \frac{1}{N} \sum_{i=1}^N \widehat{y}_i = 0$$
    i.e. the average of errors is zero.



Prediction and Errors are Orthogonal
======================================
class: small-code
incremental:true

1. The average of $\widehat{y}_i$ is the same as the mean of $y$.
2. The average of the errors should be zero.
3. Prediction and errors should be *uncorrelated* (i.e. orthogonal).

* Let show it with fake data.

Linear Statistics
=====================
incremental: true

* It's important to keep in mind that Var, Cov, Corr and Regression measure **linear relationships** between two variables.
* Two datasets with *identical* correlations could look *vastly* different.
* They would have the same regression line.
* Same correlation coefficient.
* Is that even possible?

Linear Statistics: Anscombe
=====================
incremental: true

* Francis Anscombe (1973) comes up with 4 datasets with identical stats. But look!

    <img src="chapter3-figure/unnamed-chunk-14-1.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" style="display: block; margin: auto;" />
    
Dinosaurs in your Data?
=====================
incremental: true

* So, be wary of only looking a linear summary stats.
* Also look at plots.
* Dinosaurs?
    
    ```r
    launchApp("datasaurus")
    aboutApp("datasaurus")
    ```


Nonlinear Relationships in Data?
=====================
incremental: true

* We can accomodate non-linear relationships in regressions.
* We'd just add a higher order term like this:
    $$
    y_i = b_0 + b_1 x_i + b_2 x_i^2 + e_i
    $$
* This is *multiple regression* (next chapter!)

Nonlinear Relationships in Data?
=====================
incremental:true

* For example, suppose we had this data and fit the above regression:
    <img src="chapter3-figure/non-line-cars-ols2-1.png" title="Better line with non-linear data!" alt="Better line with non-linear data!" style="display: block; margin: auto;" />


Assessing the Goodness of Fit
=====================
incremental: true

* The $R^2$ measures how good the model fits the data.
* $R^2=1$ is very good, $R^2=0$ is very poorly.
* We compare the performance of our model vs a baseline without regressor:
    $$R^2 = 1 - \frac{\text{SSR our model}}{\text{SSR benchmark}}.$$
* The SSR being a measure of *how large* our errors are, you see that smaller SSR improves our $R^2$.

