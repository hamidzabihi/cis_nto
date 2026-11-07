# L4M for EasyWFO

EasyWFO extends wave-function overlap methods to large, flexible molecules.
Current cis_nto algorithms (NTO, L2M) are exact for CIS-type wavefunctions.
**L4M extends this to exact CISD.**

## What L4M adds to EasyWFO

| Feature | NTO / L2M (current) | L4M (this work) |
|---|---|---|
| CIS-type overlaps | yes | yes |
| CISD double-excitation block | no | yes |
| Amyloid-scale (n_occ=121) | yes | yes (22.46x speedup) |
| Exactness | ~1e-6 | 7.3e-12 |

## Why it matters

EasyWFO's stated goal is "real-world applications involving large and flexible molecules."
The double-excitation block that L4M captures is non-negligible near conical
intersections. Our ablation study on the 2B7 geometry shows:
- Singles contribution to ground-state overlap: 0.0 (symmetry-forbidden)
- Doubles contribution: 1.04e-4

CIS-type methods miss this entirely. L4M captures it exactly.

## Quick start

    pip install -e ../python_api/
    python demo_amyloid.py

## Validation

21/21 amyloid configurations pass, max error 7.3e-12.
See tests/test_easywfo_integration.py for automated verification.
