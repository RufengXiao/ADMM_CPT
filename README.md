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

## Code
In order to run this software, you must install Gurobi 11.0.0 from https://www.gurobi.com/downloads/gurobi-software/. This code can be run in Matlab R2023b.

In order to run the comparison experiment properly, since its code is written in Python, we recommend referring to `scripts/README.md`.

This directory contains the folders `src`，`scripts`，`data` and `results`:
* `src`: includes the source code of the paper. This folder is organized as follows:
  * `src/coefficients_generating.m`: the code for generating the weights $a_i$ and $b_i$ in the paper.
  * `src/ADMM_CPT_solver.m`: the code for Algorithm 1 in the paper.
  * `src/dynamic_programming.m`: the code for Algorithm 2 and 3 in the paper.
  * `src/PAV_solver.m`,`src/PAV.m`,`src/find_minimizer.m`: the code for Algorithm 4 in the paper.
  * `src/bisectionMethod.m`: the code for finding the root of a function by using binary search.
* `results`: contains the raw results files.
* `data`: contains the raw data files.
* `scripts`: contains the scripts used to replicate the experiments in the paper. See the *Replicating* section below for details. `scripts/cptopt` contains the source code for the methods being compared in the paper. See `scripts/README.md` and scripts/setup.cfg` for the description of this folder.

## Results

The results are presented in the numerical experiments section of the paper.

## Replicating

* To replicate the results in the section "Numerical Tests for the y-subproblem Solvers" in the paper, please run `scripts/run5_1.m`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Numerical Tests for the ADMM Algorithms" in the paper, please run `scripts/run5_2.m`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Numerical Tests for Comparison with Luxenberg et al. (2024)" in the paper, please run `scripts/run5_3.m` and `scripts/run5_3.py`. The results obtained will be stored in the `results` folder.
* To replicate the results in the section "Empirical Study" in the paper, please run `run5_4.m`. The results obtained will be stored in the `results` folder. Subsequently, executing `scripts/plot_table.py` will generate the figure and table presented in Appendix D of the paper. The results obtained will be stored in the `results/daily_pic` folder.

## Support

For support in using this software, submit an [issue](https://github.com/RufengXiao/ADMM_CPT/issues/new). This code is being developed on an on-going basis at the author's [Github page](https://github.com/RufengXiao/ADMM_CPT).
