# LinearRegression.basic

  <!-- badges: start -->
  [![R-CMD-check](https://github.com/ybshao0709/LinearRegression.basic/workflows/R-CMD-check/badge.svg)](https://github.com/ybshao0709/LinearRegression.basic/actions)
  <!-- badges: end -->
  
  [![codecov](https://codecov.io/gh/ybshao0709/LinearRegression.basic/branch/main/graph/badge.svg)](https://codecov.io/gh/ybshao0709/LinearRegression.basic)


### *1.What is "Linear Regression"?*

[Linear Regression](https://en.wikipedia.org/wiki/Linear_regression) is a widely used statistical method for modelling the relationship between an outcome and one or more predictors. In practice, it can be used for prediction, as well as quantifying the strength of the linearly association between the outcome and the explanatory variables. The most commonly used approach for estimating the unknown parameters in a linear regression model is [ordinary least squares(OLS)](https://en.wikipedia.org/wiki/Ordinary_least_squares). 

### *2."lm" function in R*

The existing `stats::lm` in `R` is an powerful function that can help us fit the basic linear regression model. By further applying the `base:summary` function, we can obtain the point estimate, standard error, $t$-statistics and $p$-value of each single $\beta$, and the result from the overall $F$-test. 

However, the `stats::lm` function can not directly output the confidence interval(CI) of $\hat{\beta}$. Moreover, as one of the most important matrices derived from linear regression model, hat matrix contains many important information (especially when we want to deal with some residual-related problems), but unfortunately the `stats::lm` function doesn't provide it directly. 

Therefore, we develop an user-friendly R package `LinearRegression.basic`, which can be seen as an extension of the existing `stats::lm`function. The reliability and stability of this package has been fully and seriously tested.

### *3.What can "LinearRegression.basic" package do?*

* Fit a linear regression model with or without an intercept.
* Obtain the point estimates and standard errors of $\beta$'s.
* Obtain the confidence interval of $\hat{\beta}$'s.
* Obtain the $t$-statistics from partial $t$-test, and the corresponding $p$-value.
* Obtain the $F$-statistics from partial $F$-test, and the corresponding $p$-value.
* Obtain the $R^2$ and adjusted-$R^2$.
* Obtain the $hat$-matrix.


---

Use the following code to find more details about the "LinearRegression.basic" package:

`browseVignettes("LinearRegression.basic")`
