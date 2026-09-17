---
name: psw-srs
description: harness-psw 요구사항 정의서(SRS)를 작성·검토·개정하고, 사용자 승인 후 기준선 태그와 PDF를 만든다. 인터뷰가 끝나 SRS를 쓸 때, 누락 검사를 할 때, 승인된 SRS에 변경을 반영할 때 사용한다.
---

# psw-srs

`docs/srs/`를 쓴다. SRS는 요구가 존재한다는 사실과 범위만 소유한다. 상세는 `psw-req`가 REQ에 쓴다.

## 입력과 출력

| 입력 | 출력 |
|---|---|
| `records/interviews/`, `records/references/` | `docs/srs/` |
| DEC (개정 시) | 기준선 태그 `srs-vX.Y` (사용자 승인 후) |
| | `exports/srs-vX.Y.pdf` |

## 규칙

- 템플릿: `references/srs-*.md`
- 인터뷰 기록에 없는 내용을 지어내지 않는다. 비어 있으면 `psw-change` 절차 A로 OPEN을 등록하고 `[OPEN-NNN]` 자리표시를 둔다
- 요구사항은 ID + 한 줄 + 우선순위만 적는다. 흐름, 예외, 수용 기준은 적지 않는다
- 요구사항 ID는 `.claude/scripts/psw/next-id.sh <접두사>`로 발급한다 (예: `next-id.sh FR-ORD`, `next-id.sh NFR-PERF`, `next-id.sh CON`)
- 도메인·영역 코드는 `04-requirements/README.md`에만 정의한다
- 기능을 나눌 때 기능 크기 기준을 적용한다
  - 기능 1개 = 사용자가 독립적으로 시작하고 끝내는 행위 1개
  - 나누는 경우: 트리거가 다름, 수용 기준을 따로 판정할 수 있음, 외부 연동이 달라 실패 흐름이 다름, 우선순위·릴리스 시점이 다름
  - 기능으로 만들지 않고 정책으로 두는 경우: 사용자 행위가 아닌 규칙·수치, 둘 이상의 기능이 같이 참조함 → `psw-req`가 `_policy.md`에 쓴다
- 우선순위: `must` / `should` / `could` / `won't`
- MUST: 기준선 태그는 사용자 승인 후에만 만든다
- MUST: 기준선 이후에는 SRS를 직접 고치지 않는다. `psw-change`(CR 또는 OPEN 해결)를 거쳐 반영한다

## 절차

### 1. 작성

1. 인터뷰 기록과 레퍼런스를 읽는다
2. 없으면 `docs/srs/`에 템플릿으로 파일을 만든다
   - `srs-readme.md` → `README.md`
   - `srs-01-overview.md` → `01-overview.md` (이하 02, 03, 05 같은 방식)
   - `srs-04-readme.md` → `04-requirements/README.md`
   - `srs-04-list.md` → `04-requirements/<domain>.md`, `non-functional.md`, `security.md`, `integration.md`, `data.md` (필요한 것만)
3. 도메인·영역 코드를 먼저 정해 `04-requirements/README.md`에 적는다
4. 인터뷰 답을 각 파일에 옮긴다
   - "해당 없음"으로 답한 체크리스트 항목은 `02-scope.md`의 해당 없음 표에 ID와 사유를 적는다
   - 레퍼런스에서 제외한 기능은 `02-scope.md`의 범위 밖에 적는다
5. 템플릿의 `(ck-...)` 표시는 작성이 끝나면 지워도 된다

### 2. 검토 (누락 검사)

1. `.claude/scripts/psw/checklist-coverage.sh`를 실행한다
   - 누락이 있으면 `psw-interview`로 다시 묻는다 (피드백 루프 트리거: 누락)
2. `.claude/scripts/psw/loop-status.sh docs/srs`를 실행한다
3. 요구사항 목록을 스스로 점검한다
   - 한 줄에 행위가 둘 이상 섞여 있지 않은가
   - 측정할 수 없는 비기능 표현(빠르게, 적절히 등)이 없는가. 있으면 OPEN
   - `03-actors.md`의 역할이 요구사항에 모두 쓰이는가

### 3. 승인과 기준선

1. 2단계가 모두 통과하면 사용자에게 승인을 요청한다
   - 요약: 도메인·영역별 요구사항 수, 우선순위 분포, 보류(`deferred`) OPEN, 범위 밖 항목
2. 사용자가 승인하면
   1. 커밋한다
   2. 태그를 만든다: 첫 승인은 `srs-v1.0`, 이후 MINOR를 올린다. MAJOR는 사용자가 정할 때만 올린다
      - `git tag -a srs-vX.Y -m "SRS vX.Y: <요약>"`
   3. `srs/README.md`의 도구로 PDF를 만든다
      - 도구가 정해지지 않았으면 사용자에게 정하게 하고(프로젝트별 결정), DEC로 남긴다
      - 태그 시점의 파일로 만든다: `git worktree` 또는 `git archive`로 태그 내용을 꺼내 변환한다
      - 출력: `exports/srs-vX.Y.pdf` (`psw-init`이 `.gitignore`에 `exports/`를 넣는다. 없으면 추가한다)
3. 다음 단계: `psw-req`로 REQ를 파생한다

### 4. 개정 (기준선 이후)

1. `psw-change`가 DEC를 만들고 반영을 요청하면, DEC의 영향 항목만 고친다
   - 요구사항 추가: 새 ID 발급
   - 요구사항 삭제: 줄을 지운다. ID는 다시 쓰지 않는다
2. 2단계 검토를 다시 한다
3. 3단계로 재승인을 받고 MINOR를 올린다
4. `psw-req`에 바뀐 ID 목록을 넘겨 부분 재생성을 요청한다

## 커밋

- 최초 작성: `Refs:`에 새로 만든 도메인·영역 접두사 (예: `Refs: FR-ORD, FR-AUTH, NFR-PERF`)
- 개정: `Decision: DEC-NNNN`, 해당하면 `CR:`, `Closes:`, `Refs:`
- 메시지 예: `docs: SRS 초안 작성`, `docs: SRS v1.1 비회원 주문 반영`
