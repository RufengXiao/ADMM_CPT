## Source code
This folder contains all the source code for the implemention of the algorithms in our paper titled "Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers". The more details of these code are described as follow:
* `ADMM_CPT_solver.m`: this function implements an Alternating Direction Method of Multipliers (ADMM) solver for CPT optimization problem which corresponds to the Algorithm 1 in the paper.
* `bisectionMethod.m`: this function implements the bisection method for finding a root of a function within a specified interval.
* `coefficients_generating.m`: this function generates coefficients 'an' and 'bn' for use in the models in the paper.
* `dynamic_programming.m`: this function implements the dynamic programming algorithm for solving y-subproblem as described in Algorithms 2 and 3 of the paper.
* `PAV_solver.m`: this function solves the y-subproblem using the Pool Adjacent Violators (PAV) algorithm which is the Algorithm 4 in the paper.
* `PAV.m`: this function implements the Pool Adjacent Violators (PAV) algorithm for solving the y-subproblem in the paper.
* `find_minimizer.m`: this function finds the minimizer of the subproblem of the PAV algorithm.
