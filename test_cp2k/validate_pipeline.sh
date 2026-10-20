#!/bin/bash
set -u
VAC="$HOME/Project_ML_BP_revision1/03-OVERLAPS/di_vacancy"
CIS="$HOME/cis_nto/build/bin"
OUT="$VAC/pipeline_validation_$(date +%Y%m%d_%H%M%S)"
export OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1
cd "$VAC" || exit 1
mkdir -p "$OUT"/{raw,norm,logs}

load() {
    python3 -c "
import numpy as np
def load_any(p):
    with open(p) as f: L=[l for l in f.readlines() if l.strip()]
    try:
        n=int(L[0].split()[0])
        if len(L)==n+1:
            M=np.zeros((n,n))
            for i in range(n): M[i]=[float(x) for x in L[i+1].split()]
            return M
    except (ValueError, IndexError): pass
    return np.loadtxt(p)
M = load_any('$1')
d = np.abs(np.diag(M))[:6]
row = np.abs(M[1, 2:6])
print(' '.join(f'{x:.5f}' for x in d) + '|' + ' '.join(f'{x:.5f}' for x in row))
"
}

frame_ok() {
    local n=$1
    [ -f "p4-di-PBE_${n}-MOS-1_0.molden" ] && [ -f "run_${n}.log" ] \
        && grep -q 'TDDFPT run converged' "run_${n}.log" 2>/dev/null \
        && [ "$(grep -c '^Ene=' "p4-di-PBE_${n}-MOS-1_0.molden" 2>/dev/null)" -ge 155 ]
}

FR=(); for n in $(seq 1 100); do frame_ok "$n" && FR+=("$n") || break; done
N=${#FR[@]}; echo "Frames: ${FR[*]}   total=$N"
[ "$N" -lt 2 ] && { echo "FATAL: need >=2 frames"; exit 1; }

# =====================================================
# T1: Self-overlap identity — -tnex 3 for exact identity
# =====================================================
echo ""
echo "=== T1: Self-overlap identity (-tnex 3) ==="
printf "%-6s | %-42s | %s\n" "frame" "GS S1 S2 S3 S4 S5" "status"
T1_PASS=0
for n in "${FR[@]}"; do
    rm -f s_wf
    timeout 90 "$CIS/cis_overlap.exe" -in cp2k -alg NTO -tnex 3 \
        "p4-di-PBE_${n}-MOS-1_0.molden:run_${n}.log" \
        "p4-di-PBE_${n}-MOS-1_0.molden:run_${n}.log" > "$OUT/logs/t1_${n}.log" 2>&1
    if [ -f s_wf ]; then
        mv s_wf "$OUT/raw/self_${n}.txt"
        diag=$(load "$OUT/raw/self_${n}.txt" | cut -d'|' -f1)
        st=$(python3 -c "
xs = '$diag'.split()
gs = float(xs[0]); exc = [float(x) for x in xs[1:]]
ok = abs(gs-1) < 1e-3 and all(abs(e-1) < 1e-3 for e in exc)
print('PASS' if ok else 'FAIL')")
        [ "$st" = "PASS" ] && ((T1_PASS++))
        printf "%-6s | %-42s | %s\n" "$n" "$diag" "$st"
    else
        printf "%-6s | %-42s | %s\n" "$n" "(TIMEOUT/FAIL)" "FAIL"
    fi
done
echo "T1: $T1_PASS / $N PASS"

# =====================================================
# T2: Consecutive tracking — -tnex 1
# =====================================================
echo ""
echo "=== T2: Consecutive — S1 row off-diagonals (-tnex 1) ==="
printf "%-10s | %-40s\n" "pair" "S1↔S2 S1↔S3 S1↔S4 S1↔S5"
for k in $(seq 0 $((N-2))); do
    a=${FR[$k]}; b=${FR[$((k+1))]}
    rm -f s_wf
    timeout 60 "$CIS/cis_overlap.exe" -in cp2k -alg NTO -tnex 1 \
        "p4-di-PBE_${a}-MOS-1_0.molden:run_${a}.log" \
        "p4-di-PBE_${b}-MOS-1_0.molden:run_${b}.log" > "$OUT/logs/t2_${a}_${b}.log" 2>&1
    if [ -f s_wf ]; then
        mv s_wf "$OUT/raw/cross_${a}_${b}.txt"
        python3 normalize_wf.py "$OUT/raw/cross_${a}_${b}.txt" \
            "$OUT/norm/cross_${a}_${b}.txt" > /dev/null 2>&1
        printf "%-10s | %s\n" "${a}→${b}" "$(load "$OUT/norm/cross_${a}_${b}.txt" | cut -d'|' -f2)"
    fi
done

# =====================================================
# T3: Reference decay — -tnex 1
# =====================================================
echo ""
echo "=== T3: Reference S(1→N) — S1 row off-diagonals (-tnex 1) ==="
FIRST=${FR[0]}
printf "%-10s | %-40s\n" "pair" "S1↔S2 S1↔S3 S1↔S4 S1↔S5"
for k in $(seq 1 $((N-1))); do
    b=${FR[$k]}
    rm -f s_wf
    timeout 60 "$CIS/cis_overlap.exe" -in cp2k -alg NTO -tnex 1 \
        "p4-di-PBE_${FIRST}-MOS-1_0.molden:run_${FIRST}.log" \
        "p4-di-PBE_${b}-MOS-1_0.molden:run_${b}.log" > "$OUT/logs/t3_${FIRST}_${b}.log" 2>&1
    if [ -f s_wf ]; then
        mv s_wf "$OUT/raw/ref_${FIRST}_${b}.txt"
        python3 normalize_wf.py "$OUT/raw/ref_${FIRST}_${b}.txt" \
            "$OUT/norm/ref_${FIRST}_${b}.txt" > /dev/null 2>&1
        printf "%-10s | %s\n" "${FIRST}→${b}" "$(load "$OUT/norm/ref_${FIRST}_${b}.txt" | cut -d'|' -f2)"
    fi
done

# =====================================================
# T5 + T6: Post-process using the norm/ files
# =====================================================
echo ""
python3 ~/extend_report.py "$OUT" 2>&1

# =====================================================
# Footer
# =====================================================
echo ""
echo "================================================================"
echo "  Output folder: $OUT"
echo "  Frames validated: $N"
echo "  T1 verdict: $T1_PASS / $N PASS"
echo ""
echo "  To rerun with more frames:"
echo "    bash ~/validate_pipeline.sh 2>&1 | tee ~/INTERVIEW_TABLES_${N}frames.log"
echo "================================================================"
