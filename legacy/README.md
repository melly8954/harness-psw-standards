# v0 하네스 (보존본)

문서 1종당 스킬 1개 구조의 **1세대 하네스**다. 사용자 레벨(`~/.claude/`)에만 존재해
git 추적 밖이었고 복구 수단이 없었으므로 여기에 정본으로 보존한다.

`skills/`의 활성 7종(`harness-init` 계열)이 후속 세대다. **신규 구축에는 v0를 쓰지 않는다.**

## 왜 지우지 않았는가

신세대가 v0를 완전히 덮지 않는다. 절차는 신세대가 낫고, 도메인 심층 규칙은 v0에만 있다.

| 영역 | v0 | 신세대 | 판정 |
|---|---|---|---|
| 조사→계획→초안→검토→승인→반영 워크플로 | 스킬마다 개별 절차 | `harness-init` 고정 6단계 | 신세대 우위 |
| 하네스 구축 | `harness-bootstrap` | `harness-init`·`scan`·`plan` | 대체됨 |
| 하네스 감사·재구축 | `harness-audit` (감사만) | `harness-rebuild` (병합·이동·폐기후보) | 대체됨 |
| 정본 관리 | 없음 (사용자 레벨 사본이 유일본) | git 저장소 | 신세대 우위 |
| 화면·UI·접근성·반응형 | `app-design` | 없음 | **미대체** |
| 도메인 심층 규칙 | API 항목 기준·상태변경 API·엔터티 항목 기준 등 | 템플릿 15~23줄 | **얇아짐** |
| testing·operations·security | 없음 | 템플릿 보유 | 신세대만 |

미대체 항목은 신세대 템플릿·reference로 승격할 후보다. 승격이 끝난 항목은 이 표에서 지운다.

## 구성

```
skills/          v0 스킬 9종
global/CLAUDE.md v0 전역 진입 문서 (~/.claude/CLAUDE.md 사본)
global/harness/  v0 공통 실행 규칙·문서 체계
```

`global/`의 문서는 `skills/` 9종을 진입 규칙으로 참조한다. 셋은 한 세트이므로
일부만 설치하면 참조가 끊긴다.

## v0에 의존하는 프로젝트

v0 산출물을 이미 가진 저장소다. 신세대로 이전하기 전까지 v0가 필요하다.

| 저장소 | 보유 산출물 | 필요 스킬 |
|---|---|---|
| Re-Echo | prd · architecture · erd · api · app-design · coding-convention · decisions | 9종 전부 |
| masilmap-app | prd · architecture · api | prd-design · architecture-design · api-design · decisions-sync |
| G-ReBO | coding-convention · decisions | coding-convention-design · decisions-sync |

## 사용법

v0는 사용자 레벨에 설치하지 않는다 — 모든 프로젝트에 걸려 다른 방법론과 섞인다.
필요한 저장소의 `.claude/skills/`에만 둔다.

```bash
mkdir -p <프로젝트>/.claude/skills
cp -r legacy/skills/<스킬명> <프로젝트>/.claude/skills/
```

프로젝트 사본이 이 정본과 갈라지면 다시 복사한다. v0는 개정하지 않는다 —
고칠 것이 생기면 신세대에 반영한다.
