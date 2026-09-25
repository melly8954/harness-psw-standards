---
name: psw-implement
description: harness-psw 구현 흐름을 진행한다. 승인된 FR마다 작업 폴더를 만들고 구현자(계약) → 검증자(AC 테스트 선작성) → 구현자 → 도구 검사 → 검토자 → 검증자(판정) → 병합 전 검사 → 사용자 확인 → 병합(AC 결과를 병합 커밋에) 순서로 하위 에이전트를 조율한다. 설계가 승인된 도메인의 구현을 시작할 때 사용한다.
---

# psw-implement

메인 세션이 오케스트레이터로 FR 단위 구현을 조율한다. 오케스트레이터는 직접 구현하지 않는다.

## 전제 (구현 착수 조건)

- 대상 FR 파일과 관련 설계 문서가 `approved`다
- 프로젝트별 결정이 채워져 있다 (`psw-design` 7단계)
  - `docs/design/conventions.md` 도구 절과 AC 테스트 절, `CLAUDE.md` 명령 표
  - `.claude/psw.conf`의 테스트 경로 패턴
  - 커밋 검사 hook 설정
- 하위 에이전트 `implementer`, `reviewer`, `verifier`가 `.claude/agents/`에 있다
- `.claude/settings.json`에 `guard-paths.sh` hook이 있다 (`psw-init`)

하나라도 없으면 멈추고 사용자에게 알린다.

## 규칙

- 동시에 진행하는 FR은 2개까지다
- FR 1개 = 브랜치 1개 = 작업 폴더 1개: `git worktree add .worktrees/<FR-ID> -b feat/<FR-ID>-<요약>`
- 테이블·API 문서는 없다. 계약(API 경로, 요청·응답 형식, 오류 코드, DB 마이그레이션)은 구현자가 코드로 먼저 쓰고, 검증자는 그 코드로 테스트를 쓴다 (harness-psw 4.2, 9.2)
- 검토자·검증자에게 구현자의 설명을 넘기지 않는다. 산출물과 원천 문서만 넘긴다
- 지적하는 쪽은 고치지 않는다. 수정은 항상 구현자가 한다
- 같은 AC가 3회 FAIL하면 멈추고 사용자에게 보고한다 (설계·요구사항 문제로 본다)
- 구현자·검증자가 "상위 결함"을 보고하면 흐름을 멈추고 `psw-change`로 해당 루프를 호출한다
  - 설계 결함(코드 규칙 포함) → 설계 루프 (`psw-design`), 요구사항 결함 → 기획 루프
- 공유 파일(라우트 등록, 테마 파일, UI 컴포넌트 코드, 앱 셸 코드. 경로는 `architecture.md` UI 절)은 병합 단계에서 오케스트레이터가 순서대로 반영한다
- DB 마이그레이션은 구현자가 작업 폴더에서 새 파일로 추가한다 (경로는 `architecture.md` 백엔드 절). 스키마가 없으면 AC 테스트를 돌릴 수 없기 때문이다
- MUST: 병합 전에 FR마다 사용자 확인을 받는다
- 병합은 병합 커밋(`--no-ff`)으로 한다. 개별 커밋을 유지하고 squash하지 않는다. 병합 커밋 본문에 AC 결과를 남긴다

## 준비 (프로젝트에서 처음 한 번)

1. 커밋 검사 도구가 harness 스크립트로 정해졌으면
   - `psw-design`의 `templates/githooks/commit-msg`를 `.githooks/commit-msg`로 복사한다
   - `git config core.hooksPath .githooks`
   - 다른 도구(commitlint 등)로 정했으면 그 도구 설정에서 `check-commit-msg.sh`와 같은 규칙을 적용한다
2. GitHub를 쓰면 `psw-design`의 `templates/github-workflow-psw.yml`을 `.github/workflows/psw.yml`로 복사할지 사용자에게 묻는다

## FR 흐름

### 1. 대상 선택

- `approved` FR 중 의존 순서가 앞선 것을 고른다 (`.claude/scripts/psw/rtm.sh`로 현황 확인)
- 작업 폴더와 브랜치를 만든다

### 2. 계약 (구현자)

- 서버 쪽 변경이 없는 FR(화면만 바뀌는 기능)이면 건너뛴다
- `implementer`를 "계약" 단계로 호출한다
- 넘길 것: 작업 폴더, 브랜치, FR 경로, 관련 `_policy.md` 경로
- 구현자는 `docs/design/conventions.md` REST·DB 절을 따라 컨트롤러 시그니처, 요청·응답 형식, 새 오류 코드, DB 마이그레이션을 쓰고 동작은 비워 둔다

