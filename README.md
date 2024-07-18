[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers

This archive is distributed in association with the [INFORMS Journal on Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE).

The software and data in this repository are the implementation of the software and data that were used in the research reported on in the paper [Decision Making under Cumulative Prospect Theory: An Alternating Direction Method of Multipliers](https://doi.org/10.1287/ijoc.2023.0243) by Xiangyu Cui, Rujun Jiang, Yun Shi, Rufeng Xiao and Yifan Yan.

## Description
The goal of this software is to demonstrate the effectiveness of the ADMM method proposed in this paper in the problem of decision making under cumulative prospect theory, as compared to other methods, as well as the effectiveness of the model when applied to empirical study.

## Code
In order to run this software, you must install Gurobi 11.0.0 from https://www.gurobi.com/downloads/gurobi-software/. This code can be run in Matlab R2023b.

This directory contains the folders `src`，`scripts`，`data` and `results`:
* `src`: includes the source code of the paper. This folder is organized as follows:
  * `src/coefficients_generating.m`: the code for generating the weights $a_i$ and $b_i$ in the paper.
  * `src/ADMM_CPT_solver.m`: the code for Algorithm 1 in the paper.
  * `src/dynamic_programming.m`: the code for Algorithm 2 and 3 in the paper.
  * `src/PAV_solver.m`,`src/PAV.m`,`src/find_minimizer.m`: the code for Algorithm 4 in the paper.
  * `src/bisectionMethod.m`: the code for finding the root of a function by using binary search.
* `results`: contains the raw results files.
* `data`: contains the raw data files.
* `scripts`: contains the scripts used to replicate the experiments in the paper. See the *Replicating* section below for details. `scripts/cptopt` contains the source code for the methods being compared in the paper. See `scripts/README.md` and `scripts/setup.cfg` for the description of this folder.

## Results

The results are presented in the numerical experiments section of the paper.

## Replicating

* To replicate the results in the section "Numerical Tests for the y-subproblem Solvers" in the paper, please run `scripts/run5_1.m`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Numerical Tests for the ADMM Algorithms" in the paper, please run `scripts/run5_2.m`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Numerical Tests for Comparison with Luxenberg et al. (2024)" in the paper, please run `scripts/run5_3.m` and `scripts/run5_3.py`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Empirical Study" in the paper, please run `run5_4.m`. The results obtained will be stored in the `results` folder. Subsequently, executing `scripts/plot_table.py` will generate the figure and table presented in Appendix D of the paper. The results obtained will be stored in the `results/daily_pic` folder.

## Citation
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

## Support

For support in using this software, submit an [issue](https://github.com/RufengXiao/ADMM_CPT/issues/new).
