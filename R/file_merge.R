#' Vertically Merge Files in a Directory into a Single Large Dataset
#'
#' @description Vertically concatenates files containing data tables in a long
#'   format into a single large dataset. In order for the function to work, all
#'   files you wish to merge should be in the same format (either txt or csv).
#'   This function is very useful for concatenating raw data files
#'   of individual subjects in an experiment (in which each line corresponds to
#'   a single observation in the experiment) to one raw data file that includes
#'   all subjects.
#'
#' @usage   file_merge(
#'            folder_path = NULL
#'            , has_header = TRUE
#'            , new_header = c()
#'            , raw_file_name = NULL
#'            , raw_file_extension = NULL
#'            , file_name = "dataset.txt"
#'            , save_table = TRUE
#'            , dir_save_table = NULL
#'            , notification = TRUE
#'           )
#' @param folder_path A string with the path of the folder in which files to be
#'   merged are searched. Search is recursive (i.e., can search also in
#'   subdirectories). \code{folder_path} must be provided. Default is
#'   \code{NULL}.
#' @param has_header Logical. If \code{TRUE}, the function takes the first line
#'   of the first file found as the header of the merged table. Default is
#'   \code{TRUE}.
#' @param new_header String vector with names for columns of the merged table.
#'   Default is \code{c()}. If used, \code{new_header} should be the same length
#'   as the number of columns in the merged table.
#' @param raw_file_name A string with the name of the files to be searched
#'   and then merged. File extension should NOT be included here (see
#'   \code{raw_file_extension}). \code{raw_file_name} must be provided. Default
#'   is \code{NULL}.
#' @param raw_file_extension A string with the format of the files (i.e.,
#'   \code{csv} or \code{txt}) to be merged. \code{raw_file_extension} must be
#'   provided. Default is \code{NULL}.
#' @param file_name A string with the name of the file of the merged table the
#'   function creates in case \code{save_table} is \code{TRUE}. Extension of the
#'   the file can be txt or csv and should be included. Default is
#'   \code{"dataset.txt"}.
#' @param save_table Logical. If \code{TRUE}, saves the merged table. Default is
#'   \code{TRUE}.
#' @param dir_save_table A string with the path of the folder in which the
#'   merged table is saved in case \code{save_table} is \code{TRUE}. Default is the
#'   path provided in \code{folder_path}.
#' @param notification Logical. If \code{TRUE}, prints messages about the
#'  progress of the function. Default is \code{TRUE}.
#' @return The merged table
file_merge <- function(folder_path = NULL, has_header = TRUE, new_header = c(),
                       raw_file_name = NULL, raw_file_extension = NULL,
                       file_name = "dataset.txt", save_table = TRUE,
                       dir_save_table = NULL, notification = TRUE) {

  ## Error handling
  # Check if folder_path was provided
  if (is.null(folder_path)) {
    stop("Oops! folder_path was not found. Must enter folder_path")
  }
  # Check if has_header is logical
  if (!(has_header %in% c(TRUE, FALSE))) {
    stop("Oops! has_header is not logical. has_header must be logical")
  }
  # Check if user entered both raw_file_name raw_file_extension and let
  # them know if they forgot one of them
  if (!is.null(raw_file_name) & is.null(raw_file_extension)) {
    stop("Oops! raw_file_extension is missing.\nPlease provide raw_file_extension")
  } else if (is.null(raw_file_name) & !is.null(raw_file_extension)) {
    stop("Oops! raw_file_name is missing.\nPlease provide raw_file_name")
  }
  # Check if raw_file_extension is not NULL
  if (!is.null(raw_file_extension)) {
    # Check if raw_file_extension is txt or csv
    if (!(raw_file_extension %in% c("txt", "csv"))) {
      stop("Oops! raw_file_extension is not txt or csv.\nraw_file_extension must be txt or csv")
    }
  }
  # Get file_name extension (also use later when saving the merged table)
  extension <- substr(file_name, nchar(file_name) - 3, nchar(file_name))
  # Check if extention is txt or csv
  if (!(extension %in% c(".txt", ".csv"))) {
    stop(paste("Oops!", file_name, "must include txt or csv extension"))
  }
  ## End of error handling

  # Set dir_save_tabe to folder_path in case dir_save_table path was not used
  if(is.null(dir_save_table)) {
    dir_save_table <- folder_path
  }

  # Make a list of all files in the directory
  if (is.null(raw_file_name) & is.null(raw_file_extension)) {
    # All files to be merged are located in the same folder
    file_list <- list.files(path = folder_path, full.names = TRUE)
  } else if (!is.null(raw_file_name) & !is.null(raw_file_extension)) {
    # Because raw_file_name and raw_file_extension were provided, enable
    # recursive file search according to pattern
    file_list <- list.files(path = folder_path, recursive = TRUE,
                            full.names = TRUE,
                            pattern = paste(raw_file_name, ".*\\.", raw_file_extension, sep = ""))
  }

  ## More error handling
  # In case file_list has 0 files stop the function
  if (length(file_list) == 0) {
    stop("Oops! 0 files were found.\nPlease check folder_path, raw_file_name and raw_file_extension")
  }

  # Message how many files were found in file list
  if (notification) {
    if (length(file_list) == 1) {
      message(paste("Found", length(file_list), "file"))
    } else {
      message(paste("Found", length(file_list), "files"))
    }
  }

  ## More error handling
  # Check if all files end with txt or csv extnsion
  file_type <- c()
  f <- 1
  for (file in file_list) {
    # Get the extension of each file in file_list
    type <- substr(file, nchar(file) - 3, nchar(file))
    if (type != ".txt" & type != ".csv") {
      # Found file that is not in a txt or csv format
      stop(paste("Oops", file, "in folder", basename(dirname(file)), "is not in txt or csv format"))
    }
    file_type[f] <- type
    f <- f + 1
  }
  # Check if all files end with the same extension
  if (".txt" %in% file_type & ".csv" %in% file_type) {
    # Found both txt and csv files
    stop("Oops! both txt and csv files were found.\nAll files to merge be should be in the same format")
  }
  ## End of more error handling

  # Counter for for loop
  i <- 1

  # Merge files vertically
  for (file in file_list) {

    # Get file extension
    extension_f <- substr(file, nchar(file) - 3, nchar(file))

    # Read first file in file_list into dataset
    if (match(file_list[i], file_list) == 1) {
      if (extension_f == ".txt") {
        dataset <- read.table(file = file, header = has_header)
      } else if (extension_f == ".csv") {
        dataset <- read.csv(file = file, header = has_header)
      }
    }

    # Append current file to large dataset if it is not the first file
    if (match(file_list[i], file_list) != 1) {
      # Read current file into temp_dataset
      if (extension_f == ".txt") {
        temp_dataset <- read.table(file = file, header = has_header)
      } else if (extension_f == ".csv") {
        temp_dataset <- read.csv(file = file, header = has_header)
      }
      # Append temp_dataset to dataset
      dataset <- rbind(dataset, temp_dataset)
      # Remove temp_dataset
      rm(temp_dataset)
    }

    # Increase counter
    i <- i + 1
  }  # End of for loop

  # Check if new_header is used or not
  if (length(new_header) > 0) {
    # Check if new_header is in the same length as the number of variables in
    # dataset
    if (length(new_header) != dim(dataset)[2]) {
      stop("Oops! new_header should be the same length as the number of\ncolumns in the files to be merged")
    } else {
      # new_header is in the right length
      if (has_header) {
        # Original data had a header
        if (notification) {
          # Message
          message("Found new_header. Replacing existing header with new_header")
        }
      } else {
        # Add an header according to new_header
        if (notification) {
          # Message
          message("Adding header according to new_header")
        }
      }
    }
    # Replace header in dataset in new_header
    colnames(dataset) <- new_header
  } else if (!has_header) {
    if (notification) {
      # Message
      message(paste("Adding header according to v1:v", dim(dataset)[2], sep = ""))
    }
    # Add colnames v1:vn to dataset
    colnames(dataset) <- paste("v", 1:dim(dataset)[2], sep = "")
  }  # End of if (length(new_header) > 0)

  # Save table in case save_table is set to TRUE
  if (save_table) {
    # Save the table as txt csv
    if (extension == ".txt") {
      # Save table in txt format
      write.table(dataset, file = paste(dir_save_table, "/", file_name, sep = ""),
                  row.names = FALSE)
    } else {
      # Save table as csv format
      write.csv(dataset, file = paste(dir_save_table, "/", file_name, sep = ""),
                quote = FALSE, row.names = FALSE)
    }
    if (notification) {
      # Message
      message(paste(length(file_list), "files were merged and saved into", file_name))
    }
  }  # End of save table

  # Message file_merge() finished
  message("file_merge() finished!")

  # Return
  return(dataset)

}  # End of file_merge
