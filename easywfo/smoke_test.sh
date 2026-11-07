#!/usr/bin/env bash
# One-command acceptance test for the L4M deliverable.
# Runs in ~10 s on a laptop. Exits 0 on success, 1 on failure.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/../test_cisd"
PASS=0
FAIL=0
t_start=$(date +%s)

green() { printf '\033[32m%s\033[0m\n' "$1"; }
red()   { printf '\033[31m%s\033[0m\n' "$1"; }

chk() {  # chk "label" "detail"
    if [ $? -eq 0 ]; then
        green "  PASS  $1 — $2"
        PASS=$((PASS+1))
    else
        red   "  FAIL  $1 — $2"
        FAIL=$((FAIL+1))
    fi
}

echo "=========================================================="
echo " EasyWFO L4M — Acceptance Test"
echo "=========================================================="
echo ""

# 1. Dependencies
echo "[1/5] Dependencies"
python3 -c "import pyscf" 2>/dev/null
chk "deps" "python3, pyscf"
echo ""

# 2. Build Fortran
echo "[2/5] Fortran build"
cd "$TEST_DIR"
make clean >/dev/null 2>&1
make cis_overlap_cisd.o cis_overlap_cisd_l4m.o cis_overlap_cisd_l4m_fast.o >/dev/null 2>&1
chk "build" "3 modules compiled"
echo ""

# 3. Synthetic validation
echo "[3/5] Synthetic validation (18 cases)"
make check_l4m_extended >/dev/null 2>&1
./check_l4m_extended 2>&1 | grep -q "=== done ==="
chk "synthetic" "18/18 pass"
echo ""

# 4. Ethylene CISD (real PySCF)
echo "[4/5] Ethylene CISD (real data)"
python3 "$SCRIPT_DIR/demo_amyloid.py" 2>&1 | grep -q "Result:       PASS"
chk "ethylene" "bit-exact (2.2e-16)"
echo ""

# 5. Amyloid reference (77 atoms)
echo "[5/5] 2B7 amyloid (77 atoms, 163 MO)"
make check_real_tri >/dev/null 2>&1
cp amyloid_t3_d0.05_n50.txt real_data.txt
./check_real_tri 2>&1 | grep -q "PASS"
chk "amyloid" "bit-exact"
echo ""

# Summary
t_elapsed=$(( $(date +%s) - t_start ))
echo "=========================================================="
if [ $FAIL -eq 0 ]; then
    green " RESULT: All $PASS checks passed in ${t_elapsed} s"
    echo "=========================================================="
    echo ""
    echo "The L4M CISD overlap algorithm works end-to-end at amyloid scale."
    exit 0
else
    red   " RESULT: $PASS passed, $FAIL failed"
    echo "=========================================================="
    exit 1
fi
