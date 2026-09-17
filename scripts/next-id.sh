#!/usr/bin/env bash
# 다음 OPEN·CR·DEC ID를 출력한다 (harness-psw 1.2, 10.5).
# 삭제된 ID도 git 이력에서 찾아 재사용하지 않는다.
# 사용법: next-id.sh OPEN|CR|DEC
set -euo pipefail

type="${1:-}"
case "$type" in
  OPEN) dir="records/open";      width=3 ;;
  CR)   dir="records/changes";   width=3 ;;
  DEC)  dir="records/decisions"; width=4 ;;
  *) echo "사용법: next-id.sh OPEN|CR|DEC" >&2; exit 1 ;;
esac

root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "git 저장소 안에서 실행해야 합니다" >&2; exit 1; }
cd "$root"

# 현재 파일, 삭제된 파일 이름, 커밋 메시지, 문서 속 참조에서 가장 큰 번호를 찾는다.
max="$(
  {
    ls "$dir" 2>/dev/null || true
    git log --all --format= --name-only -- "$dir" 2>/dev/null || true
    git log --all --format=%B 2>/dev/null || true
    grep -rhoE "\b${type}-[0-9]+" docs records 2>/dev/null || true
  } | grep -oE "\b${type}-[0-9]+" | sed "s/^${type}-//" | sort -n | tail -1
)"
max="${max:-0}"

printf '%s-%0*d\n' "$type" "$width" "$((10#$max + 1))"
