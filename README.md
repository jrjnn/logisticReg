
<!-- README.md is generated from README.Rmd. Please edit that file -->

# logisticReg

<!-- badges: start -->

[![R-CMD-check](https://github.com/jrjnn/logisticReg/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/jrjnn/logisticReg/actions/workflows/R-CMD-check.yml)
<!-- badges: end -->

The `logisticReg` package provides a custom implementation of logistic
regression using Iteratively Reweighted Least Squares (IRLS).

## Installation

You can install the development version from GitHub:

``` r
devtools::install_github("jrjnn/logisticReg")
```

## Example

Here’s an example of using logistic_reg to fit a logistic regression
model:

``` r
library(logisticReg)

set.seed(123)
X <- cbind(1, matrix(rnorm(100), ncol = 2))
y <- rbinom(50, 1, prob = 0.5)

result <- logistic_reg(X, y)
print(result)
#> $coefficients
#> (Intercept)    X[, -1]1    X[, -1]2 
#> -0.01498095  0.38449166  0.01635199
```

Comparison with glm:

``` r
glm_result <- coef(glm(y ~ X[, -1], family = binomial))
print(glm_result)
#> (Intercept)    X[, -1]1    X[, -1]2 
#> -0.01498098  0.38449206  0.01635202
```
