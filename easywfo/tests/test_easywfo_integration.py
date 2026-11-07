"""
End-to-end integration test for the EasyWFO + L4M pipeline.
Asserts the L4M Fortran validation suite still passes.
"""
import shutil
import subprocess
from pathlib import Path


def _repo_root():
    return Path(__file__).resolve().parent.parent.parent


def test_l4m_synthetic_validation():
    test_dir = _repo_root() / "test_cisd"
    assert test_dir.exists(), f"test_cisd not found in {_repo_root()}"
    subprocess.run(["make", "check_l4m_extended"], cwd=test_dir, check=True)
    result = subprocess.run(
        ["./check_l4m_extended"], cwd=test_dir, capture_output=True, text=True
    )
    assert "done" in result.stdout, result.stdout
    assert "FAIL" not in result.stdout, result.stdout


def test_amyloid_suite_passes():
    test_dir = _repo_root() / "test_cisd"
    amyloid_files = sorted(test_dir.glob("amyloid_t*_n*.txt"))
    assert len(amyloid_files) >= 20, f"only {len(amyloid_files)} amyloid files found"

    for f in amyloid_files[:3]:
        shutil.copy(f, test_dir / "real_data.txt")
        subprocess.run(["make", "check_real_tri"], cwd=test_dir, check=True)
        result = subprocess.run(
            ["./check_real_tri"], cwd=test_dir, capture_output=True, text=True
        )
        assert "PASS" in result.stdout, f"{f.name} failed: {result.stdout}"
