# LinearRegression.basic


### *What is "Linear Regression"?*

[Linear Regression](https://en.wikipedia.org/wiki/Linear_regression) is a widely used statistical method for modelling the relationship between an outcome and one or more predictors. In practice, it can be used for prediction, as well as quantifying the strength of the linearly association between the outcome and the explanatory variables. The most commonly used approach for estimating the unknown parameters in a linear regression model is [ordinary least squares(OLS)](https://en.wikipedia.org/wiki/Ordinary_least_squares). 

### *"lm" function in R*

The existing `stats::lm` in `R` is an powerful function that can help us fit the basic linear regression model. By further applying the `base:summary` function, we can obtain the point estimate, standard error, $t$-statistics and $p$-value of each single $\beta$, and the result from the overall $F$-test. 

However, the `stats::lm` function can not directly output the confidence interval(CI) of one single $\beta$ or the linear conbination of two $\beta$'s(which is often used to test the adjusted effect of a covariate in the presence of interaction terms). 

### *What can "LinearRegression.basic" package do?*

Therefore, we develop an user friendly R package `LinearRegression.basic`, which can be seen as an extension of the existing `stats::lm`function, to make users much easier to obstain , especially in  . The reliability and stability of this package has been fully and seriously tested.


