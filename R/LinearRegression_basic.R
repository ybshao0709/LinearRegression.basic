#'Fitting Linear Regression Model
#'
#'linear_Regression is used to fit linear regression models. It can be used to carry out regression,
#'calculate confidence interval of interested parameters, conduct Partial T Test, Partial F Test and even
#'General Linear Hypothesis test.
#'
#'@importFrom stats pf pt qt
#'
#'@import car ggplot2 bench
#'
#'@param y a column vector, treated as outcome.
#'
#'@param x a numerical matrix, treated as predictor.
#'
#'@param intercept logical, "TRUE" by default.
#'If "FALSE", the model will not include the intercept.
#'
#'@param CI.beta logical, "FALSE" by default.
#'If "TRUE", the results will output the confidence interval of betas.
#'
#'@param CI.level a numeric number specifying the alpha-level when calculate CIs of betas (0.95 by default).
#'Only use when "CI.beta = TRUE"
#'
#'@param partial.T logical, "TRUE" by default.
#'If "FALSE", the results will not output the results of partial T-test and corresponding p-values.
#'
#'@param overall.F logical, "TRUE" by default.
#'If "FALSE", the results will not output the results of overall F-test and the corresponding p-value.
#'
#'@param r.square logical, "FALSE" by default.
#'If "TRUE", the results will output the R Square and adjusted R Square of the fitted model.
#'
#'@param Hat.matrix logical, "FALSE" by default.
#'If "TRUE", the hat matrix will be provided.
#'
#'@param GLH.F logical, "FALSE" by default.
#'If "TRUE", general linear hypothesis testing will be conducted.
#'
#'@param contrast.matrix a numerical matrix (or vector) giving linear combinations of coefficients by rows.
#'Only use when "GLH.F = TRUE".
#'
#'@param c.matrix A vector represents the right-hand-side constant vector for GLH test.
#'It defaults to a vector of zeroes if this argument is omitted.
#'Only use when "GLH.F = TRUE".
#'
#'@return A list contains regression results.
#'
#'@examples
#'  # fit a regression model
#'  linear_Regression(state.x77[, 4], state.x77[, c(1:3)])
#'
#'  x <- matrix(c(-1, -2, -3, -4, -5, 1, 3, 5, 7, 9), nrow = 5)
#'  y <- c(2, 5, 8, 11, 19)
#'  # fit the linear model without an intercept
#'  linear_Regression(y, x, intercept = FALSE)
#'
#'  x <- as.matrix(state.x77[,c(1:3, 5:8)])
#'  y <- state.x77$`Life Exp`
#'  # calculate 99% confidence interval of beta-hat
#'  linear_Regression(y, x, CI.beta = TRUE, CI.level = 0.99)
#'
#'  # conduct GLH testing
#'  contrast.matrix <- matrix(c(0, 1, -1, 0, 0, 0, 0, 0), nrow = 1)
#'  c.matrix <- c(0)
#'  linear_Regression(y, x, contrast.matrix = contrast.matrix, GLH.F = TRUE)
#'
#'@export
#'

