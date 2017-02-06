#' Square Root Transformation
#' 
#' \code{step_sqrt} creates a \emph{specification} of a recipe step that will square root transform the data. 
#' 
#' @inheritParams step_center
#' @param terms A representation of the variables or terms that will be transformed.
#' @param role Not used by this step since no new variables are created. 
#' @param vars A character string of variable names that will be (eventually) populated by the \code{terms} argument.
#' @return \code{step_sqrt} and \code{learn.step_sqrt} return objects of class \code{step_sqrt}.
#' @keywords datagen
#' @concept preprocessing transformation_methods
#' @export
#' 
step_sqrt <- function(recipe, terms, role = NA, trained = FALSE, vars = NULL) {
  add_step(
    recipe, 
    step_sqrt_new(
      terms = terms, 
      role = role,
      trained = trained,
      vars = vars
    )
  )
}

step_sqrt_new <- function(terms = NULL, role = NA, trained = FALSE, vars = NULL) {
  step(
    subclass = "sqrt", 
    terms = terms,
    role = role,
    trained = trained,
    vars = vars
  )
}

#' For a training set of data, \code{learn.step_sqrt} configures the square root transformation (by basically doing nothing). This function is \emph{not} intended to be directly called by the user. 
#' 
#' @param x a \code{step_sqrt} object that specifies which columns will be transformed
#' @inheritParams learn.step_center
#' @export
#' @importFrom stats optimize
#' @rdname step_sqrt

learn.step_sqrt <- function(x, training, info = NULL, ...) {
  col_names <- parse_terms_formula(x$terms, info = info) 
  step_sqrt_new(
    terms = x$terms, 
    role = x$role,
    trained = TRUE,
    vars = col_names
  )
}

#' \code{process.step_sqrt} is used to transform columns on specific data sets. This replaces values in the original columns. This function is \emph{not} intended to be directly called by the user. 
#' 
#' @inheritParams process.step_center
#' @param newdata A tibble or data frame that has numeric variables that will be transformed
#' @return \code{process.step_sqrt} returns a tibble of processed data. 
#' @export
#' @importFrom tibble as_tibble
#' @rdname step_sqrt

process.step_sqrt <- function(object, newdata, ...) {
  col_names <- object$vars
  for(i in seq_along(col_names))
    newdata[ , col_names[i] ] <- sqrt(newdata[ , col_names[i] ])
  as_tibble(newdata)
}

#' @export
print.step_sqrt <- function(x, form_width = 30, ...) {
  cat("Square root transformation on ")
  cat(form_printer(x, wdth = form_width))
  if(x$trained) cat(" [trained]\n") else cat("\n")
  invisible(x)
}