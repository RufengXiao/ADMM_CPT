This code is the implementation of the algorithms and experiments in our paper "Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers".

* `comexp/`: the source code for the algorithms in paper "Portfolio Optimization with Cumulative Prospect Theory Utility via Convex Optimization", which can be found in https://​github.​com/​cvxgrp/​cptopt.

### Introduction
This code can be run in Matlab R2023b and Gurobi 11.0.0. 

In order to run the comparison experiment properly, since its code is written in Python, we recommend referring to `comexp/README.md`.

* `coefficients_generating.m`: the code for generating the weights $a_i$ and $b_i$ in our paper.
* `ADMM_CPT_solver.m`: the code for Algorithm 1 in our paper.
* `dynamic_programming.m`: the code for Algorithm 2 and 3 in our paper.
* `PAV_solver.m`,`PAV.m`,`find_minimizer.m`: the code for Algorithm 4 in our paper.
* `bisectionMethod.m`: the code for finding the root of a function by using binary search.
* `res_w`: Store the results generated from the section "Numerical Tests for Comparison with Luxenberg et al. (2024)". Then transfer these in the `compexp\res_w` folder for comparison purposes.

### How to get the results
* To get the results of the section "Numerical Tests for the y-subproblem Solvers" in our paper, please run `run5_1.m`. The results obtained will be stored in the `res` folder.
* To get the results of the section "Numerical Tests for the ADMM Algorithms" in our paper, please run `run5_2.m`. The results obtained will be stored in the `res` folder.
* To get the results of the section "Numerical Tests for Comparison with Luxenberg et al. (2024)" in our paper, please run `run5_3.m` and `compexp/run5_3.py`. The results obtained will be stored in the `res` folder and `compexp/result` folder.
* To get the results of the section "Empirical Study" in our paper, please run `run5_4.m`. The results obtained will be stored in the `res` folder. Please transfer the five results from `Empirical_xxxx.mat` into the `plot` folder. Subsequently, executing `plot/plot_table.py` will generate the figure and table presented in Appendix D of our paper.

### Citation
If you want to reference our paper in your research, please consider citing us by using the following BibTeX:

```bib
@misc{cui2024decision,
      title={Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers}, 
      author={Xiangyu Cui and Rujun Jiang and Yun Shi and Rufeng Xiao and Yifan Yan},
      year={2024},
      eprint={2210.02626},
      archivePrefix={arXiv},
      primaryClass={id='math.OC' full_name='Optimization and Control' is_active=True alt_name=None in_archive='math' is_general=False description='Operations research, linear programming, control theory, systems theory, optimal control, game theory'}
}
```

If you have any questions, please contact us.
