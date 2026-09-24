---
name: psw-change
description: harness-psw 피드백 루프를 처리한다. 미결(OPEN) 등록·해결·보류, 승인된 내용의 변경 요청(CR) 작성·수락·거절, 결정 기록(DEC) 작성, 영향 분석, 루프 종료 조건 확인에 사용한다. 기획·설계·구현 어느 단계에서든 모르는 것이나 바꿔야 할 것을 발견하면 호출한다.
---

# psw-change

피드백 루프의 공통 절차다. 기획·설계·구현 스킬은 이 절차를 복사하지 않고 이 스킬을 호출한다.

## 무엇을 쓰는가

| 상황 | 기록 |
|---|---|
| `draft` 문서를 고친다 | 기록 없음. 결정이 끼면 DEC만 |
| 아직 정해지지 않은 것(누락·모호)을 발견했다 | OPEN |
| 승인된(`approved`, SRS 기준선) 내용을 바꾸거나 없애야 한다 (모순, 실현 불가능, 사용자 번복) | CR |
| OPEN의 답으로 승인된 문서에 내용을 추가한다 | CR 없이 반영하고 문서를 `draft`로 되돌린다 |

## 공통 규칙

- MUST: 결정, CR 수락·거절, OPEN 보류 수용은 사용자만 정한다. 에이전트는 초안과 선택지만 만든다
- MUST: 모르는 것은 추측하지 않고 OPEN으로 등록한다
- MUST: 하위 단계에서 상위 문서를 고치지 않는다. 상위 문서 반영은 그 문서의 소유 스킬 절차를 따른다
  - SRS: `psw-srs`, REQ: `psw-req`, 설계: `psw-design`
  - 소유 스킬이 아직 설치되지 않았으면 이 스킬에서 직접 반영하고, 그 사실을 보고한다
- ID는 `.claude/scripts/psw/next-id.sh OPEN|CR|DEC`로 발급한다. 직접 번호를 매기지 않는다
- 파일 형식은 `references/open.md`, `references/cr.md`, `references/dec.md`를 따른다
- 대화에서 사용자의 답을 받으면 원문을 `records/interviews/YYYY-MM-DD.md`에 남긴다. 형식은 `psw-interview`의 `references/interview.md`를 따른다

## 절차

### A. OPEN 등록

1. `next-id.sh OPEN`으로 ID를 받는다
2. `records/open/OPEN-NNN.md`를 작성한다 (`status: open`)
3. 원천 문서의 해당 위치에 `[OPEN-NNN]` 자리표시를 넣는다
   - 그 문서가 `approved`였다면 `status: draft`로 되돌린다
4. 보고: ID, 질문, 자리표시 위치

### B. OPEN 해결

1. 사용자에게 질문한다. 선택지와 추천안을 함께 제시한다
2. 답을 인터뷰 기록에 남긴다
3. `next-id.sh DEC`로 ID를 받아 DEC 초안을 작성하고, 사용자 확인을 받는다
   - `source`에 `OPEN-NNN`과 인터뷰 파일을 적는다
4. 원천 문서의 자리표시를 값과 근거로 바꾼다 (예: `동시 로그인: 1기기 (DEC-0012)`)
   - `approved` 문서였다면 `status: draft`로 되돌린다
5. `records/open/OPEN-NNN.md`를 삭제한다
6. 커밋 트레일러: `Decision: DEC-NNNN`, `Closes: OPEN-NNN`, 관련 요구사항이 있으면 `Refs:`

### C. OPEN 보류 수용

1. 사용자가 "지금 정하지 않고 진행한다"고 정했을 때만 한다
2. `status: deferred`로 바꾸고 보류 사유와 날짜를 적는다
3. 자리표시는 그대로 둔다

### D. CR 작성

1. 변경 대상이 정말 승인된 내용인지 확인한다. `draft`면 CR 없이 고친다
2. `next-id.sh CR`로 ID를 받는다
3. 영향 범위를 찾는다 (F 절차)
4. `records/changes/CR-NNN.md`를 작성한다 (`status: pending`)
5. 작업 중이던 단계는 멈추고, 사용자에게 CR 검토를 요청한다

### E. CR 처리

사용자가 수락 또는 거절을 정한다.

- 수락
  1. DEC를 작성한다. `source`에 `CR-NNN`을 적는다
  2. 영향 범위의 문서를 소유 스킬 절차로 반영한다. 반영한 `approved` 문서는 `draft`로 되돌린다
  3. 기존 결정을 뒤집는 경우 옛 DEC에 `status: superseded`, `superseded_by`를 적고, 새 DEC에 `supersedes`를 적는다
  4. `records/changes/CR-NNN.md`를 삭제한다
  5. 커밋 트레일러: `CR: CR-NNN`, `Decision: DEC-NNNN`, `Refs:`
- 거절
  1. `status: rejected`로 바꾸고 반려 사유와 날짜를 적는다
  2. 파일은 남긴다
     → 같은 요청이 다시 올라올 때 근거가 된다

### F. 영향 분석

1. 바뀌는 ID로 `.claude/scripts/psw/find-refs.sh <ID...>`를 실행한다
   - 계열 전체를 보려면 접두사만 준다 (예: `FR-ORD-`)
2. 설계가 바뀌는 경우 아래 경로도 확인한다

| 바뀐 것 | 다시 볼 곳 |
|---|---|
| ERD (테이블, 컬럼) | 해당 필드를 쓰는 API 문서, state 문서 |
| state (상태, 전이) | 상태 전이를 유발하는 API, 해당 목업 |
| API | 목업 메타에서 그 API ID를 쓰는 화면, 관련 AC 테스트와 검증 기록 |
| 컴포넌트, 테마 | 해당 컴포넌트를 쓰는 목업 (`data-component`로 찾는다) |
| 연동 | 실패 처리를 반영한 API, state 문서 |

3. 결과를 ID와 경로 목록으로 정리한다. 다시 산출하거나 검토할 문서만 고른다

### G. 종료 조건 확인

1. `.claude/scripts/psw/loop-status.sh [경로...]`를 실행한다
   - 경로를 주지 않으면 `docs` 전체와 모든 OPEN을 본다
   - 설계 루프를 도메인 단위로 끝낼 때는 해당 도메인 문서 경로를 준다
2. "종료 가능"이 나와야 루프를 끝낸다
   - 막는 것: `open` OPEN, `pending` CR, 끊긴 자리표시
   - 막지 않는 것: `deferred` OPEN, `rejected` CR
3. 결과를 사용자에게 보고한다

## 단계 사이 루프

| 발견한 단계 | 발견한 결함 | 호출할 루프 |
|---|---|---|
| 설계 | 요구사항 결함 | 기획 (SRS → REQ 순서로 반영) |
| 설계 (백엔드 기초) | 키트 문서 조각의 REQ 초안 | 기획 (SRS 근거를 확인하고 REQ로 만든다. 근거가 없으면 SRS부터. 초안은 참고로만 쓴다) |
| 구현 | 설계 결함 | 설계 |
| 구현 | 요구사항 결함 | 기획 |

- 발견한 단계의 작업은 멈추고, 상위 루프가 끝난 뒤 돌아간다
- 같은 불일치가 설계 루프에서 2회, 구현에서 같은 AC가 3회 반복되면 사용자에게 보고한다
