[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers

This archive is distributed in association with the [INFORMS Journal on Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE).

The software and data in this repository are a snapshot of the software and data that were used in the research reported on in the paper [Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers](https://doi.org/10.1287/ijoc.2023.0243) by Xiangyu Cui, Rujun Jiang, Yun Shi, Rufeng Xiao and Yifan Yan.

**Important: This code is being developed on an on-going basis at https://github.com/RufengXiao/ADMM_CPT. Please go there if you would like to get a more recent version or would like support**

## Cite

To cite the contents of this repository, please cite both the paper and this repo, using their respective DOIs.

https://doi.org/10.1287/ijoc.2023.0243

https://doi.org/10.1287/ijoc.2023.0243.cd

Below is the BibTex for citing this snapshot of the repository.

```
@misc{cui2024decision,
  author =        {Xiangyu Cui and Rujun Jiang and Yun Shi and Rufeng Xiao and Yifan Yan},
  publisher =     {INFORMS Journal on Computing},
  title =         {{Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers}}, 
  year =          {2024},
  doi =           {10.1287/ijoc.2023.0243.cd},
  url =           {https://github.com/INFORMSJoC/2023.0243},
  note =          {Available for download at https://github.com/INFORMSJoC/2023.0243},  
}
```

## Description
The goal of this software is to demonstrate the effectiveness of the ADMM method proposed in this paper in the problem of decision making under cumulative prospect theory, as compared to other methods, as well as the effectiveness of the model when applied to empirical study.

## Data
The `data` folder contains all the data used in the paper. Below are some detailed descriptions of the contents:

* `daily_used.csv`: This dataset corresponds to the *FF48 dataset* mentioned in the paper detailing the daily returns of Fama French 48 industries spanning from December 14th, 2016 to December 1st, 2021. This dataset is publicly available on [Kenneth R. French’s website](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html).
* `code_list.txt`: the *S&P 500 dataset* mentioned in the paper lists the daily returns of 458 risky assets listed in the Standard & Poor’s 500 (S&P 500) Index, with a time span from August 31th, 2009 to August 20th, 2013. The dataset was obtained via a paid subscription on Center for Research in Security Prices, LLC (CRSP) at [Wharton Research Data Services](https://wrds-www.wharton.upenn.edu/). Restrictions apply to the availability of these data. Non-subscribers must obtain permission from CRSP prior to the use of any CRSP data or information in any materials, research, or products. Therefore, we are unable to provide the original data file for the *S&P 500 dataset*. In this file, we provide the codes for 458 stocks within the *S&P 500 dataset* as they correspond in the CRSP database. Subscribers can directly use these codes to query relevant information and thus obtain the original data file. 


## Code
In order to run this software, you must install Gurobi 11.0.0 from https://www.gurobi.com/downloads/gurobi-software/. This code can be run in Matlab R2023b.

This directory contains the folders `src` and `scripts`:
* `src`: includes the source code of the paper. See `src/README.md` for a description of this folder. This folder is organized as follows:
  * `src/coefficients_generating.m`: the code for generating the weights $a_i$ and $b_i$ in the paper.
  * `src/ADMM_CPT_solver.m`: the code for Algorithm 1 in the paper.
  * `src/dynamic_programming.m`: the code for Algorithm 2 and 3 in the paper.
  * `src/PAV_solver.m`,`src/PAV.m`,`src/find_minimizer.m`: the code for Algorithm 4 in the paper.
  * `src/bisectionMethod.m`: the code for finding the root of a function by using binary search.
* `scripts`: contains the scripts used to replicate the experiments in the paper. See the *Replicating* section below for details.

## Results

The results are presented in the numerical experiments section of the paper. 

The folder `results` contains the raw results files, with the contents and descriptions as follows:
* `daily_pic`: the files within this folder contain the results of the empirical studies referenced in Appendix D of the paper, organized as follows:
  * `CumulativeReturnSumdaily.eps`: Figure 1 in the paper illustrates the cumulative returns of the seven portfolios.
  * `SSPW*daily.eps`: Figure 3 in the paper is box-plots of six optimal portfolios’ diversification degrees.  `*` can be 2,3,4,5 or 6.
  * `Top5AverageWeightsfor*daily.eps`: Figure 2 in the paper is average weights on five top and other assets. `*` can be 'benchmark', 'largereferencepoint', 'nolossaversion', 'noprobabilitydistorition', 'noriskaversionandriskseeking', 'riskfreereferencepoint'.
  * `stats_daily.xlsx`: Table 6 in the paper  illustrates several performance metrics of the seven portfolios based on the 1000 different realizations.
* `res_w`: the files within this folder contain the solution of the the optimization problem under the settings of Section 5.3 in the paper solving by the ADMM-PAV in the paper, organized as follows:
  * `w_daily_used_*.mat`: `xopt` in this file denotes the solution based on the *FF48 dataset* in the paper. `*` can be 50, 100, 150, 200, 250, 300 represents utilizing historical returns data for the first `*` days as scenarios for the optimization problem.
  * `w_SP500_2_*.mat`: `xopt` in this file denotes the solution based on the *S&P 500 dataset* in the paper. `*` can be 300, 400, 500, 600, 700, 800, 900, 1000 and represents utilizing historical returns data for the first `*` days as scenarios for the optimization problem.
* `5-1_subproblemtest.mat`: the variables `dp_time`, `dp_val`, `fmincon_time`, `fmincon_val`, `pav_time`, and `pav_val` in the document represent the raw results corresponding to each respective time and objective value in Table 1 of Section 5.1 in the paper. Each variable is a matrix where rows denote Scenarios and columns denote instances.
* `5-2_ADMM_x_m*.mat`: the results under the settings in Section 5.3 in the paper by ADMM.
`x` can be either 48 or 500; 48 indicates that the problem is based on the *FF48 dataset*, while 500 signifies that the problem is based on the *S&P 500 dataset*. `m` can be either 'DP' or 'PAV', indicating that the $y$-subproblem was solved using either the dynamic programming (DP) algorithm or the pooling-adjacent-violators (PAV) algorithm described in Section 4.  `*` may denote '_rf' or be absent. If present as '_rf', it indicates that the reference point $B=r_f$, corresponding to the results presented in Table 3 of Section 5.2 in the paper. Conversely, if `*` is not present, it signifies that the reference point $B=0$, which aligns with the results documented in Table 2 of the same section. The variables stored are described as follows:
  * `flags`: indicates whether ADMM_PAV has converged under different scenarios.
  * `objvalue`: denotes the objective value under different scenarios.
  * `srs`: each column represents the results of the objective value under different scenarios as it changes with the number of iterations.
  * `times`: the ADMM run times under different scenarios.
  * `total_iter`: the number of ADMM iterations under different scenarios.
  * `xtimes`: the time taken to solve the $x$-subproblem in ADMM under different scenarios.
  * `ytimes`: the time taken to solve the $y$-subproblem in ADMM under different scenarios.


* `5-2_fmincon_x*.mat`:the results under the settings in Section 5.2 in the paper by the **fmincon** solver in **MATLAB**. `x` and `*` carry the same meanings as previously discussed. The variables stored are described as follows:
  * `fmincon_objvalue`: denotes the objective value under different scenarios.
  * `fmincon_times`: the **fmincon** solver run times under different scenarios.

* `5-3_ADMM_PAV_*.mat`: the results under the settings in Section 5.3 in the paper by ADMM-PAV. `*` can denote either 'daily_used' or 'SP500_2', representing which dataset the optimization problem is based upon. The variables stored are similar to `5-2_ADMM_x_m*.mat`.
  
* `5-3_fmincon_*.mat`: the results under the settings in Section 5.3 in the paper by the **fmincon** solver in **MATLAB**. `*` can denote either 'daily_used' or 'SP500_2', representing which dataset the optimization problem is based upon. The variables stored are similar to `5-2_fmincon_x*.mat`.

* `*_cptopt_results.mat`: the results under the settings in Section 5.3 in the paper by the other method. `*` can denote either 'daily_used' or 'SP500_2', representing which dataset the optimization problem is based upon. The variables stored are described as follows:
  * `ccob`, `cctime`: the objetive value and time  under the settings in Section 5.3 in the paper by the iterated convex-concave (CC) method.
  * `gaob`, `gatime`: the objetive value and time  under the settings in Section 5.3 in the paper by the projected gradient ascent (GA) method.
  * `mmob`, `mmtime`: the objetive value and time  under the settings in Section 5.3 in the paper by the minorization-maximization (MM) method.

* `Empirical_*_daily.mat`: the results under different model settings in the empirical study of the paper. For more details on the experimental settings, refer to Appendix D of the paper. `*` can be 'benchmark', 'large_reference_point', 'no_loss_aversion', 'no_probability_distorition', 'no_risk_aversion_and_risk_seeking', 'riskfree_reference_point'. The variables stored are described as follows:
  * `rtns`: the daily returns of the asset allocation under the current weights for each day.
  * `xopt_array`: each column represents the optimal weights obtained by solving the CPT portfolio optimization model for each day, using the most recent 250 daily returns as input scenarios.


## Replicating

**Note: Before running `scripts/run5_3.py`, please install the package `cptopt` which corresponds to the methods compared in the paper. The detailed description can be found in their [repository](https://github.com/cvxgrp/cptopt.git). The `cptopt` package can be installed using `pip` as follows**

```python
pip install git+https://github.com/cvxgrp/cptopt.git
```

* To replicate the results in the section "Numerical Tests for the y-subproblem Solvers" in the paper, please run `scripts/run5_1.m`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Numerical Tests for the ADMM Algorithms" in the paper, please run `scripts/run5_2.m`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Numerical Tests for Comparison with Luxenberg et al. (2024)" in the paper, please run `scripts/run5_3.m` and `scripts/run5_3.py`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Empirical Study" in the paper, please run `run5_4.m`. The results obtained will be stored in the `results` folder. Subsequently, executing `scripts/plot_table.py` will generate the figure and table presented in Appendix D of the paper. The results obtained will be stored in the `results/daily_pic` folder.

## Support

For support in using this software, submit an [issue](https://github.com/RufengXiao/ADMM_CPT/issues/new). This code is being developed on an on-going basis at the author's [Github page](https://github.com/RufengXiao/ADMM_CPT).
