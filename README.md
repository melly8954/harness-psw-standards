# agent-harness-standards

에이전트가 문서를 정본 삼아 기획 → 설계 → 구현을 진행하도록 돕는 하네스 **harness-psw**의 정본 저장소다.

## 정본 관계

| 대상 | 정본 |
|---|---|
| 하네스 규칙 | [`harness-psw.md`](harness-psw.md) (설계서) |
| 스킬·에이전트·스크립트 | 설계서를 근거로 만든 구현물 |
| 프로젝트 내용 | 각 프로젝트의 `docs/` |

- 스킬과 설계서가 다르면 설계서가 맞다. 스킬을 설계서에 맞춰 고친다
- 규칙을 바꿀 때는 설계서를 먼저 고친다
- 설계서는 프로젝트에 복사하지 않는다. 프로젝트는 설치된 스킬, 에이전트, `CLAUDE.md`로 규칙을 받는다

## 구성

```text
harness-psw.md    설계서
install.sh        프로젝트 설치 스크립트
skills/psw-*/     스킬 (SKILL.md, references/, templates/)
agents/           하위 에이전트
scripts/          검사 스크립트
```

## 설치

전역에 설치하지 않는다. 필요한 프로젝트에만 설치한다.

```bash
bash install.sh <프로젝트 경로>
```

- `.claude/skills/psw-*/`, `.claude/agents/`, `.claude/scripts/psw/`에 복사한다
- 다시 실행하면 하네스가 소유한 파일만 교체한다
- 설치 후 프로젝트에서 `psw-init` 스킬로 골격을 만든다

## 구축 현황

| 구성 | 상태 |
|---|---|
| 설계서 | 완료 |
| `install.sh`, `psw-init` | 완료 |
| `psw-change` | 예정 |
| `psw-interview`, `psw-srs`, `psw-req` | 예정 |
| `psw-design`, `psw-crosscheck` | 예정 |
| `psw-implement`, 에이전트 3종 | 예정 |
| 검사 스크립트 | 예정 |
