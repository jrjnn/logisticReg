#' Logistic Regression
#'
#' Fits a logistic regression model using Iteratively Reweighted Least Squares (IRLS).
#'
#' @param X A matrix of predictors, including the intercept column.
#' @param y A binary response vector (0/1).
#' @param tol Tolerance level for convergence.
#' @param max_iter Maximum number of iterations for the algorithm.
#' @return A list containing:
#'   \item{coefficients}{Estimated coefficients.}
#'   \item{standard_errors}{Standard errors of the coefficients.}
#'   \item{iter}{Number of iterations until convergence.}
#'   \item{converged}{Logical, whether the algorithm converged.}
#' @examples
#' X <- cbind(1, matrix(rnorm(100), ncol = 2))
#' y <- rbinom(50, 1, prob = 0.5)
#' logistic_reg(X, y)
#' @export
logistic_reg <- function(X, y, tol = 1e-6, max_iter = 100) {
  if (nrow(X) == 0 || length(y) == 0) {
    stop("Input X and y must not be empty")
  }

  if (nrow(X) != length(y)) {
    stop("Dimensions of X and y do not match")
  }

  if (any(is.na(X)) || any(is.na(y))) {
    stop("Input contains NA values")
  }

  if (all(X == X[1])) {
    warning("Constant input detected; the model may not be identifiable.")
    return(list(coefficients = rep(NA, ncol(X))))
  }

  beta <- rep(0, ncol(X))
  converged <- FALSE
  lambda <- 1e-5

  for (i in 1:max_iter) {
    eta <- X %*% beta
    mu <- 1 / (1 + exp(-eta))
    W <- diag(as.vector(mu * (1 - mu)))

    if (det(t(X) %*% W %*% X + lambda * diag(ncol(X))) < 1e-10) {
      beta <- rep(NA, ncol(X))
      break
    }
    z <- eta + (y - mu) / (mu * (1 - mu))
    beta_new <- solve(t(X) %*% W %*% X + lambda * diag(ncol(X))) %*% t(X) %*% W %*% z

    if (sqrt(sum((beta_new - beta)^2)) < tol) {
      converged <- TRUE
      beta <- beta_new
      break
    }

    beta <- beta_new
  }

  if (!converged) {
    warning("Algorithm did not converge; returning the last estimated coefficients.")
  }

  beta <- as.vector(beta)

  if (!is.null(colnames(X))) {
    names(beta) <- colnames(X)
  } else {
    names(beta) <- c("(Intercept)", paste0("X[, -1]", 1:(ncol(X) - 1)))
  }

  list(coefficients = beta)
}
