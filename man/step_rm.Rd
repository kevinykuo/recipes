% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rm.R
\name{step_rm}
\alias{step_rm}
\alias{tidy.step_rm}
\title{General Variable Filter}
\usage{
step_rm(recipe, ..., role = NA, trained = FALSE, removals = NULL)

\method{tidy}{step_rm}(x, ...)
}
\arguments{
\item{recipe}{A recipe object. The step will be added to the
sequence of operations for this recipe.}

\item{...}{One or more selector functions to choose which
variables that will evaluated by the filtering bake. See
\code{\link[=selections]{selections()}} for more details. For the \code{tidy}
method, these are not currently used.}

\item{role}{Not used by this step since no new variables are
created.}

\item{trained}{A logical to indicate if the quantities for
preprocessing have been estimated.}

\item{removals}{A character string that contains the names of
columns that should be removed. These values are not determined
until \code{\link[=prep.recipe]{prep.recipe()}} is called.}

\item{x}{A \code{step_rm} object.}
}
\value{
An updated version of \code{recipe} with the new step
added to the sequence of existing steps (if any). For the
\code{tidy} method, a tibble with columns \code{terms} which
is the columns that will be removed.
}
\description{
\code{step_rm} creates a \emph{specification} of a recipe step
that will remove variables based on their name, type, or role.
}
\examples{
data(biomass)

biomass_tr <- biomass[biomass$dataset == "Training",]
biomass_te <- biomass[biomass$dataset == "Testing",]

rec <- recipe(HHV ~ carbon + hydrogen + oxygen + nitrogen + sulfur,
              data = biomass_tr)

library(dplyr)
smaller_set <- rec \%>\%
  step_rm(contains("gen"))

smaller_set <- prep(smaller_set, training = biomass_tr)

filtered_te <- bake(smaller_set, biomass_te)
filtered_te

tidy(smaller_set, number = 1)
}
\concept{
preprocessing variable_filters
}
\keyword{datagen}
