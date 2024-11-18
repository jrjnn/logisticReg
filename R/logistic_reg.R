#' Logistic Regression
#'
#' Fits a logistic regression model using Iteratively Reweighted Least Squares (IRLS).
#'
#' @param X A matrix of predictors, including the intercept column.
#' @param y A binary response vector (0/1).
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
logistic_reg <- function(X, y) {
  # Initialization
  beta <- rep(0, ncol(X))
  tol <- 1e-6
  max_iter <- 100
  iter <- 0
  converged <- FALSE

  while (iter < max_iter) {
    iter <- iter + 1
    p <- 1 / (1 + exp(-X %*% beta))
    W <- diag(as.vector(p * (1 - p)))
    z <- X %*% beta + solve(W) %*% (y - p)
    beta_new <- solve(t(X) %*% W %*% X) %*% (t(X) %*% W %*% z)

    if (sqrt(sum((beta_new - beta)^2)) < tol) {
      converged <- TRUE
      break
    }
    beta <- beta_new
  }

  se <- sqrt(diag(solve(t(X) %*% W %*% X)))

  coef_names <- colnames(X)
  if (is.null(coef_names)) {
    coef_names <- c("(Intercept)", paste0("X[, -1]", seq_len(ncol(X) - 1)))
  }

  list(
    coefficients = setNames(as.vector(beta), coef_names),
    standard_errors = se,
    iter = iter,
    converged = converged
  )
}
