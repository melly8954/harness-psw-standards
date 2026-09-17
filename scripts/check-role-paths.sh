#!/usr/bin/env bash
# Role 트레일러가 있는 커밋이 역할에 허용된 경로만 바꿨는지 검사한다 (harness-psw 9.4, 10.5).
# 병합 전이나 CI에서 실행한다.
# 사용법: check-role-paths.sh <범위>   (예: main..HEAD)
# 통과하면 0, 아니면 1.
set -uo pipefail

range="${1:?범위를 지정한다 (예: main..HEAD)}"
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "git 저장소 안에서 실행해야 합니다" >&2; exit 1; }
cd "$root"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

status=0
checked=0
for c in $(git rev-list --reverse "$range"); do
  role="$(git log -1 --format=%B "$c" | git interpret-trailers --parse | sed -nE 's/^Role:[[:space:]]*//p' | head -1)"
  [[ -z "$role" ]] && continue
  checked=$((checked + 1))
  mapfile -t files < <(git diff-tree --no-commit-id --name-only -r --root "$c")
  [[ ${#files[@]} -eq 0 ]] && continue
  if ! out="$(bash "$here/guard-paths.sh" check "$role" "${files[@]}")"; then
    echo "$(git log -1 --format='%h %s' "$c") [Role: $role]"
    sed 's/^/  /' <<<"$out"
    status=1
  fi
done

echo "Role 커밋 ${checked}개 검사, $([[ $status -eq 0 ]] && echo 통과 || echo 위반 있음)"
exit $status
