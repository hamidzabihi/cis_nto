"""
60-second end-to-end L4M demo.

System: ethylene (C2H4), STO-3G, 4-orbital active space.
Steps: RHF at two geometries, CISD at each, L4M overlap via Fortran,
       assert L4M matches brute force.
"""
import numpy as np
import subprocess
import time
from pathlib import Path


def main():
    from pyscf import gto, scf, fci
    from pyscf.fci import cistring

    geom_a = (
        "C  0.0000  0.0000  0.6670\n"
        "C  0.0000  0.0000 -0.6670\n"
        "H  0.9230  0.0000  1.2380\n"
        "H -0.9230  0.0000  1.2380\n"
        "H  0.9230  0.0000 -1.2380\n"
        "H -0.9230  0.0000 -1.2380"
    )
    geom_b = geom_a.replace(
        "C  0.0000  0.0000  0.6670",
        "C  0.0000  0.0000  0.6870",
    )

    print("=== L4M CISD Overlap Demo ===")
    print("System: ethylene, STO-3G, 4-orbital active space")
    print()

    t0 = time.time()
    results = []
    for label, geom in [("A", geom_a), ("B", geom_b)]:
        mol = gto.M(atom=geom, basis="sto-3g", verbose=0)
        mf = scf.RHF(mol).run(verbose=0)
        nocc = mol.nelectron // 2
        ncore = nocc - 2
        nact = 4
        mol_act = mol.copy()
        mol_act.nelectron = 4
        fci_solver = fci.FCI(mol_act, mf.mo_coeff[:, ncore:ncore+nact])
        _, civec = fci_solver.kernel()
        results.append({
            "mol": mol,
            "mo": mf.mo_coeff,
            "civec": civec.flatten(),
            "ncore": ncore,
            "n_mo": mf.mo_coeff.shape[1],
            "nocc": nocc,
        })
        print(f"  Geometry {label}: RHF+CISD done")

    A, B = results
    S_ao = A["mol"].intor_symmetric("int1e_ovlp")
    S_mo = A["mo"].T @ S_ao @ B["mo"]
    for i in range(S_mo.shape[0]):
        if S_mo[i, i] < 0:
            S_mo[:, i] *= -1
    print(f"  MO overlap shape: {S_mo.shape}")
    print(f"  RHF+CISD total time: {time.time() - t0:.2f} s")
    print()

    nact = 4
    nact_occ = nact // 2
    ncore = A["ncore"]
    strs = cistring.gen_strings4orblist(range(nact), nact_occ)
    nstr = len(strs)
    n_dets = nstr * nstr

    here = Path(__file__).resolve().parent
    test_dir = here.parent / "test_cisd"
    data_path = test_dir / "real_data.txt"

    with data_path.open("w") as f:
        f.write(f"{A['n_mo']} {A['nocc']} {n_dets} 1\n")
        for row in S_mo:
            f.write(" ".join(f"{x:.15f}" for x in row) + "\n")
        for ia, sa in enumerate(strs):
            for ib, sb in enumerate(strs):
                occ = [i + 1 for i in range(ncore)]
                occ += [i + 1 + ncore for i in range(nact) if sa & (1 << i)]
                f.write(" ".join(map(str, occ)) + "\n")
                f.write(" ".join(map(str, occ)) + "\n")
                idx = ia * nstr + ib
                f.write(f"{A['civec'][idx]:.15f} {B['civec'][idx]:.15f}\n")

    print(f"  Wrote {data_path.name} ({n_dets} determinants)")
    print()
    print("  Building Fortran modules...")
    subprocess.run(
        ["make", "cis_overlap_cisd.o", "cis_overlap_cisd_l4m.o",
         "cis_overlap_cisd_l4m_fast.o"],
        cwd=test_dir, check=True, capture_output=True,
    )
    subprocess.run(["make", "check_real_tri"], cwd=test_dir, check=True,
                   capture_output=True)

    print("  Running L4M Fortran check...")
    t1 = time.time()
    out = subprocess.run(
        ["./check_real_tri"], cwd=test_dir, capture_output=True, text=True
    ).stdout
    elapsed = time.time() - t1

    for line in out.splitlines():
        if any(k in line for k in (
            "S_brute", "S_L4M", "S_fast", "|brute", "PASS", "FAIL"
        )):
            print("  " + line)

    passed = "PASS" in out
    print()
    print(f"  Fortran time: {elapsed * 1000:.1f} ms")
    print(f"  Total time:   {time.time() - t0:.1f} s")
    print(f"  Result:       {'PASS' if passed else 'FAIL'}")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
