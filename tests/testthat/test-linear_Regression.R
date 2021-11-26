test_that("linear_Regression works", {
  coefs <- as.vector(linear_Regression(c(1, 3, 5, 7, 9), c(2, 4, 6, 8, 10))$model.coefs[, 1])
  expect_equal(coefs, c(-1, 1))
})


test_that("linear_Regression works", {
  x <- matrix(c(-1, -2, -3, -4, -5, 1, 3, 5, 7, 9), nrow = 5)
  y <- c(2, 5, 8, 11, 19)
  coefs1 <- as.vector(linear_Regression(y, x, intercept = F)$model.coefs[, 1])
  coefs2 <- as.vector(lm(y ~ -1 + x)$coefficients)
  expect_equal(coefs1, coefs2)
})

test_that("linear_Regression works", {
  x <- matrix(c(-1, -2, -3, -4, -5, 1, 3, 5, 7, 9), nrow = 5)
  y <- c(2, 5, 8, 11, 19)
  coefs1 <- as.vector(linear_Regression(y, x, intercept = F)$model.coefs[, 1])
  coefs2 <- as.vector(lm(y ~ -1 + x)$coefficients)
  expect_equal(coefs1, coefs2)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`
  coefs1 <- as.vector(linear_Regression(y, x)$model.coefs[, 1])
  coefs2 <- as.vector(lm(y ~ x)$coefficients)
  expect_equal(coefs1, coefs2)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`
  lower.bound1 <- as.vector(linear_Regression(y, x, CI.beta = T)$model.coefs[, 3])
  higher.bound1 <- as.vector(linear_Regression(y, x, CI.beta = T)$model.coefs[, 4])
  lower.bound2 <- as.vector(confint(lm(y ~ x))[,1])
  higher.bound2 <- as.vector(confint(lm(y ~ x))[,2])
  expect_equal(lower.bound1, lower.bound2)
  expect_equal(higher.bound1, higher.bound2)
})

test_that("linear_Regression works", {
  x <- as.matrix(state.x77[,c(1:3, 5:8)])
  y <- state.x77$`Life Exp`
  lower.bound1 <- as.vector(linear_Regression(y, x, CI.beta = T, CI.level = 0.99)$model.coefs[, 3])
  higher.bound1 <- as.vector(linear_Regression(y, x, CI.beta = T, CI.level = 0.99)$model.coefs[, 4])
  lower.bound2 <- as.vector(confint(lm(y ~ x), level = 0.99)[,1])
  higher.bound2 <- as.vector(confint(lm(y ~ x), level = 0.99)[,2])
  expect_equal(lower.bound1, lower.bound2)
  expect_equal(higher.bound1, higher.bound2)
})



