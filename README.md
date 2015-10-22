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
devools::install_github("ayalaallon/prepdat")`
```
## Overview
*prepdat* is an R package that integrates raw data files collected from individual participants (usually from a psychological
experiment), enabling the user to go from raw data files, in which each line corresponds to one trial conducted during the
experiment, to one finalized table ready for statistical analysis, in which each line corresponds to the averaged performance
of each participant according to specified dependent and independent variables. *prepdat* also includes several other possibilities
for the aggregated values such as medians of the dependent variable and trimming procedures for reaction-times according to Van
Selst & Jolicoeur (1994).
## Using prepdat
The two major functions you need to know in order to use *prepdat* are `file_merge()` and `prep()`.
### file_merge()
The `file_merge()` function concatenates raw data files of individual participants (in which each line corresponds to a single trial in the experiment) to one raw data file that includes all participants. In order for the function to work, all raw data files you wish to merge should be put in one folder containing nothing but the raw data files. In addition, the working directory should be set to that folder. All raw data files should be in the same format (either txt or csv). 
### prep()
After you merged the raw data files using `file_merge()`, or any other function (for example using Eprime mergedat), you are ready
to continue implementing *prepdat* by using the `prep()` function, which is the main function of *prepdat*.

`prep()` takes the raw data table created in `file_merge()` (or by other functions) and creates one finalized table ready for
statistical analysis. The finalized table contains for each participant the averaged or aggregated values (e.g., medians) of
several possible dependent variables (e.g., reaction-time and accuracy) according to specified independent variables, which can be
any combination of within-subject (a.k.a repeated measures) and between-subject independent variables. 
The possibilities for dependent measures include:
- mdvc: Mean of the dependent variable.
- sdvc: Standard deviation of the dependent variable.
- meddvc: Median of the dependent variable.
- tdvc: Mean/s of the dependent variable after rejecting observations above standard deviation criterion/s you specify.
- ntr: Number of observations of the dependent variable that were rejected for each standard deviation criterion/s.
- ndvc: Number of observations of the dependent variable before rejection.
- ptr: Proportion of observations of the dependent variable that were rejected for each standard deviation criterion/s.
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
finalized_data <- prep(
      dataset = stroopdata  # Name of the merged raw data table in case you already loaded it into R.
      , file_name = NULL  # Name of the file that contains the raw data after merging the individual
                          # raw data files.
      , id = "subject"  # Name of the column that contains the variable specifying the case identifier.
      , within_vars = c("block", "target_type")  # Name of column or columns that contain independent
                                                 # within-subject variables.
      , between_vars = c("order")  # Name of column or columns that contain independent between-subject
                                   # variables.
      , dvc = "rt"  # Name of the column that contains the continuous dependent variable (e.g.,
                    # reaction-time). 
      , dvd = "ac"  # Name of the column that contains the discrete dependent variable (e.g., 0
                    # and 1 for accuracy measures).
      , keep_trials = NULL
      , drop_vars = c()
      , keep_trials_dvc = "raw_data$rt > 100 & raw_data$rt < 3000 & raw_data$ac == 1"  # Keep for
                                                                                       # dvc only
                                                                                       # trials that
                                                                                       # meet these
                                                                                       # conditions. 
      , keep_trials_dvd = "raw_data$rt > 100 & raw_data$rt < 3000"  # Keep for dvd only trials that
                                                                    # meet these conditions.
      , id_properties = c()
      , sd_criterion = c(1, 1.5, 2)  # Criterions to reject all observations above standard deviations
                                     # specified here and then calculate means.
      , percentiles = c(0.05, 0.25, 0.75, 0.95)  # Percentiles of dvc (any percentile is possible).
      , outlier_removal = 2  # Perform modified recursive procedure with moving criterion.
      , keep_trials_outlier = "raw_data$ac == 1"  # Keep for outlier removal procedure only trials
                                                  # that meet this condition.
      , decimal_places = 4
      , notification = TRUE
      , dm = c()  # See ?prep for more details on this argument.
      , save_results = TRUE  # Create a txt file containing the finalized table.
      , results_name = "results.txt"  # Name of the file that contains the finalized table.
      , save_summary = TRUE  # Save a summary txt file with the important parameters of prep().
   )
   
