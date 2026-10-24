# Third-Party Notices

This project (`cis_nto`) includes code and algorithms inspired by or dependent on the following third-party software and research:

## Eigen
This project uses the Eigen C++ template library for linear algebra.
- **License:** Mozilla Public License 2.0 (MPL 2.0)
- **Source:** https://gitlab.com/libeigen/eigen
- **Usage:** Fetched automatically via CMake `FetchContent`.

## Shakiba & Akimov (2023)
The `src/easywfo` module implements algorithms described in the following publication:
- **Paper:** "Generalization of the local diabatization approach for propagating electronic degrees of freedom in nonadiabatic dynamics" (2023).
- **Note:** The code is an original reimplementation of the mathematical concepts and does not contain copied source code.

## SHARC
The `wfthres` norm-based truncation logic in `easywfo_core.hpp` is inspired by the SHARC software package (Surface Hopping Including Arbitrary Couplings).
- **Note:** No source code was copied; only the mathematical concept was implemented.
