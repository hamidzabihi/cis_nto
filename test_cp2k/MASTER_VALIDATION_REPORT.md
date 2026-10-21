# CIS_NTO — CP2K Interface Master Validation Report

**Date:** Wed Oct 21 12:23:48 +0330 2026
**Script dir:** `/home/hamid/cis_nto/test_cp2k`
**Binary dir:** `/home/hamid/cis_nto/build/bin`
**Data dir:** `/home/hamid/Project_ML_BP_revision1/03-OVERLAPS/di_vacancy`

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

## 3. T1 Self-Overlap Identity (all steps)

```
 T1 — SELF-OVERLAP IDENTITY (-tnex 3)
==============================================================================
step |      GS      S1      S2      S3      S4      S5 | status
------------------------------------------------------------------------------
    1 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
    2 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
    3 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
    4 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
    5 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
    6 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
    7 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
    8 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
    9 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   10 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   11 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   12 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   13 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   14 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   15 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   16 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   17 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   18 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   19 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
   20 | 1.00000 1.00000 1.00000 1.00000 1.00000 1.00000 | PASS
------------------------------------------------------------------------------
T1: 20/20 PASS
```

## 4. T2 Consecutive Tracking (all pairs)

```
 T2 — CONSECUTIVE TRACKING (S1 row off-diagonals)
==============================================================================
    pair |    S1↔S2    S1↔S3    S1↔S4    S1↔S5
------------------------------------------------------------------------------
1→2    |  0.01602  0.00657  0.04960  0.00078
2→3    |  0.01618  0.01416  0.04952  0.00075
3→4    |  0.01396  0.00743  0.04989  0.00075
4→5    |  0.01400  0.00759  0.04925  0.00080
5→6    |  0.01633  0.00795  0.05046  0.00077
6→7    |  0.01419  0.01537  0.05098  0.00080
7→8    |  0.01671  0.00824  0.05017  0.00082
8→9    |  0.01438  0.00829  0.05145  0.00079
9→10   |  0.01679  0.01539  0.05045  0.00051
10→11   |  0.01449  0.01552  0.05209  0.00049
11→12   |  0.01712  0.00515  0.05110  0.00114
12→13   |  0.01473  0.01153  0.05270  0.00045
13→14   |  0.01719  0.01105  0.05200  0.00039
14→15   |  0.01745  0.01076  0.05342  0.00125
15→16   |  0.01749  0.01882  0.05290  0.00136
16→17   |  0.01502  0.01806  0.05203  0.00032
17→18   |  0.01762  0.00229  0.05484  0.00029
18→19   |  0.01752  0.00830  0.05389  0.00025
19→20   |  0.01513  0.01076  0.05439  0.00156
------------------------------------------------------------------------------
T2: 19/19 pairs
```

## 5. T5 Decay Rate Fit

```
 T5 — DECAY RATE FIT (19 points, Δt=1..19)
==============================================================================
column     |   slope (×10⁻³/Δt) |     R² |     mean |        σ |     CV
------------------------------------------------------------------------------
S1↔S2      |              1.797 |  0.962 |  0.03067 |  0.01003 |  0.327
S1↔S3      |              1.511 |  0.671 |  0.01364 |  0.01011 |  0.741
S1↔S4      |              0.573 |  0.386 |  0.04845 |  0.00505 |  0.104
S1↔S5      |              0.099 |  0.518 |  0.00136 |  0.00075 |  0.553
------------------------------------------------------------------------------

==============================================================================
 T6 — PHYSICS vs RESIDUAL CLASSIFICATION
```

## 6. T6 Physics vs Residual Classification

```
 T6 — PHYSICS vs RESIDUAL CLASSIFICATION
==============================================================================
  Rules: CV<0.05 → RESIDUAL | CV>0.10 + monotone → PHYSICS | CV>0.20 → PHYSICS(noisy) | else MIXED
------------------------------------------------------------------------------
column     |     CV |  monotone | verdict        | interpretation
------------------------------------------------------------------------------
S1↔S2      |  0.327 |        no | PHYSICS(noisy) | fluctuating mixing, slope +1.80e-3
S1↔S3      |  0.741 |        no | PHYSICS(noisy) | fluctuating mixing, slope +1.51e-3
S1↔S4      |  0.104 |        no | MIXED          | weak trend / noise
S1↔S5      |  0.553 |         ↑ | PHYSICS(noisy) | fluctuating mixing, slope +0.10e-3
------------------------------------------------------------------------------

  PHYSICS:  S1↔S2, S1↔S3, S1↔S5
  RESIDUAL: (none)

  Note: at 19 points, CV uncertainty ≈ ±5%
  Rerun with ≥15 points for tighter classification.

==============================================================================
 DONE — artifacts in /home/hamid/Project_ML_BP_revision1/03-OVERLAPS/di_vacancy/py_validation_20261021_122352/
```

## 7. S1 energy drift (all steps)

```
  Step | S1 Energy (eV) | Drift (meV)
  -------------------------------------
     1  |        0.47804 | +0.0
     2  |        0.47406 | -4.0
     3  |        0.47054 | -7.5
     4  |        0.46741 | -10.6
     5  |        0.46467 | -13.4
     6  |        0.46236 | -15.7
     7  |        0.46041 | -17.6
     8  |        0.45888 | -19.2
     9  |        0.45776 | -20.3
    10  |        0.45710 | -20.9
    11  |        0.45690 | -21.1
    12  |        0.45714 | -20.9
    13  |        0.45786 | -20.2
    14  |        0.45903 | -19.0
    15  |        0.46073 | -17.3
    16  |        0.46299 | -15.1
    17  |        0.46569 | -12.4
    18  |        0.46892 | -9.1
    19  |        0.47265 | -5.4
    20  |        0.47697 | -1.1
```
Physical relaxation with CP2K. No state swaps.

## 8. SVD algorithm proof

```
Functional   | CI Weight (CP2K)   | NTO Eigenvalue (cis_nto)
--------------------------------------------------------
PBEh0125     | 0.9935             | 0.996860            
PBE0         | 0.9670             | 0.983552            
BHandHLYP    | 0.8365             | 0.914883            
CAM_B3LYP    | 0.7695             | 0.877470            

BHandHLYP divergence (0.8365 -> 0.9149) proves SVD works.
```
