# LinearRegression.basic



### *What is "Linear Regression"?*

[Linear Regression](https://en.wikipedia.org/wiki/Linear_regression) is a widely used statistical method for modelling the relationship between an outcome and one or more predictors. In parctical, it can be used for prediction, as well as quantifying the strength of the linearly association between the outcome and the explanatory variables. The most commonly used approach for estimating the unknown parameters in a linear regression model is [ordinary least squares (OLS)] (https://en.wikipedia.org/wiki/Ordinary_least_squares). 


The existing `stats::lm` in `R` is an powerful function that can help us fit the basic linear regression model. By using the `base:summary` function, we can further obtain the point estimate, standard error, $t$-statistics and $p$-value of each $\beta$, and the result from the overall $F$-test. However, it's not easy for us to directly  , especially when we want to conduct a sequential $F$-test to examine whether some categorical variables may or may not have a linear relationship with the response, the existing `stats::lm` function is not user friend.

Therefore, we develop an user friendly R package `LinearRegression.basic`, which can be used . The reliability and stability of this package has been fully and seriously tested.


