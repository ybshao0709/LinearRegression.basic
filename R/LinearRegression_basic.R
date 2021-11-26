#'linear_Regression
#'
#'@importFrom stats pf pt qt
#'
#'@import car
#'
#'@param y a column vector, treated as outcome.
#'
#'@param x a numerical matrix, treated as predictor.
#'
#'@param intercept logical, "TRUE" by default. If "TRUE", the model includes the intercept.
#'
#'@param CI.beta logical, "FALSE" by default. If "FALSE", the results will not output the confidence interval of betas.
#'
#'@param CI.level a numeric number specifying the alpha-level when calculate CI.
#'
#'@param partial.T logical, "TRUE" by default. If "TRUE", the results will output the results of partial T-test and corresponding p-values.
#'
#'@param overall.F logical, "TRUE" by default. If "TRUE", the results will output the results of overall F-test and the corresponding p-value.
#'
#'@param r.square logical, "FALSE" by default. If "FALSE", the results will not output the R Square and adjusted R Square.
#'
#'@param Hat.matrix logical, "FALSE" by default. If "FALSE", the hat matrix will not be provided.
#'
#'@param GLH.F logical, "FALSE" by default. If "FALSE", the function will not conduct general linear hypothesis testing.
#'
#'@param contrast.matrix a numerical matrix (or vector) giving linear combinations of coefficients by rows. Only use when "GLH.F = TRUE".
#'
#'@param c.matrix a vector represents the right-hand-side vector for GLH test. Only use when "GLH.F = TRUE".
#'Can be omitted, in which case it defaults to a vector of zeroes.
#'
#'@return A list contains regression results.
#'
#'@examples
#'library(LinearRegression.basic)
#'
#'linear_Regression(c(1, 3, 5, 7, 9), c(2, 3, 5, 8, 11))
#'linear_Regression(state.x77[, 4], state.x77[, c(1:3)])
#'
#'@export
#'

linear_Regression <- function(y, x, intercept = T, CI.beta = F, CI.level = 0.95, partial.T = T, overall.F = T,
                              r.square = F, Hat.matrix = F, GLH.F = F, contrast.matrix = NULL, c.matrix = NULL) {

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
  Esti.beta <- solve(t(x) %*% x) %*% t(x) %*% y
  yhat <- x %*% Esti.beta
  residual <- y - yhat
  MSE <- t(residual) %*% residual / (n - p)

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
    if (intercept == T) {
      ssy <- sum((y - sum(y) / n) ^ 2)
    } else {
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
    if (is.null(c.matrix) == T) {
      k <- nrow(contrast.matrix)
      c.matrix <- rep(0, k)
    }
    c.matrix <- as.matrix(c.matrix)
    contrast.matrix <- as.matrix(contrast.matrix)
    GLH.F.statistics <-
      as.double(((
        t(contrast.matrix %*% Esti.beta - c.matrix) *
          solve(contrast.matrix %*% solve(t(x) %*% x) %*% t(contrast.matrix)) *
          (contrast.matrix %*% Esti.beta - c.matrix)
      ) / nrow(contrast.matrix)) / MSE)
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
