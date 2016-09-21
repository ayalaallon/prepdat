# Prepdat: Preparing Experimental Data for Statistical Analysis

## Installation
A stable release of *prepdat* is now available on CRAN https://cran.r-project.org/package=prepdat.
To install *prepdat* use:
```ruby
install.packages("prepdat")
```

To install the latest version of *prepdat* (i.e., the development version of next release), install devtools, and then install directly from GitHub by using:

```ruby
# install devtools
install.packages("devtools")

# install prepdat from GitHub
devtools::install_github("ayalaallon/prepdat")
```
## Overview
*prepdat* is an R package that enables the user to merge files containing data tables in a long format into a single large dataset and go form one single large dataset in a long format to one finalized aggregated table ready for statistical analysis. This pacakge is very useful for merging and aggregating raw data files of individual subjects in an experiment (in which each line corresponds to a single observation in the experiment) to one finalized table in which each line corresponds to the averaged performance
of each subject according to specified dependent and independent variables. *prepdat* also includes several other possibilities
for the aggregated values such as medians of the dependent variable and trimming procedures for reaction-times according to Van
Selst & Jolicoeur (1994). 

## Using prepdat
The two major functions you need to know in order to use *prepdat* are `file_merge()` and `prep()`.
### file_merge()
The `file_merge()` function vertically concatenates files containing data tables in a long format into a single large dataset. In order for the function to work, all files should be in the same format (either txt or csv). This function is very useful for concatenating raw data files of individual subjects in an experiment (in which each line corresponds to a single observation in the experiment) to one raw data file that includes all subjects.

### prep()
After you merged the raw data files using `file_merge()` (or any other function that results in a merged raw data file in a long format), you are ready to continue implementing *prepdat* by using the `prep()` function, which is the main function of *prepdat*.

`prep()` takes the raw data table created in `file_merge()` (or by other functions) and creates one finalized table ready for
statistical analysis. The finalized table contains for each subject (i.e., id) the averaged or aggregated values (e.g., medians) of
several possible dependent variables (e.g., reaction-time and accuracy) according to specified independent variables (i.e., grouping variables), which can be any combination of within-subject (a.k.a repeated measures) and between-subject independent variables. 
The possibilities for dependent measures include:
- mdvc: Mean of the dependent variable.
- sdvc: Standard deviation of the dependent variable.
- meddvc: Median of the dependent variable.
- tdvc: Mean/s of the dependent variable after rejecting observations above standard deviation criteria you specify.
- ntr: Number of observations of the dependent variable that were rejected for each standard deviation criteria.
- ndvc: Number of observations of the dependent variable before rejection.
- ptr: Proportion of observations of the dependent variable that were rejected for each standard deviation criteria.
- rminv: Harmonic mean of the dependent variable.
- prt: Percentiles of the dependent variable according to any percentile (default is 0.05, 0.25, 0.75, 0.95).
- mdvd: Mean of a second dependent variable (e.g., accuracy). 
- merr: error rate (i.e., suitable when the second dependnet variable is accuracy).
- nrmc: Mean according to non-recursive procedure with moving criterion (Van Selst & Jolicoeur, 1994).
- nnrmc: Number of observations of the dependent variable that were rejected for the non-recursive procedure.
- pnrmc: Proportion of observations of the dependent variable that were rejected for the non-recursive procedure.
- tnrmc: Total number of observations upon which the non-recursive procedure was applied.
- mrmc: Mean according to modified-recursive procedure with moving criterion (Van Selst & Jolicoeur, 1994).
- nmrmc: Number of observations of the dependent variable that were rejected for the modified-recursive procedure.
- pmrmc: Proportion of observations of the dependent variable that were rejected for the modified-recursive procedure.
- tmrmc: Total number of observations upon which the modified-recursive procedure was applied.
- hrmc: Mean according to hybrid-recursive procedure with moving criterion (Van Selst & Jolicoeur, 1994).
- nhrmc: Number of observations of the dependent variable that were rejected for the hybrid-recursive procedure.
- thrmc: Total number of observations upon which the hybrid-recursive procedure was applied.

