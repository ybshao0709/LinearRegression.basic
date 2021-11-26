test_that("linear_Regression works", {
  coefs <- as.vector(linear_Regression(c(1, 3, 5, 7, 9), c(2, 4, 6, 8, 10))$model.coefs[, 1])
  expect_equal(coefs, c(-1, 1))
})
