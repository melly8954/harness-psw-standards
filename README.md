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

## 관련 저장소

- [`harness-psw-front`](https://github.com/melly8954/harness-psw-front) (비공개): 프론트 키트. 테마, 목업 템플릿, 컴포넌트 목록, 프레임워크별 적용 절차. `psw-design`이 태그를 골라 가져온다

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
| 스킬 8종 (`psw-init`, `psw-interview`, `psw-srs`, `psw-req`, `psw-design`, `psw-crosscheck`, `psw-implement`, `psw-change`) | 완료 |
| 에이전트 3종 (`implementer`, `reviewer`, `verifier`) | 완료 |
| 검사 스크립트 12종 | 완료 |
| 실제 프로젝트 적용 검증 | 예정 (설계서 10.4) |

## 승인

- 문서 승인은 사용자가 직접 한다: `! bash .claude/scripts/psw/approve.sh <경로>`
- 에이전트의 승인 시도는 `psw-init`이 설정한 hook이 막는다
