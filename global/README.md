# 전역 진입 문서 (현행)

사용자 레벨 `~/.claude/`의 현행 사본이다. 그 경로는 git 추적 밖이고
`~/.claude/backups/`도 비어 있어, 유실되면 복구 수단이 없다.

```
CLAUDE.md   ~/.claude/CLAUDE.md      매 세션 자동 로드되는 전역 진입 규칙
harness/    ~/.claude/harness/       v0 스킬이 하드 참조하는 공통 규칙 — 자동 로드 안 됨
```

v0 시점의 판본은 `legacy/global/`이 소유한다. 두 판본의 차이는
`## 하네스 사용` 절 하나이며, 나머지 절(규칙 우선순위·컨텍스트 로딩·
기준 문서 관리·작업 기준·금지 사항)은 세대와 무관하게 유효하다.

## 갱신 규칙

`~/.claude/`를 고치면 여기로 다시 떠온다. 여기서 고치면 갈라진다 —
자동 로드되는 것은 `~/.claude/CLAUDE.md`이고 이 사본은 로드되지 않는다.

```bash
cp ~/.claude/CLAUDE.md global/CLAUDE.md
cp ~/.claude/harness/*.md global/harness/
```