### 3. AC 테스트 작성 (검증자)

- `verifier`를 "테스트 작성" 단계로 호출한다
- 넘길 것: 작업 폴더, FR 경로, 관련 `_policy.md` 경로, 관련 화면 경로 (`find-refs.sh <FR-ID>`로 찾는다), 계약 커밋
- 검증자는 AC 테스트 작성법을 `docs/design/conventions.md` AC 테스트 절에서, 테스트 위치를 `architecture.md` 백엔드 절에서 읽는다

### 4. 구현 (구현자)

- `implementer`를 "구현" 단계로 호출한다
- 넘길 것: 작업 폴더, 브랜치, FR 경로, 관련 `_policy.md`·화면 경로, 이전 반복의 지적·실패 내용
- "중단" 보고면 사유에 따라 규칙대로 처리한다

### 5. 도구 검사

- 작업 폴더에서 lint·타입 검사를 실행한다 (`CLAUDE.md` 명령)
- 실패하면 4단계로 돌아간다

### 6. 코드 검토 (검토자)

- diff를 뽑는다: `git -C .worktrees/<FR-ID> diff <기준 브랜치>...HEAD`
- `reviewer`를 "코드 검토"로 호출한다. 넘길 것: diff 전문, FR 경로, 관련 `_policy.md`·화면 경로
- CHANGES면 지적을 구현자에게 넘겨 4단계로 돌아간다

### 7. 검증 (검증자)

- `verifier`를 "검증" 단계로 호출한다
- FAIL이면 실패 AC를 구현자에게 넘겨 4단계로 돌아간다. AC별 FAIL 횟수를 센다

### 8. 병합 전 검사

- `.claude/scripts/psw/check-role-paths.sh <기준 브랜치>..feat/<FR-ID>`
- 브랜치의 각 커밋: `.claude/scripts/psw/check-commit-msg.sh --commit <커밋>`
- 실패하면 원인을 고친다. 역할 위반이면 해당 커밋을 되돌리고 올바른 역할이 다시 작업한다

### 9. 사용자 확인

아래 형식으로 요청한다.

```text
[병합 확인] <FR-ID> <제목>
- 변경 파일: N개 (코드 n, 테스트 n)
- AC 결과: AC-1 PASS(테스트) / AC-2 PASS(직접 검증) / AC-3 FAIL [SHOULD] 사유: ...
- 검토 지적: N건 → 처리 결과
- 통합 요청: <공유 파일 변경 목록 또는 없음>
- 남은 미결: <없음 또는 목록>
→ 병합할까요?
```

### 10. 병합과 정리

1. 통합 요청이 있으면 공유 파일을 반영한다. 커밋 트레일러에 `Refs: <FR-ID>`
   - DB 마이그레이션 버전이 기준 브랜치와 겹치면 FR 브랜치 쪽 파일 번호를 올리고 테스트를 다시 돌린다
2. 기준 브랜치에 병합 커밋으로 병합한다: `git merge --no-ff feat/<FR-ID>-<요약>`
   - 본문에 검증자의 AC 결과를 적는다. `rtm.sh`가 `<FR-ID> AC-`로 찾는다

```text
Merge branch 'feat/FR-ORD-010-guest-checkout'

FR-ORD-010 AC-1 [MUST] PASS 테스트: FR-ORD-010 AC-1: 비회원 주문 생성
FR-ORD-010 AC-2 [MUST] PASS 직접 확인: 주문 완료 화면 안내 문구
FR-ORD-010 AC-3 [SHOULD] FAIL 직접 확인: SMS 발송. 사유: SMS 키 미준비

Refs: FR-ORD-010
```

3. 작업 폴더를 지운다: `git worktree remove .worktrees/<FR-ID>`
4. 병합으로 바뀐 코드가 다른 FR에 영향을 주는지 `find-refs.sh`로 찾고, 영향받은 FR의 직접 검증 AC를 다시 검증한다
   → AC 테스트 코드가 있는 AC는 CI·테스트 실행이 다시 확인한다

## 보고

- FR마다: 결과, 반복 횟수, 남은 SHOULD 미충족
- 도메인이 끝나면: `rtm.sh <도메인>` 결과
