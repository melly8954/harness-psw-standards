#!/usr/bin/env bash
# 인터뷰 체크리스트의 [필수] 항목이 처리됐는지 확인한다 (harness-psw 3.1, 10.5).
# 처리로 인정하는 것
#   - 인터뷰 기록의 "체크리스트:" 줄에 ID가 있음 (답을 받음)
#   - OPEN 파일에 ID가 있음 (미결로 등록됨)
#   - docs/srs/02-scope.md 해당 없음 표의 행에 ID가 있음
# 모두 처리됐으면 0, 아니면 1로 끝난다.
# 사용법: checklist-coverage.sh [체크리스트 경로]
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "git 저장소 안에서 실행해야 합니다" >&2; exit 1; }
cd "$root"

checklist="${1:-.claude/skills/psw-interview/references/checklist.md}"
[[ -f "$checklist" ]] || { echo "체크리스트가 없습니다: $checklist" >&2; exit 1; }

required="$(grep -oE '^- \[필수\] ck-[a-z]+-[0-9]+' "$checklist" | awk '{print $3}')"

answered="$(grep -rhE '^[[:space:]]*- 체크리스트:' records/interviews 2>/dev/null | grep -oE 'ck-[a-z]+-[0-9]+' || true)"
opened="$(grep -rhoE 'ck-[a-z]+-[0-9]+' records/open 2>/dev/null || true)"
not_applicable="$(sed -n '/^## 해당 없음/,/^## /p' docs/srs/02-scope.md 2>/dev/null | grep -E '^\|' | grep -oE 'ck-[a-z]+-[0-9]+' || true)"

missing=()
total=0
while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  total=$((total + 1))
  if grep -qxF "$id" <<<"$answered" || grep -qxF "$id" <<<"$opened" || grep -qxF "$id" <<<"$not_applicable"; then
    continue
  fi
  missing+=("$id")
done <<<"$required"

echo "필수 항목: $total, 누락: ${#missing[@]}"
if [[ ${#missing[@]} -gt 0 ]]; then
  for id in "${missing[@]}"; do
    grep -E "^- \[필수\] $id " "$checklist" | sed 's/^- \[필수\] /누락: /'
  done
  exit 1
fi
echo "누락 없음"
