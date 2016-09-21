# Submission #8
This is submission for prepdat 1.0.8
- `file_merge()` improved:
  - Search of files to be merged is now recursive using `folder_path` argument.
    - Added `raw_file_name` and `raw_file_extension` arguemnts to enable recursive file search.
  - The function does not change the working directory.
  - User provides independent paths for location of files to be merged (`folder_path` argument) and the saved merged table (`dir_save_table` argument).
  - arguments `has_header` and `new_header` added to handle headers.
  - Informative error messages were added.
- `prep()` improved:
  - `file_path` and `results_path` arguemnts added to make file input location and file output location independent.
  - Informative error messages were added.
  - file output can be saved also in csv format.
- Test unit was added using `testthat`
- Documentation improved.
- Updated `NAMESPACE` file according to `devtools::check(document = FALSE)` suggestion.
- Version number updated.

# R CMD Check Results for prepdat 1.0.8
Check was preformed on Mac OS X and Windows operating systems.
Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# Submission #7
This is important submission for prepdat 1.0.7

- Bugfix: Improved help documents are now available for the users:
  - Description part of the DESCRIPTION file improved.
  - Help section improved for `file_merge()`.
  - Help section improved for `prep()`.
- Version number updated.

# R CMD Check Results for prepdat 1.0.7

Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# R CMD Check Results for prepdat 1.0.6

Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# Submission #6
This is submission for prepdat 1.0.6

- Description part of the DESCRIPTION file improved.
- Help section improved for `file_merge()`.
- Help section improved for `prep()`.
- Version number updated.

# R CMD Check Results for prepdat 1.0.6

Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# Submission #5
This is submission for prepdat 1.0.5

- `decimal_places` for `prep()` improved. 
- Version number updated.

# R CMD Check Results for prepdat 1.0.5 

Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# Submission #4
This is submission for prepdat 1.0.4

- Bugfix in `file_merge()`: first file in the working directory was read and merged twice instead of once.
- Version number updated.

# R CMD Check Results for prepdat 1.0.4

Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# Submission #3
This is submission for prepdat 1.0.3

In this version I:

- Exported the following functions:
  - `read_data()`
  - `file_merge()`
  - `non_recursive_mc()`
  - `modified_recursive_mc()`
  - `hybrid_recursive_mc()`
- Updated version number.
- Changed alignment of notifications in `perp()`.
- Summary file for `prep()` improved.

# R CMD Check Results for prepdat 1.0.3

Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# Resubmission #2
This is resubmission for prepdat 1.0.2

In this version I:
- Changed URL to CRAN URL canonical form https://cran.r-project.org/package=trimr in:
  -  man/hybrid_recursive_mc.Rd
  - man/modified_recursive_mc.Rd
  - man/non_recursive_mc.Rd
  - man/prep.Rd
- Updated version number.

# R CMD Check Results for prepdat 1.0.2

Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# Resubmission
This is resubmission for prepdat 1.0.1

In this version I:
- Added `cran-comments.md` to .Rbuildignore.
- Updated `NAMESPACE` file according to CRAN suggestion in first submission.
- Updated version number.
- Checked URL http://cran.r-project.org/web/packages/trimr/ and found it valid.

# R CMD Check Results for prepdat 1.0.1

Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# Test Environments
- local Windows 7 install, R 3.2.1
- local Mac OS X v.10.10.2, R 3.2.1

# R CMD Check Results
Using `devtools::check(document = FALSE)`

There were no ERRORs, WARNINGs, or NOTEs.

# First Submission for prep


