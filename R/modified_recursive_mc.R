#' Modified-recursive Outlier Removal Procedure with Moving Criterion 
#'
#' @description Modified-recursive outlier removal procedure with moving criterion according to Van Selst & Jolicoeur (1994).
#' @param exp_cell Numeric vector on which the outlier removal method takes place.
#' @references Grange, J.A. (2015). trimr: An implementation of common response time trimming methods. R Package Version 1.0.0. \url{http://cran.r-project.org/web/packages/trimr/}
#' 
#' Selst, M. V., & Jolicoeur, P. (1994). A solution to the effect of sample size on outlier elimination. \emph{The quarterly journal of experimental psychology, 47}(3), 631-650.
#' @return Mean of \code{exp_cell} after removing outliers.
modified_recursive_mc <- function(exp_cell) {
  
  # Load creiterion cutoffs according to Table 4 in vanSelst & Jolicoeur (1994)
  data(linear_interpolation) 
  
  # Total number of trials before getting into the loop
  total_trials <- length(exp_cell)
  # Number of trials removed
  num_removed <- 0
  
  # Recursion loop
  repeat {
    
    # Get sample size of data
    sample_size <- length(exp_cell)

    # The data needs to have more than 2 observations in order to function
    if(sample_size <= 2){
      break
    }
    
    # If sample is greater than 100, use SDs for 100.
    if (sample_size > 100) {sample_size <- 100}
    
    # Look up sample size in the table and find the required standard deviation
    # this looks in the "modified_recursive" column
    cutoff <- linear_interpolation$modified_recursive[sample_size]
    
    ## Now do the removal of trials
    # Find the largest value in the data structure
    x <- max(exp_cell)
    # Temporarily remove largest value
    temp_data <- exp_cell[exp_cell != x]
    # Calculate SD of temporary data according to denominator n
    sd_temp_data <- sd(temp_data) * sqrt((length(temp_data) - 1) / (length(temp_data))) 
    # Find max SDs
    sd_max <- sd_temp_data * cutoff 
    # Find maximum cutoff value of main data
    maxcutoff <- sd_max + mean(temp_data) 
    # Find minimum cutoff value of main data
    mincutoff <- mean(temp_data) - sd_max 
    
    # From here we are using the main data (i.e. temporary removal above has been replaced)
    # Find the largest value in the main data structure
    x <- max(exp_cell)
    # Find the smallest value in the main data structure
    y <- min(exp_cell)
    
    # Reset before looping. This will store how many trials have
    # been removed on each recursion. The loop stops when no trials have been removed on 
    # a particular iteration
    removed_trials <- 0    
    # If there is a data point above the cutoff, remove it
    #print(maxcutoff)
    if(x > maxcutoff) {
      exp_cell <- exp_cell[exp_cell != x]
      removed_trials <- 1
      num_removed <- num_removed + 1
    } 
    
    # If there is a data point below the cutoff, remove it
    if(y < mincutoff) {
      exp_cell <- exp_cell[exp_cell != y]
      removed_trials <- 1
      num_removed <- num_removed + 1
    }
    
    # When there are no trials removed on the current iteration, break the loop
    if (removed_trials == 0) {break}   
    
    # Alternatively, stop the loop when the restricted data size hits 4
    # (as in vanSelst & Jolicoeur, 1994)
    if (length(exp_cell) < 5) {break}
  }  # End of repeat
  
  # Now compute the means of the final restricted sample
  final_data <- mean(exp_cell)
  # Percent removed
  percent_removed <- 100 - (length(exp_cell) / total_trials * 100)
  # Return
  return_data <- c(final_data, percent_removed, num_removed, total_trials) 
  return(return_data)
}