# Look at finalized_data:
# The hierarchical order for within_vars was first "block" (which has two levels- "1" and "2", and then
# "target_type" (which also has two levels- "1" and "2"). This means that for each of the dependent
# measures we will get four columns. For example mdvc1 is the mean for "block" 1 and "target_type" 2,
# mdvc2 is the mean for "block" 2 and "target_type" 1 etc.
head(finalized_data)
    subject order    mdvc1     mdvc2     mdvc3     mdvc4    sdvc1    sdvc2    sdvc3
5013    5013     2 863.1736 1038.4444 1081.0000 1103.1189 328.2833 214.1703 417.1448
5020    5020     1 706.8741  781.1429  636.8056  712.9437 410.1729 361.9275 304.8082
5021    5021     2 655.0280  742.0294  558.8611  652.5714 161.7873 170.3273 120.8668
5022    5022     1 604.4266  725.2941  580.1944  650.1250 107.9061 153.0384 127.7895
5023    5023     2 747.0979  827.4706  908.6571  962.7183 265.1188 200.0777 347.3918
5024    5024     1 615.9722  793.1714  667.2778  764.1259 124.6003 156.6617 182.2824
        sdvc4 meddvc1 meddvc2 meddvc3 meddvc4   t1dvc1    t1dvc2    t1dvc3    t1dvc4
5013 321.4880   758.5  1036.5  1014.0  1037.0 776.8220 1046.7037 1033.0333 1065.1316
5020 328.2770   586.0   701.0   540.0   629.5 595.3409  699.3636  566.5000  628.3538
5021 144.2790   633.0   780.0   540.5   629.5 631.6408  760.3636  535.5172  625.0849
5022 135.0557   594.0   681.5   565.0   635.0 589.2881  691.9565  573.2903  638.7900
5023 243.0594   726.0   834.0   821.0   900.5 724.3952  824.6087  857.9655  923.2973
5024 180.0681   600.0   781.0   629.0   719.0 591.3860  775.7308  618.9677  734.5574
     t1.5dvc1  t1.5dvc2  t1.5dvc3  t1.5dvc4   t2dvc1    t2dvc2    t2dvc3    t2dvc4
5013 790.0763 1012.8387 1037.0000 1053.9538 809.4818 1005.5000 1001.1176 1067.4148
5020 595.3409  699.3636  566.5000  626.4351 595.3409  699.3636  566.5000  631.6818
5021 629.5040  748.2069  558.3030  619.6953 635.9926  731.6667  564.0882  630.3759
5022 599.3893  697.6296  569.4706  626.8425 602.2774  725.2941  562.9143  637.9854
5023 718.3630  851.2143  842.6970  914.1520 709.2174  827.2188  864.4118  933.3881
5024 584.9612  755.8750  618.9677  744.6397 590.5597  755.8750  634.5882  750.9568
     n1tr1 n1tr2 n1tr3 n1tr4 n1.5tr1 n1.5tr2 n1.5tr3 n1.5tr4 n2tr1 n2tr2 n2tr3 n2tr4
5013    26     9     6    29      13       5       4      13     7     2     2     8
5020    11     2     2    12      11       2       2      11    11     2     2    10
5021    40    12     7    34      18       5       3      12     8     1     2     7
5022    25    11     5    44      12       7       2      17     6     0     1     7
5023    19    11     6    31       8       6       2      17     5     2     1     8
5024    30     9     5    21      15       3       5       7    10     3     2     4
     ndvc1 ndvc2 ndvc3 ndvc4  p1tr1  p1tr2  p1tr3  p1tr4 p1.5tr1 p1.5tr2 p1.5tr3
5013   144    36    36   143 0.1806 0.2500 0.1667 0.2028  0.0903  0.1389  0.1111
5020   143    35    36   142 0.0769 0.0571 0.0556 0.0845  0.0769  0.0571  0.0556
5021   143    34    36   140 0.2797 0.3529 0.1944 0.2429  0.1259  0.1471  0.0833
5022   143    34    36   144 0.1748 0.3235 0.1389 0.3056  0.0839  0.2059  0.0556
5023   143    34    35   142 0.1329 0.3235 0.1714 0.2183  0.0559  0.1765  0.0571
5024   144    35    36   143 0.2083 0.2571 0.1389 0.1469  0.1042  0.0857  0.1389
     p1.5tr4  p2tr1  p2tr2  p2tr3  p2tr4   rminv1   rminv2   rminv3    rminv4
