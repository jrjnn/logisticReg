library(testthat)

test_that("logistic_reg produces correct coefficients", {
  set.seed(123)
  X <- cbind(1, matrix(rnorm(100), ncol = 2))
  y <- rbinom(50, 1, prob = 0.5)

  custom_result <- logistic_reg(X, y)
  glm_result <- coef(glm(y ~ X[, -1], family = binomial))

  expect_equal(custom_result$coefficients, glm_result, tolerance = 1e-4)
})


test_that("logistic_reg handles empty input gracefully", {
  X_empty <- matrix(numeric(0), ncol = 2)
  y_empty <- numeric(0)

  expect_error(logistic_reg(X_empty, y_empty), "Input X and y must not be empty")
})

test_that("logistic_reg handles incorrect dimensions", {
  set.seed(123)
  X <- cbind(1, matrix(rnorm(60), ncol = 3)) # 20 rows
  y <- rbinom(30, 1, prob = 0.5) # Length 30, mismatch

  expect_error(logistic_reg(X, y), "Dimensions of X and y do not match")
})

test_that("logistic_reg handles NA values", {
  set.seed(123)
  X <- cbind(1, matrix(rnorm(100), ncol = 2))
  X[1, 2] <- NA
  y <- rbinom(50, 1, prob = 0.5)

  expect_error(logistic_reg(X, y), "Input contains NA values")
})

test_that("logistic_reg works with imbalanced classes", {
  set.seed(123)
  X <- cbind(1, matrix(rnorm(100), ncol = 2))
  y <- rbinom(50, 1, prob = 0.9) # Class imbalance

  custom_result <- logistic_reg(X, y)
  glm_result <- coef(glm(y ~ X[, -1], family = binomial))

  expect_equal(round(custom_result$coefficients, 4), round(glm_result, 4))
})

test_that("logistic_reg handles large numbers", {
  set.seed(123)
  X <- cbind(1, matrix(rnorm(100) * 1e6, ncol = 2)) # Large values
  y <- rbinom(50, 1, prob = 0.5)

  custom_result <- logistic_reg(X, y)
  glm_result <- coef(glm(y ~ X[, -1], family = binomial))

  expect_equal(round(custom_result$coefficients, 4), round(glm_result, 4))
})