linear_Regression <- function(y,
                              x,
                              intercept = T,
                              CI.beta = F,
                              CI.level = 0.95,
                              partial.T = T,
                              overall.F = T,
                              r.square = F,
                              Hat.matrix = F,
                              GLH.F = F,
                              contrast.matrix = NULL,
                              c.matrix = NULL) {


  ## build covariate and outcome matrix
  x <- as.matrix(x)
  y <- as.matrix(y)
  ## find the dimensions of X
  n <- nrow(x)
  p <- ncol(x)

  ## If x matrix doesn't have column names, then give each column a name.
  if (length(colnames(x)) == 0){
    predictor_name <- rep("0", p)
    for (i in 1:p) {
      predictor_name[i] <- c(paste0("predictor_", i, collapse = ""))
    }
    colnames(x) <- predictor_name
  }

  ## Give y a name.
  colnames(y) <- "Outcome"

  ## If the linear model has an intercept
  if (intercept == T) {
    x = cbind(rep(1, n), x)  # add "1" column
    colnames(x)[1] <- "Intercept"
    p = p + 1
  }

  ## Estimation: Beta-hat, Y-hat, residuals
  Esti.beta <- solve(t(x) %*% x) %*% t(x) %*% y  # normal equation
  yhat <- x %*% Esti.beta # by "linear assumption"
  residual <- y - yhat
  MSE <- t(residual) %*% residual / (n - p)  # unbias estimator

  ## Standard errors of Beta-hat
  var_Esti.beta <- c(MSE) * diag(solve(t(x) %*% x))
  se_Esti.beta <- sqrt(var_Esti.beta)

  ## calculate confidence interval of beta-hat (if required)
  if (CI.beta == T){
    t.bound <- qt(p = 1 - (1 - CI.level) / 2, df = (n - p))
    beta.CI.upper <- Esti.beta + t.bound * se_Esti.beta
    beta.CI.lower <- Esti.beta - t.bound * se_Esti.beta
    CI.beta.matrix <- cbind(beta.CI.lower, beta.CI.upper)
    coefs.table <- cbind(Estimate = c(Esti.beta),
                         Std_error = c(se_Esti.beta),
                         CI_lower = c(beta.CI.lower),
                         CI_upper = c(beta.CI.upper))
    colnames(coefs.table)[3] <- paste0(CI.level * 100, "% CI lower")
    colnames(coefs.table)[4] <- paste0(CI.level * 100, "% CI lower")
  } else {
    coefs.table <- cbind(Estimate = c(Esti.beta),
                         Std_error = c(se_Esti.beta))
  }

  output_list <- list(model.coefs = coefs.table)

  ## partial T-test of beta's
  if (partial.T == T) {
    t_statistics <- Esti.beta/se_Esti.beta
    p_value_t <- c(2 * (1 - pt(q = abs(t_statistics), df = n - p)))
    partial_T.test <- cbind(t_statistics = c(t_statistics),
                          p_value = c(p_value_t))
    output_list$partial_T.test <- partial_T.test
  }

  ## calculate R-square and adjusted R-square
  if (r.square == T) {
    if (intercept == T) { # if the model has an intercept
      y.bar <- sum(y) / n
      ssy <- sum((y - y.bar) ^ 2)
    } else {  # if the model has no intercept
      ssy <- sum(y ^ 2)
    }
    sse <- sum(residual ^ 2)
    R_squared <- 1 - sse / ssy
    Adjusted_R_squared <- 1 - (sse / (n - p)) / (ssy / (n - intercept))
    R.squared <- list(R.squared = R_squared, Adjusted.R.squared = Adjusted_R_squared)
    output_list$R_squared <-R.squared
  }

  ## calculate overall F statistics
  if (overall.F == T) {
    df.sse <- n - p
    df.ssr <- p - intercept
    if (r.square == T) {
      overall_F <- (R_squared / (1 - R_squared)) * (df.sse / df.ssr)
    } else {
      if (intercept == T) {
        ssy <- sum((y - sum(y) / n) ^ 2)
      } else {
        ssy <- sum(y ^ 2)
      }
      sse <- sum(residual ^ 2)
      ssr <- ssy - sse
      overall_F <- (ssr / (df.ssr)) / (sse / (df.sse))
    }
    p_value = 1 - pf(overall_F, df.ssr, df.sse)
    overall_F.test <- list(overall_F.statistics = overall_F,
                           p.value = p_value,
                           df.ssr = df.ssr,
                           df.sse = df.sse)
    output_list$overall_F.test <- overall_F.test
  }

  ## calculate hat matrix
  if (Hat.matrix == T) {
    hat.matrix = x %*% solve(t(x) %*% x) %*% t(x)
    output_list$hat.matrix <- hat.matrix
  }

  ## conduct the GLH test
  if (GLH.F == T) {
    if (is.null(c.matrix) == T) {  # if c.matrix is omitted
      k <- nrow(contrast.matrix)
      c.matrix <- rep(0, k)  # 0 vector by default
    }
    c.matrix <- as.matrix(c.matrix)
    contrast.matrix <- as.matrix(contrast.matrix)
    GLH.F.statistics <-
      as.double(((
        t(contrast.matrix %*% Esti.beta - c.matrix) *
          solve(contrast.matrix %*% solve(t(x) %*% x) %*% t(contrast.matrix)) *
          (contrast.matrix %*% Esti.beta - c.matrix)
      ) / nrow(contrast.matrix)) / MSE)  # calculate F statistics
    GLH.dfr <- nrow(contrast.matrix)
    GLH.dfe <- n - p
    p_value <- 1 - pf(GLH.F.statistics, GLH.dfr, GLH.dfe)
    GLH.test <- list(GLH.F.statistics = GLH.F.statistics,
                     p.value = p_value,
                     dfr = GLH.dfr,
                     dfe = GLH.dfe)
    output_list$GLH.test <- GLH.test
  }
  return(output_list)
}