## Example
In the example below, we use `prep()` to go from one table containing data (after already merging the individuals raw data
files) from 15 participants (5400 trials in total) to a finalized table showing all the possibilities for the dependent
variable (e.g., means and medians) for each participant according to specified within-subject and between-subject independent
variables, including the modified recursive procedure of Van Selst & Jolicoeur (1994).

```ruby
# Load prepdat
library(prepdat)

# Load the example data that comes with prepdat
data(stroopdata)

# To get an overview of the example data 
?stroopdata

# Look at the first few lines of the example data
head(stroopdata)
 subject block age gender order font_size trial_num target_type   rt ac
1    5020     1  24      2     1        12         1           1  677  1
2    5020     1  24      2     1        12         2           1  538  1
3    5020     1  24      2     1        12         3           1  507  1
4    5020     1  24      2     1        12         4           1 2818  1
5    5020     1  24      2     1        12         5           1  582  1
6    5020     1  24      2     1        12         6           1  498  1

# Perform prep
finalized_stroopdata <- prep(
           dataset = stroopdata
           , file_name = NULL
           , file_path = NULL
           , id = "subject"
           , within_vars = c("block", "target_type")
           , between_vars = c("order")
           , dvc = "rt"
           , dvd = "ac"
           , keep_trials = NULL
           , drop_vars = c()
           , keep_trials_dvc = "raw_data$rt > 100 & raw_data$rt < 3000 & raw_data$ac == 1"
           , keep_trials_dvd = "raw_data$rt > 100 & raw_data$rt < 3000"
           , id_properties = c()
           , sd_criterion = c(1, 1.5, 2)
           , percentiles = c(0.05, 0.25, 0.75, 0.95)
           , outlier_removal = 2
           , keep_trials_outlier = "raw_data$ac == 1"
           , decimal_places = 0
           , notification = TRUE
           , dm = c()
           , save_results = FALSE
           , results_name = "results.txt"
           , results_path = NULL
           , save_summary = FALSE
         )
   
# Look at finalized_data:
# The hierarchical order for within_vars was first "block" (which has two levels- "1" and "2", and then
# "target_type" (which also has two levels- "1" and "2"). This means that for each of the dependent
# measures we will get four columns. For example mdvc1 is the mean for "block" 1 and "target_type" 2,
# mdvc2 is the mean for "block" 1 and "target_type" 2 etc.
> head(finalized_stroopdata)
     subject order mdvc1 mdvc2 mdvc3 mdvc4 sdvc1 sdvc2 sdvc3 sdvc4 meddvc1
5013    5013     2   863  1038  1081  1103   328   214   417   321     758
5020    5020     1   707   781   637   713   410   362   305   328     586
5021    5021     2   655   742   559   653   162   170   121   144     633
5022    5022     1   604   725   580   650   108   153   128   135     594
5023    5023     2   747   827   909   963   265   200   347   243     726
5024    5024     1   616   793   667   764   125   157   182   180     600
     meddvc2 meddvc3 meddvc4 t1dvc1 t1dvc2 t1dvc3 t1dvc4 t1.5dvc1 t1.5dvc2
5013    1036    1014    1037    777   1047   1033   1065      790     1013
5020     701     540     630    595    699    566    628      595      699
5021     780     540     630    632    760    536    625      630      748
5022     682     565     635    589    692    573    639      599      698
5023     834     821     900    724    825    858    923      718      851
5024     781     629     719    591    776    619    735      585      756
     t1.5dvc3 t1.5dvc4 t2dvc1 t2dvc2 t2dvc3 t2dvc4 n1tr1 n1tr2 n1tr3 n1tr4
5013     1037     1054    809   1006   1001   1067    26     9     6    29
5020      566      626    595    699    566    632    11     2     2    12
5021      558      620    636    732    564    630    40    12     7    34
5022      569      627    602    725    563    638    25    11     5    44
5023      843      914    709    827    864    933    19    11     6    31
5024      619      745    591    756    635    751    30     9     5    21
     n1.5tr1 n1.5tr2 n1.5tr3 n1.5tr4 n2tr1 n2tr2 n2tr3 n2tr4 ndvc1 ndvc2
5013      13       5       4      13     7     2     2     8   144    36
5020      11       2       2      11    11     2     2    10   143    35
5021      18       5       3      12     8     1     2     7   143    34
5022      12       7       2      17     6     0     1     7   143    34
5023       8       6       2      17     5     2     1     8   143    34
5024      15       3       5       7    10     3     2     4   144    35
     ndvc3 ndvc4 p1tr1 p1tr2 p1tr3 p1tr4 p1.5tr1 p1.5tr2 p1.5tr3 p1.5tr4
5013    36   143 0.181 0.250 0.167 0.203   0.090   0.139   0.111   0.091
5020    36   142 0.077 0.057 0.056 0.085   0.077   0.057   0.056   0.077
5021    36   140 0.280 0.353 0.194 0.243   0.126   0.147   0.083   0.086
5022    36   144 0.175 0.324 0.139 0.306   0.084   0.206   0.056   0.118
5023    35   142 0.133 0.324 0.171 0.218   0.056   0.176   0.057   0.120
5024    36   143 0.208 0.257 0.139 0.147   0.104   0.086   0.139   0.049
     p2tr1 p2tr2 p2tr3 p2tr4 rminv1 rminv2 rminv3 rminv4 p0.05dvc1 p0.05dvc2
5013 0.049 0.056 0.056 0.056    777    997    951   1019       539       744
5020 0.077 0.057 0.056 0.070    612    710    575    648       474       532
5021 0.056 0.029 0.056 0.050    617    701    501    626       447       485
5022 0.042 0.000 0.028 0.049    586    694    559    623       498       507
5023 0.035 0.059 0.029 0.056    685    773    823    908       433       482
5024 0.069 0.086 0.056 0.028    596    767    630    732       484       595
     p0.05dvc3 p0.05dvc4 p0.25dvc1 p0.25dvc2 p0.25dvc3 p0.25dvc4 p0.75dvc1
5013       575       704       666       890       858       910       958
5020       454       506       515       639       508       575       684
5021       457       484       552       595       502       550       735
5022       437       461       548       608       528       564       650
5023       549       668       641       722       706       794       820
5024       496       585       536       704       556       658       660
     p0.75dvc2 p0.75dvc3 p0.75dvc4 p0.95dvc1 p0.95dvc2 p0.95dvc3 p0.95dvc4
5013      1150      1182      1245      1463      1440      1780      1649
5020       764       625       702      1857      1198      1035      1568
5021       866       607       699       959       990       744       941
5022       834       610       734       745       971       707       888
5023       953      1027      1096      1035      1140      1405      1439
5024       832       696       838       887      1120      1063      1027
     mdvd1 mdvd2 mdvd3 mdvd4 merr1 merr2 merr3 merr4 mrmc1 mrmc2 mrmc3 mrmc4
5013 1.000 1.000     1 0.993 0.000 0.000     0 0.007   809  1038  1001  1058
5020 1.000 0.972     1 0.986 0.000 0.028     0 0.014   589   699   566   626
5021 1.000 0.944     1 0.972 0.000 0.056     0 0.028   655   742   572   642
5022 0.993 0.944     1 1.000 0.007 0.056     0 0.000   604   725   563   650
5023 1.000 0.944     1 0.986 0.000 0.056     0 0.014   709   827   843   955
5024 1.000 0.972     1 1.000 0.000 0.028     0 0.000   609   777   611   751
     pmrmc1 pmrmc2 pmrmc3 pmrmc4 nmrmc1 nmrmc2 nmrmc3 nmrmc4 tmrmc1 tmrmc2
5013  4.861  0.000  5.556  4.196      7      0      2      6    144     36
5020  9.722  5.714  5.556  7.746     14      2      2     11    144     35
5021  0.000  0.000  2.778  2.143      0      0      1      3    143     34
5022  2.098  0.000  2.778  0.000      3      0      1      0    143     34
5023  4.167  0.000  8.333  0.704      6      0      3      1    144     34
5024  1.389  2.857 11.111  2.083      2      1      4      3    144     35
     tmrmc3 tmrmc4
5013     36    143
5020     36    142
5021     36    140
5022     36    144
5023     36    142
5024     36    144
```

## References
Grange, J.A. (2015). trimr: An implementation of common response time trimming methods. R Package Version 1.0.1. https://cran.r-project.org/package=trimr

Van Selst, M., & Jolicoeur, P. (1994). A solution to the effect of sample size on outlier elimination. *The quarterly journal of
experimental psychology, 47* (3), 631-650.

