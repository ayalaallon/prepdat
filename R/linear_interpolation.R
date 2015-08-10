#' Criterion cutoffs for the non-recursive and modified recursive outlier removal procedures with moving criterion
#' according to procedures described by Van Selst & Jolicoeur (1994), Table 4, page 642. 
#'
#' A table containing criterion cutoffs for non-recursive and modified recursive outlier removal procedures with
#' moving criterion according to sample size.
#' 
#' @usage \code{data(linear_interpolation)}
#'
#' @format A data frame with 101 rows and 3 columns:
#' \describe{
#'   \item{\code{sample_size}}{sample size, in numerals}
#'   \item{\code{non_recursive}}{criterion cutoffs for non-recursive with moving criterion procedure}
#'   \item{\code{modified_recursive}}{criterion cutoffs for modified recursive with moving criterion procedure}
#' }
#' 
#' @references Grange, J.A. (2015). trimr: An implementation of common response time trimming methods. R Package Version 1.0.0. \url{http://cran.r-project.org/web/packages/trimr/}
#' 
#' Selst, M. V., & Jolicoeur, P. (1994). A solution to the effect of sample size on outlier eliminatio
#' \emph{The quarterly journal of experimental psychology, 47}(3), 631-650.
#' 
"linear_interpolation"
