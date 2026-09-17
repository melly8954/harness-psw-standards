#!/usr/bin/env bash
# 다음 ID를 출력한다 (harness-psw 1.2, 10.5).
# 삭제된 ID도 git 이력에서 찾아 재사용하지 않는다.
# 사용법: next-id.sh <종류>
#   기록:     OPEN | CR | DEC
#   요구사항: FR-<도메인> | NFR-<영역> | SEC-<영역> | INT-<시스템> | DAT-<영역> | CON
#   설계:     SCR-<도메인> | API-<도메인>
set -euo pipefail

type="${1:-}"
dir=""
case "$type" in
  OPEN) dir="records/open";      width=3 ;;
  CR)   dir="records/changes";   width=3 ;;
  DEC)  dir="records/decisions"; width=4 ;;
  CON)  width=3 ;;
  *)
    if [[ "$type" =~ ^(FR|NFR|SEC|INT|DAT|SCR|API)-[A-Z0-9]+$ ]]; then
      width=3
    else
      echo "사용법: next-id.sh OPEN|CR|DEC|CON|FR-<코드>|NFR-<코드>|SEC-<코드>|INT-<코드>|DAT-<코드>|SCR-<코드>|API-<코드>" >&2
      exit 1
    fi
    ;;
esac

root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "git 저장소 안에서 실행해야 합니다" >&2; exit 1; }
cd "$root"

pattern="\b${type}-[0-9]+"

# 현재 문서, 삭제된 파일 이름, 과거 문서 내용(지운 줄 포함), 커밋 메시지에서 가장 큰 번호를 찾는다.
max="$(
  {
    grep -rhoE "$pattern" docs records 2>/dev/null || true
    if [[ -n "$dir" ]]; then
      ls "$dir" 2>/dev/null || true
      git log --all --format= --name-only -- "$dir" 2>/dev/null || true
    else
      git log --all --format= -p -- docs 2>/dev/null || true
    fi
    git log --all --format=%B 2>/dev/null || true
  } | grep -oE "$pattern" | sed "s/^${type}-//" | sort -n | tail -1 || true
)"
max="${max:-0}"

printf '%s-%0*d\n' "$type" "$width" "$((10#$max + 1))"
