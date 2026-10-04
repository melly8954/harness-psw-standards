#!/usr/bin/env bash
# harness-psw를 프로젝트에 설치한다 (harness-psw.md 10.3).
# 사용법: bash install.sh <프로젝트 경로>
set -euo pipefail

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  echo "사용법: bash install.sh <프로젝트 경로>" >&2
  exit 1
fi
if [[ ! -d "$TARGET" ]]; then
  echo "프로젝트 경로가 없습니다: $TARGET" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"
if [[ "$TARGET" == "$HARNESS_DIR" ]]; then
  echo "하네스 저장소 자체에는 설치할 수 없습니다" >&2
  exit 1
fi

CLAUDE_DIR="$TARGET/.claude"
mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/scripts"

# 하네스가 소유한 파일만 교체한다. 프로젝트의 다른 스킬·에이전트·스크립트는 건드리지 않는다.
for skill in "$HARNESS_DIR"/skills/psw-*/; do
  [[ -d "$skill" ]] || continue
  name="$(basename "$skill")"
  rm -rf "${CLAUDE_DIR:?}/skills/$name"
  cp -R "$skill" "$CLAUDE_DIR/skills/$name"
  echo "스킬: $name"
done

# 하네스에서 없어진 psw-* 스킬은 지운다.
for installed in "$CLAUDE_DIR"/skills/psw-*/; do
  [[ -d "$installed" ]] || continue
  name="$(basename "$installed")"
  if [[ ! -d "$HARNESS_DIR/skills/$name" ]]; then
    rm -rf "${CLAUDE_DIR:?}/skills/$name"
    echo "스킬 삭제: $name (하네스에서 없어짐)"
  fi
done

for agent in "$HARNESS_DIR"/agents/*.md; do
  [[ -f "$agent" ]] || continue
  cp "$agent" "$CLAUDE_DIR/agents/"
  echo "에이전트: $(basename "$agent")"
done

if [[ -d "$HARNESS_DIR/scripts" ]]; then
  rm -rf "${CLAUDE_DIR:?}/scripts/psw"
  mkdir -p "$CLAUDE_DIR/scripts/psw"
  cp -R "$HARNESS_DIR/scripts/." "$CLAUDE_DIR/scripts/psw/"
  echo "스크립트: .claude/scripts/psw/"
fi

version="$(git -C "$HARNESS_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)"
echo "$version" > "$CLAUDE_DIR/psw-version"

echo "설치 완료 (harness-psw $version): $TARGET"
# 골격(CLAUDE.md)이 이미 있으면 다시 설치한 것이다. 골격과 프로젝트 설정은 그대로 둔다
if [[ -f "$TARGET/CLAUDE.md" ]]; then
  echo "다시 설치: 골격(CLAUDE.md, docs/)과 프로젝트 설정(settings.json, psw.conf, .githooks)은 바꾸지 않았다. 바뀐 .claude/를 커밋한다."
  # hook은 프로젝트 설정이라 덮어쓰지 않는다. 템플릿과 다르면 알린다 (프로젝트에서 고친 것일 수 있다)
  for hook in commit-msg pre-commit; do
    tmpl="$HARNESS_DIR/skills/psw-implement/templates/githooks/$hook"
    if [[ -f "$TARGET/.githooks/$hook" ]] && ! cmp -s "$tmpl" "$TARGET/.githooks/$hook"; then
      echo "알림: .githooks/$hook 이 템플릿과 다르다. 차이를 보고 필요하면 템플릿으로 바꾼다: skills/psw-implement/templates/githooks/$hook"
    fi
  done
else
  echo "다음: 프로젝트에서 psw-init 스킬로 골격을 만든다."
fi
