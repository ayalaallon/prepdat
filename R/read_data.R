#' Reads a File in a txt or csv Format that Contains a Table and Creates a Data
#' Frame from it
#'
#' @param file_name A string with the name of the file to be read into R. The
#'   string should include the file extension.
#' @param file_path A string with the path to the folder in which the file to
#'   read is located. Default is \code{NULL}.
#' @param notification Logical. If \code{TRUE}, prints messages about the
#'   progress of the function. Default is \code{TRUE}.
#' @return A data frame of the table specified in \code{file_name}.
read_data <- function(file_name, file_path = NULL, notification = TRUE) {

  ## Error handling
  # Get file_name extension
  extension <- substr(file_name, nchar(file_name) - 3, nchar(file_name))
  # Check if file_path is NULL
  if (is.null(file_path)) {
    # file_path was not provided
    stop("Oops! file_path was not found. Must enter a file_path")
  }
  # Check if file_name exists in file_path
  if (!file.exists(paste(file_path, "/", file_name, sep = ""))) {
    # file_name was not found in file_path
    stop(paste("Oops!", file_name, "was not found in", file_path, ". Please check arguments file_name and file_path"))
  } else if (extension != ".txt" & extension != ".csv") {
    # file_name does not end with txt or csv extension
    stop(paste("Oops!", file_name, "must be in a txt or csv format and be sepcified with the file extension"))
  }

  ## Read the table into R
  if (extension == ".txt") {
    # file_name is in a txt format
    if (notification) {
      # Message
      message(paste("Reading", file_name, "into R"))
      }
      # Return
      return(read.table(file = paste(file_path, "/", file_name, sep = ""),
                        header = TRUE))
  } else if (extension == ".csv") {
    # file_name is in a csv format
    if (notification) {
      # Message
      message(paste("Reading", file_name, "file into R"))
      }
      # Return
      return(read.csv(file = paste(file_path, "/", file_name, sep = ""),
                      header = TRUE, sep = ","))
  }
}  # End of read_data()
