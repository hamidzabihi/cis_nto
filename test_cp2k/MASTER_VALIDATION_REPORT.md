# CIS_NTO — CP2K Interface Master Validation Report

**Pipeline:** Production 300K Trajectory (15 TDDFPT States)
**Status:** `set_identity_overlap` REMOVED, `fix_mo=0`, AO Symmetrized

### Root-Cause Fixes Included:
1. **ORCA Phase Corruption Fixed:** Changed `fix_mo = 3` to `fix_mo = 0` in `cp2k_read.f90`. This removed the artificial ORCA phase flips on CP2K spherical harmonics, dropping the self-overlap error from `1e-1` to machine precision `8.7e-8`.
2. **`set_identity_overlap` Hack Removed:** The band-aid in `overlap_mo.f90` was completely removed. Overlaps are now computed naturally and correctly.
3. **AO Matrix Symmetrization:** `overlap_ao.f90` now symmetrizes the raw integrals (`s_ao = (s_ao + s_ao^T)/2`), removing antisymmetric p/d artifacts and ensuring `sigma_max <= 1.00000000`.


## 1. ML-BP vs. paper (leading CI weights)
```
functional   state    lead W     paper     delta
--------------------------------------------------
PBEh0125         1    0.9935    0.9930   +0.0005
B3LYP            1    0.9788    0.9790   -0.0002
PBE0             1    0.9670    0.9670   +0.0000
BHandHLYP        1    0.8365    0.8370   -0.0005
CAM_B3LYP        1    0.7695    0.7690   +0.0005
wB97XD          38    0.1849    0.1850   -0.0001
wB97X           38    0.1529    0.1530   -0.0001
```

## 2. Adamantane physics checks
```
  [PASS] adamantane                   inputs present  --  formula C10H16
  [PASS] 1_methyladamantane           inputs present  --  formula C11H18
  [PASS] 1_3_dimethyladamantane       inputs present  --  formula C12H20
  [PASS] 1_3_5_trimethyladamantane    inputs present  --  formula C13H22
  [PASS] adamantane                   reader runs  --  exit=0
  [PASS] 1_methyladamantane           reader runs  --  exit=0
  [PASS] 1_3_dimethyladamantane       reader runs  --  exit=0
  [PASS] 1_3_5_trimethyladamantane    reader runs  --  exit=0
  [PASS] adamantane                   cubes  --  Y Y Y Y
  [PASS] 1_methyladamantane           cubes  --  Y Y Y Y
  [PASS] 1_3_dimethyladamantane       cubes  --  Y Y Y Y
  [PASS] 1_3_5_trimethyladamantane    cubes  --  Y Y Y Y
  L2 integral ~ 1.0; nonzero-cell count above a floor.
  Molecule                     L2       nonzero    verdict 
  adamantane                   1.0000   63999      OK      
  1_methyladamantane           1.0000   63999      OK      
  1_3_dimethyladamantane       1.0000   63998      OK      
  1_3_5_trimethyladamantane    1.0000   63996      OK      
  [PASS] endpoint change > 1e-3 (0.0011)
Summary
  [PASS] 1. Input availability
  [PASS] 2. Reader invocation
  [PASS] 3. NTO cube generation
  [PASS] 4. Physics checks
  [PASS] 5. Methylation trend
  ALL ADAMANTANE CHECKS PASSED
```
