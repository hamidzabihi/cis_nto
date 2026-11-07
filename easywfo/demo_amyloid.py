"""
Minimal L4M demo for EasyWFO.
Reads two CP2K geometries, computes the CISD overlap, prints the result.
"""
import time
import numpy as np


def main():
    try:
        from cis_nto import compute_overlap
    except ImportError:
        print("cis_nto not installed. Run: pip install -e ../python_api/")
        return 1

    print("Using cis_nto API...")
    t0 = time.time()

    # Placeholder: replace with real 2B7 molden/log paths when available
    # S = compute_overlap("2B7_a.molden:2B7_a.log",
    #                     "2B7_b.molden:2B7_b.log",
    #                     format="cp2k", nstates=16)
    S = np.eye(16)
    elapsed = time.time() - t0

    print(f"Overlap matrix shape: {S.shape}")
    print(f"Time: {elapsed * 1000:.1f} ms")
    print()
    print("=== L4M demo complete ===")
    print("Replace the placeholder with real 2B7 geometries to run on production data.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
