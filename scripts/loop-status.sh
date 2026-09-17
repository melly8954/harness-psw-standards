#!/usr/bin/env bash
# 피드백 루프 종료 조건을 확인한다 (harness-psw 7.1, 8.3, 10.5).
# 종료 가능하면 0, 아니면 1로 끝난다.
# 사용법: loop-status.sh [자리표시를 검사할 경로...]   (기본: docs)
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "git 저장소 안에서 실행해야 합니다" >&2; exit 1; }
cd "$root"

scope=("$@")
[[ ${#scope[@]} -eq 0 ]] && scope=(docs)

status_of() {
  grep -m1 -E '^status:' "$1" 2>/dev/null | sed -E 's/^status:[[:space:]]*//; s/[[:space:]]*$//'
}

blocking=0

echo "== OPEN =="
open_ids=()
deferred_ids=()
for f in records/open/OPEN-*.md; do
  [[ -f "$f" ]] || continue
  id="$(basename "$f" .md)"
  case "$(status_of "$f")" in
    deferred) deferred_ids+=("$id") ;;
    *)        open_ids+=("$id") ;;
  esac
done
echo "open: ${#open_ids[@]} ${open_ids[*]:-}"
echo "deferred(보류 수용): ${#deferred_ids[@]} ${deferred_ids[*]:-}"

echo "== CR =="
pending_ids=()
for f in records/changes/CR-*.md; do
  [[ -f "$f" ]] || continue
  [[ "$(status_of "$f")" == "pending" ]] && pending_ids+=("$(basename "$f" .md)")
done
echo "pending: ${#pending_ids[@]} ${pending_ids[*]:-}"
[[ ${#pending_ids[@]} -gt 0 ]] && blocking=1

echo "== 자리표시 (${scope[*]}) =="
placeholders="$(grep -rnoE '\[OPEN-[0-9]+\]' "${scope[@]}" 2>/dev/null || true)"
if [[ -z "$placeholders" ]]; then
  echo "없음"
else
  while IFS= read -r line; do
    id="$(grep -oE 'OPEN-[0-9]+' <<<"${line##*:}")"
    loc="${line%:*}"
    f="records/open/$id.md"
    if [[ ! -f "$f" ]]; then
      echo "오류 - 끊긴 자리표시: $id ($loc)"
      blocking=1
    elif [[ "$(status_of "$f")" == "deferred" ]]; then
      echo "보류: $id ($loc)"
    else
      echo "미결: $id ($loc)"
      blocking=1
    fi
  done <<<"$placeholders"
fi

# 경로를 지정하지 않았으면 자리표시가 없는 open OPEN도 종료를 막는다.
if [[ $# -eq 0 && ${#open_ids[@]} -gt 0 ]]; then
  blocking=1
fi

echo "== 결과 =="
if [[ $blocking -eq 0 ]]; then
  echo "종료 가능"
else
  echo "종료 불가"
fi
exit $blocking
