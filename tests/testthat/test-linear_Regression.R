test_that("linear_Regression works", {
  coefs.actual <- as.vector(linear_Regression(c(1, 3, 5, 7, 9), c(2, 4, 6, 8, 10))$model.coefs[, 1])
  expect_equal(coefs.actual, c(-1, 1))
})


test_that("linear_Regression works", {
  x <- matrix(c(-1, -2, -3, -4, -5, 1, 3, 5, 7, 9), nrow = 5)
  y <- c(2, 5, 8, 11, 19)
  coefs.actual <- as.vector(linear_Regression(y, x, intercept = F)$model.coefs[, 1])
  coefs.expected <- as.vector(lm(y ~ -1 + x)$coefficients)
  expect_equal(coefs.actual, coefs.expected)
})

test_that("linear_Regression works", {
  x <- matrix(c(-1, -2, -3, -4, -5, 1, 3, 5, 7, 9), nrow = 5)
  y <- c(2, 5, 8, 11, 19)
  coefs.actual <- as.vector(linear_Regression(y, x, intercept = F)$model.coefs[, 1])
  coefs.expected <- as.vector(lm(y ~ -1 + x)$coefficients)
  expect_equal(coefs.actual, coefs.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`
  coefs.actual <- as.vector(linear_Regression(y, x)$model.coefs[, 1])
  coefs.expected <- as.vector(lm(y ~ x)$coefficients)
  expect_equal(coefs.actual, coefs.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`

  t.stat.actual <- as.vector(linear_Regression(y, x, partial.T = T)$partial_T.test[, 1])
  t.stat.expected <- as.vector(summary(lm(y ~ x))$coefficients[, 3])

  p.actual <- as.vector(linear_Regression(y, x, partial.T = T)$partial_T.test[, 2])
  p.expected <- as.vector(summary(lm(y ~ x))$coefficients[, 4])

  expect_equal(t.stat.actual, t.stat.expected)
  expect_equal(p.actual, p.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`

  lower.bound.actual <- as.vector(linear_Regression(y, x, CI.beta = T)$model.coefs[, 3])
  higher.bound.actual <- as.vector(linear_Regression(y, x, CI.beta = T)$model.coefs[, 4])

  lower.bound.expected <- as.vector(confint(lm(y ~ x))[,1])
  higher.bound.expected <- as.vector(confint(lm(y ~ x))[,2])

  expect_equal(lower.bound.actual, lower.bound.expected)
  expect_equal(higher.bound.actual, higher.bound.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`

  lower.bound.actual <- as.vector(linear_Regression(y, x, CI.beta = T, CI.level = 0.99)$model.coefs[, 3])
  higher.bound.actual <- as.vector(linear_Regression(y, x, CI.beta = T, CI.level = 0.99)$model.coefs[, 4])

  lower.bound.expected <- as.vector(confint(lm(y ~ x), level = 0.99)[,1])
  higher.bound.expected <- as.vector(confint(lm(y ~ x), level = 0.99)[,2])

  expect_equal(lower.bound.actual, lower.bound.expected)
  expect_equal(higher.bound.actual, higher.bound.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`

  overall.F.stat.actual <- as.vector(linear_Regression(y, x, overall.F = T)$overall_F.test$overall_F.statistics)
  overall.F.dfr.actual <- as.vector(linear_Regression(y, x, overall.F = T)$overall_F.test$df.ssr)
  overall.F.dfe.actual <- as.vector(linear_Regression(y, x, overall.F = T)$overall_F.test$df.sse)

  overall.F.stat.expected <- as.vector(summary(lm(y ~ x))$fstatistic[1])
  overall.F.dfr.expected <- as.vector(summary(lm(y ~ x))$fstatistic[2])
  overall.F.dfe.expected <- as.vector(summary(lm(y ~ x))$fstatistic[3])

  expect_equal(overall.F.stat.actual, overall.F.stat.expected)
  expect_equal(overall.F.dfr.actual, overall.F.dfr.expected)
  expect_equal(overall.F.dfe.actual, overall.F.dfe.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`

  R.squared.actual <- as.vector(linear_Regression(y, x, r.square = T)$R_squared$R.squared)
  Adjusted.R.squared.actual <- as.vector(linear_Regression(y, x, r.square = T)$R_squared$Adjusted.R.squared)

  R.squared.expected <- as.vector(summary(lm(y ~ x))$r.squared)
  Adjusted.R.expected <- as.vector(summary(lm(y ~ x))$adj.r.squared)

  expect_equal(R.squared.actual, R.squared.expected)
  expect_equal(Adjusted.R.squared.actual, Adjusted.R.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`

  R.squared.actual <- as.vector(linear_Regression(y, x, intercept = F, r.square = T)$R_squared$R.squared)
  Adjusted.R.squared.actual <- as.vector(linear_Regression(y, x, intercept = F, r.square = T)$R_squared$Adjusted.R.squared)
  overall.F.stat.actual <- as.vector(linear_Regression(y, x, intercept = F, r.square = T)$overall_F.test$overall_F.statistics)

  R.squared.expected <- as.vector(summary(lm(y ~ -1 + x))$r.squared)
  Adjusted.R.expected <- as.vector(summary(lm(y ~ -1 + x))$adj.r.squared)
  overall.F.stat.expected <- as.vector(summary(lm(y ~ -1 + x))$fstatistic[1])

  expect_equal(R.squared.actual, R.squared.expected)
  expect_equal(Adjusted.R.squared.actual, Adjusted.R.expected)
  expect_equal(overall.F.stat.actual, overall.F.stat.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`
  hat.matrix.diag.actual <- as.vector(diag(linear_Regression(y, x, Hat.matrix = T)$hat.matrix))
  hat.matrix.diag.expected <- as.vector(influence(lm(y ~ x))$hat)
  expect_equal(hat.matrix.diag.actual, hat.matrix.diag.expected)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`
  contrast.matrix <- matrix(c(0, 1, -1, 0, 0, 0, 0, 0), nrow = 1)
  c.matrix <- c(0)
  GLH.F.statistics.actual <- as.vector(linear_Regression(y, x, contrast.matrix = contrast.matrix, GLH.F = T)$GLH.test$GLH.F.statistics)
  GLH.p.actual <- as.vector(linear_Regression(y, x, contrast.matrix = contrast.matrix, GLH.F = T)$GLH.test$p.value)
  GLH.dfr.actual <- as.vector(linear_Regression(y, x, contrast.matrix = contrast.matrix, GLH.F = T)$GLH.test$dfr)
  GLH.dfe.actual <- as.vector(linear_Regression(y, x, contrast.matrix = contrast.matrix, GLH.F = T)$GLH.test$dfe)

  GLH.F.statistics.expected <- as.vector(car::linearHypothesis(model = lm(y ~ x), hypothesis.matrix = contrast.matrix, rhs = c.matrix)$F[2])
  GLH.p.expected <- as.vector(car::linearHypothesis(model = lm(y ~ x), hypothesis.matrix = contrast.matrix, rhs = c.matrix)$`Pr(>F)`[2])
  GLH.dfr.expected <- as.vector(car::linearHypothesis(model = lm(y ~ x), hypothesis.matrix = contrast.matrix, rhs = c.matrix)$Df[2])
  GLH.dfe.expected <- as.vector(car::linearHypothesis(model = lm(y ~ x), hypothesis.matrix = contrast.matrix, rhs = c.matrix)$Res.Df[2])

  expect_equal(GLH.F.statistics.actual, GLH.F.statistics.expected)
  expect_equal(GLH.p.actual, GLH.p.expected)
  expect_equal(GLH.dfr.actual, GLH.dfr.expected)
  expect_equal(GLH.dfe.actual, GLH.dfe.expected)

})
