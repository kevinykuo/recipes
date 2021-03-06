#' Scaling Numeric Data
#'
#' `step_scale` creates a *specification* of a recipe
#'  step that will normalize numeric data to have a standard
#'  deviation of one.
#'
#' @inheritParams step_center
#' @param ... One or more selector functions to choose which
#'  variables are affected by the step. See [selections()]
#'  for more details. For the `tidy` method, these are not
#'  currently used.
#' @param role Not used by this step since no new variables are
#'  created.
#' @param sds A named numeric vector of standard deviations This
#'  is `NULL` until computed by [prep.recipe()].
#' @param na.rm A logical value indicating whether `NA`
#'  values should be removed when computing the standard deviation.
#' @return An updated version of `recipe` with the new step
#'  added to the sequence of existing steps (if any). For the
#'  `tidy` method, a tibble with columns `terms` (the
#'  selectors or variables selected) and `value` (the
#'  standard deviations).
#' @keywords datagen
#' @concept preprocessing normalization_methods
#' @export
#' @details Scaling data means that the standard deviation of a
#'  variable is divided out of the data. `step_scale` estimates
#'  the variable standard deviations from the data used in the
#'  `training` argument of `prep.recipe`.
#'  `bake.recipe` then applies the scaling to new data sets
#'  using these standard deviations.
#' @examples
#' data(biomass)
#'
#' biomass_tr <- biomass[biomass$dataset == "Training",]
#' biomass_te <- biomass[biomass$dataset == "Testing",]
#'
#' rec <- recipe(HHV ~ carbon + hydrogen + oxygen + nitrogen + sulfur,
#'               data = biomass_tr)
#'
#' scaled_trans <- rec %>%
#'   step_scale(carbon, hydrogen)
#'
#' scaled_obj <- prep(scaled_trans, training = biomass_tr)
#'
#' transformed_te <- bake(scaled_obj, biomass_te)
#'
#' biomass_te[1:10, names(transformed_te)]
#' transformed_te
#' tidy(scaled_trans, number = 1)
#' tidy(scaled_obj, number = 1)
#'
step_scale <-
  function(recipe,
           ...,
           role = NA,
           trained = FALSE,
           sds = NULL,
           na.rm = TRUE) {
    add_step(
      recipe,
      step_scale_new(
        terms = check_ellipses(...),
        role = role,
        trained = trained,
        sds = sds,
        na.rm = na.rm
      )
    )
  }

step_scale_new <-
  function(terms = NULL,
           role = NA,
           trained = FALSE,
           sds = NULL,
           na.rm = NULL) {
    step(
      subclass = "scale",
      terms = terms,
      role = role,
      trained = trained,
      sds = sds,
      na.rm = na.rm
    )
  }

#' @importFrom stats sd
#' @export
prep.step_scale <- function(x, training, info = NULL, ...) {
  col_names <- terms_select(x$terms, info = info)
  sds <-
    vapply(training[, col_names], sd, c(sd = 0), na.rm = x$na.rm)
  step_scale_new(
    terms = x$terms,
    role = x$role,
    trained = TRUE,
    sds,
    na.rm = x$na.rm
  )
}

#' @export
bake.step_scale <- function(object, newdata, ...) {
  res <-
    sweep(as.matrix(newdata[, names(object$sds)]), 2, object$sds, "/")
  if (is.matrix(res) && ncol(res) == 1)
    res <- res[, 1]
  newdata[, names(object$sds)] <- res
  as_tibble(newdata)
}

print.step_scale <-
  function(x, width = max(20, options()$width - 30), ...) {
    cat("Scaling for ", sep = "")
    printer(names(x$sds), x$terms, x$trained, width = width)
    invisible(x)
  }


#' @rdname step_scale
#' @param x A `step_scale` object.
tidy.step_scale <- function(x, ...) {
  if (is_trained(x)) {
    res <- tibble(terms = names(x$sds),
                  value = x$sds)
  } else {
    term_names <- sel2char(x$terms)
    res <- tibble(terms = term_names,
                  value = na_dbl)
  }
  res
}
