#!/usr/bin/env bash
# SRS의 요구사항 ID와 REQ가 1:1로 맞는지 확인한다 (harness-psw 3.2, 3.3, 10.5).
#   - SRS에 있는데 REQ에 없는 ID
#   - REQ에 있는데 SRS에 없는 ID
#   - 같은 ID가 REQ에 두 번 이상 정의됨
# 제약사항(CON)은 SRS만 소유하므로 검사하지 않는다.
# 맞으면 0, 아니면 1로 끝난다.
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "git 저장소 안에서 실행해야 합니다" >&2; exit 1; }
cd "$root"

id_re='(FR|NFR|SEC|INT|DAT)-[A-Z0-9]+-[0-9]+'

# SRS: 요구사항 표의 첫 칸
srs_ids="$(grep -rhE "^\|[[:space:]]*${id_re}[[:space:]]*\|" docs/srs/04-requirements 2>/dev/null \
  | grep -oE "^\|[[:space:]]*${id_re}" | grep -oE "$id_re" | sort || true)"

# REQ: FR 파일의 frontmatter id, 영역 파일 표의 첫 칸 (README는 파생 목록이므로 제외)
fr_ids="$(grep -rhE "^id:[[:space:]]*FR-" docs/req/functional 2>/dev/null | grep -oE "$id_re" || true)"
area_ids="$(grep -rhE "^\|[[:space:]]*${id_re}[[:space:]]*\|" docs/req/non-functional docs/req/security docs/req/integration docs/req/data 2>/dev/null \
  | grep -oE "^\|[[:space:]]*${id_re}" | grep -oE "$id_re" || true)"
req_ids="$(printf '%s\n%s\n' "$fr_ids" "$area_ids" | sed '/^$/d' | sort)"

fail=0

only_srs="$(comm -23 <(sort -u <<<"$srs_ids") <(sort -u <<<"$req_ids") | sed '/^$/d')"
only_req="$(comm -13 <(sort -u <<<"$srs_ids") <(sort -u <<<"$req_ids") | sed '/^$/d')"
dup_req="$(uniq -d <<<"$req_ids" | sed '/^$/d')"

echo "SRS: $(sed '/^$/d' <<<"$srs_ids" | wc -l | tr -d ' ')개, REQ: $(sed '/^$/d' <<<"$req_ids" | wc -l | tr -d ' ')개"
if [[ -n "$only_srs" ]]; then
  echo "REQ에 없음:"; sed 's/^/  /' <<<"$only_srs"; fail=1
fi
if [[ -n "$only_req" ]]; then
  echo "SRS에 없음:"; sed 's/^/  /' <<<"$only_req"; fail=1
fi
if [[ -n "$dup_req" ]]; then
  echo "REQ에 중복 정의:"; sed 's/^/  /' <<<"$dup_req"; fail=1
fi
[[ $fail -eq 0 ]] && echo "일치"
exit $fail
