# prepdat 1.0.8
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
- `finalized_stroopdata` data frame added:
  - This is the finalized table `prep()` outputs for the example in `prep()`.
- Documentation improved.

# prepdat 1.0.7
- Bugfix: Improved help documents are now available for the users.
  - Description part of the DESCRIPTION file improved.
  - Help section improved for `file_merge()`.
  - Help section improved for `prep()`.
- Version number updated.

# prepdat 1.0.6
- Documentation for `file_merge()` and `prep()` functions improved.
- Description in the DESCRIPTION file improved.
- Version number updated.

# prepdat 1.0.5
- `decimal_places` argument for `prep()` improved. 
- Version number updated

# prepdat 1.0.4

- Bugfix in `file_merge()`: first file in the working directory was read and merged twice instead of once.
- Version number updated.

# prepdat 1.0.3

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

# prepdat 1.0.2

CRAN release

In this version I:
- Changed URL to CRAN URL canonical form https://cran.r-project.org/package=trimr in:
  -  man/hybrid_recursive_mc.Rd
  - man/modified_recursive_mc.Rd
  - man/non_recursive_mc.Rd
  - man/prep.Rd
- Updated version number.

# prepdat 1.0.1

In this version I:
- Added `cran-comments.md` to .Rbuildignore.
- Updated `NAMESPACE` file according to CRAN suggestion in first submission.
- Updated version number.
- Checked URL http://cran.r-project.org/web/packages/trimr/ and found it valid.

# prepdat 1.0.0
Initial release to GitHub
