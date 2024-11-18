library(testthat)

test_that("logistic_reg produces correct coefficients", {
  set.seed(123)
  X <- cbind(1, matrix(rnorm(100), ncol = 2))
  y <- rbinom(50, 1, prob = 0.5)

  custom_result <- logistic_reg(X, y)
  glm_result <- coef(glm(y ~ X[, -1], family = binomial))

  expect_equal(round(custom_result$coefficients, 4), round(glm_result, 4))
})
