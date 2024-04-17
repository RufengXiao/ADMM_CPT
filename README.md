This code is the implementation of the algorithms and experiments in our paper "Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers".

* `comexp/`: the source code for the algorithms in paper "Portfolio Optimization with Cumulative Prospect Theory Utility via Convex Optimization", which can be found in https://​github.​com/​cvxgrp/​cptopt.

### Introduction
This code can be run in Matlab R2023b and Gurobi 11.0.0. 

In order to run the comparison experiment properly, since its code is written in Python, we recommend referring to `comexp/README.md'.

* `coefficients_generating.m`: the code for generating the weights $a_n$ and $b_n$ in our paper.
* `ADMM_CPT_solver.m`: the code for Algorithm 1 in our paper.
* `PAV_solver.m`,`PAV.m`,`find_minimizer.m`,`bisectionMethod.m`: the code for Algorithm 4 in our paper.
* `dynamic_programming.m`,`Block.m`,`back_tracking.m`,`merge.m`: the code for Algorithm 3 in our paper.

### How to get the results
* To get the results of the chapter `Numerical Tests for the y-subproblem Solvers' in our paper, please run `run5_1.m`
* To get the results of the chapter `Numerical Tests for the ADMM Algorithms' in our paper, please run `run5_2.m`
* To get the results of the chapter `Numerical Tests for Comparison with Luxenberg et al. (2024)' in our paper, please run `run5_3.m` and `compexp/run5_3.py'
* To get the results of the chapter `Empirical Study' in our paper, please run `run5_4.m`

### Citation
If you found the provided code useful, please cite our work.

If you have any questions, please contact us.