5013  0.0909 0.0486 0.0556 0.0556 0.0559 777.4543 997.0999 951.4738 1019.3421
5020  0.0775 0.0769 0.0571 0.0556 0.0704 612.0752 709.9542 575.2651  647.6535
5021  0.0857 0.0559 0.0294 0.0556 0.0500 617.4345 700.6980 501.4269  626.3859
5022  0.1181 0.0420 0.0000 0.0278 0.0486 585.7888 693.8455 559.1845  622.7780
5023  0.1197 0.0350 0.0588 0.0286 0.0563 684.5878 772.5444 822.9681  908.1756
5024  0.0490 0.0694 0.0857 0.0556 0.0280 595.9175 767.3401 629.8362  732.2745
     p0.05dvc1 p0.05dvc2 p0.05dvc3 p0.05dvc4 p0.25dvc1 p0.25dvc2 p0.25dvc3 p0.25dvc4
5013    538.65    744.25    575.00    704.20     666.0    889.75    858.00    910.00
5020    474.00    532.10    453.50    506.35     515.0    639.00    508.25    575.00
5021    447.00    485.00    456.75    483.90     552.5    594.75    502.00    549.50
5022    497.50    506.55    436.75    461.45     548.5    607.75    528.00    563.75
5023    433.10    482.00    549.40    668.40     641.0    722.25    705.50    793.75
5024    484.15    594.90    495.75    585.20     536.0    703.50    556.00    658.00
     p0.75dvc1 p0.75dvc2 p0.75dvc3 p0.75dvc4 p0.95dvc1 p0.95dvc2 p0.95dvc3 p0.95dvc4
5013    958.00   1150.50   1181.75   1245.00   1462.55   1439.50   1779.75   1648.90
5020    684.50    764.00    624.75    701.75   1857.10   1198.10   1035.00   1568.25
5021    735.00    866.50    606.75    699.25    958.70    990.05    743.75    941.20
5022    650.50    833.75    610.00    734.25    744.80    971.05    706.75    888.25
5023    820.00    953.00   1027.00   1095.75   1034.80   1139.70   1405.30   1439.15
5024    659.75    832.50    695.50    837.50    887.20   1120.20   1062.75   1026.80
      mdvd1  mdvd2 mdvd3  mdvd4  merr1  merr2 merr3  merr4    mrmc1     mrmc2
5013 1.0000 1.0000     1 0.9931 0.0000 0.0000     0 0.0069 809.4818 1038.4444
5020 1.0000 0.9722     1 0.9861 0.0000 0.0278     0 0.0139 589.3846  699.3636
5021 1.0000 0.9444     1 0.9722 0.0000 0.0556     0 0.0278 655.0280  742.0294
5022 0.9931 0.9444     1 1.0000 0.0069 0.0556     0 0.0000 603.9929  725.2941
5023 1.0000 0.9444     1 0.9861 0.0000 0.0556     0 0.0139 709.2174  827.4706
5024 1.0000 0.9722     1 1.0000 0.0000 0.0278     0 0.0000 608.5211  777.3529
         mrmc3     mrmc4 pmrmc1 pmrmc2  pmrmc3 pmrmc4 nmrmc1 nmrmc2 nmrmc3 nmrmc4
5013 1001.1176 1057.5985 4.8611 0.0000  5.5556 4.1958      7      0      2      6
5020  566.5000  626.4351 9.7222 5.7143  5.5556 7.7465     14      2      2     11
5021  571.6571  641.5036 0.0000 0.0000  2.7778 2.1429      0      0      1      3
5022  562.9143  650.1250 2.0979 0.0000  2.7778 0.0000      3      0      1      0
5023  842.6970  955.3121 4.1667 0.0000  8.3333 0.7042      6      0      3      1
5024  611.3438  751.0071 1.3889 2.8571 11.1111 2.0833      2      1      4      3
     tmrmc1 tmrmc2 tmrmc3 tmrmc4
5013    144     36     36    143
5020    144     35     36    142
5021    143     34     36    140
5022    143     34     36    144
5023    144     34     36    142
5024    144     35     36    144
```

## References
Grange, J.A. (2015). trimr: An implementation of common response time trimming methods. R Package Version 1.0.1. https://cran.r-project.org/package=trimr

Selst, M. V., & Jolicoeur, P. (1994). A solution to the effect of sample size on outlier elimination. *The quarterly journal of
experimental psychology, 47* (3), 631-650.

