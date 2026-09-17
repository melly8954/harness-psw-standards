---
name: psw-req
description: 승인된 harness-psw SRS에서 요구사항 상세(REQ)를 파생한다. 기능별 FR 파일, 도메인 정책(_policy.md), 비기능·보안·연동·데이터 영역 파일, 역할·권한 매트릭스, README 인덱스를 만들고, SRS 개정 시 바뀐 ID만 다시 만든다. SRS 기준선이 생긴 뒤 REQ를 작성하거나 갱신할 때 사용한다.
---

# psw-req

`docs/req/`를 쓴다. REQ는 SRS에 있는 요구의 상세(흐름, 예외, 수용 기준, 기준 수치)를 소유한다.

## 입력과 출력

| 입력 | 출력 |
|---|---|
| `docs/srs/` (기준선 태그가 있는 상태) | `docs/req/README.md` |
| `records/interviews/`, DEC | `docs/req/functional/<domain>/` (README, `_policy.md`, FR 파일) |
| 바뀐 ID 목록 (개정 시) | `docs/req/non-functional/`, `security/`, `integration/`, `data/` |
| | `docs/req/actors.md` |

## 규칙

- 템플릿: `references/*.md`
- 전제: `git tag -l "srs-v*"` 결과가 있어야 한다. 없으면 `psw-srs` 승인부터 받는다
- SRS에 없는 요구를 만들지 않는다. 필요해 보이면 `psw-change`로 OPEN을 등록한다
  → 하위 문서에서 상위 결정을 만들지 않는다
- SRS를 고치지 않는다. SRS의 요구를 나누거나 합쳐야 하면 `psw-change`로 보낸다
- 상세를 모르면 추측하지 않고 `[OPEN-NNN]` 자리표시를 둔다
- 파일 구성
  - SRS의 기능 요구 1줄 = FR 파일 1개. 파일 이름은 행위를 나타내는 영어 kebab-case (예: `guest-checkout.md`)
  - FR 파일 제목은 SRS의 한 줄 요구와 같게 쓴다
  - 우선순위는 FR 파일에 적지 않는다 (SRS가 소유)
  - 둘 이상의 기능이 같이 쓰는 규칙·수치는 `_policy.md`에만 적고, FR은 항목 이름으로 참조한다
  - 비기능·보안·연동·데이터는 영역별 파일 1개에 표로 담는다. 파일 이름은 `04-requirements/README.md`의 영역 코드 표를 따른다
- 수용 기준
  - 기능마다 1개 이상, 확인할 수 있는 한 문장으로 쓴다
  - 강도는 `[MUST]` 또는 `[SHOULD]`만 쓴다. MAY는 쓰지 않는다
  - 화면으로만 확인할 수 있는 기준과 API·데이터로 확인할 수 있는 기준을 섞지 않고 나눠 쓴다
    → 검증 방법이 달라진다 (harness-psw 5.2)
- 영역 항목의 기준은 측정할 수 있는 수치로 쓴다
- 적용 범위
  - `전체`: 영역 파일에만 둔다. `req/README.md`의 전체 적용 목록은 영역 파일에서 다시 만든다
  - `개별`: 해당 FR 파일의 `refs`에만 적는다
- 역할별 권한은 `actors.md`에만 적는다. FR의 행위자에는 주 흐름을 수행하는 주체만 적는다
- `approved`로는 바꾸지 않는다. 승인은 사용자가 한다

## 절차

### 1. 전체 파생 (처음)

1. SRS의 `03-actors.md`, `04-requirements/`를 읽는다
2. 영역 파일을 만든다 (`references/area.md`)
3. 도메인마다
   1. `functional/<domain>/` 폴더를 만든다
   2. 공유 규칙이 있으면 `_policy.md`를 만든다 (`references/policy.md`)
   3. 기능 요구마다 FR 파일을 만든다 (`references/fr.md`)
   4. 도메인 `README.md`를 만든다 (`references/domain-readme.md`)
4. `actors.md`를 만든다 (`references/actors.md`)
5. `req/README.md`를 만든다 (`references/req-readme.md`)
   - 전체 적용 목록: 영역 파일에서 적용 범위가 `전체`인 행을 모은다

### 2. 부분 재생성 (SRS 개정 후)

1. `psw-srs`나 `psw-change`가 넘긴 바뀐 ID만 다룬다
2. 추가된 ID: 1단계와 같이 만든다
3. 바뀐 ID: 해당 파일을 고친다. `approved`였으면 `draft`로 되돌린다
4. 삭제된 ID: 해당 FR 파일이나 표의 행을 지운다
   - 지우기 전에 `.claude/scripts/psw/find-refs.sh <ID>`로 설계·테스트 참조를 확인하고, 참조가 있으면 보고한다
5. 도메인 README, `actors.md`, `req/README.md`의 전체 적용 목록을 다시 만든다

### 3. 점검

1. `.claude/scripts/psw/req-sync.sh`를 실행한다. SRS와 REQ의 ID가 1:1이어야 한다
2. `.claude/scripts/psw/loop-status.sh docs/req`를 실행한다
3. 스스로 점검한다
   - FR마다 수용 기준이 있고, `[MUST]`가 하나 이상 있는가
   - `refs`의 ID가 영역 파일에 있는가
   - `_policy.md`의 값이 FR 본문에 다시 적혀 있지 않은가
   - `actors.md`에 모든 FR과 SRS의 모든 역할이 있는가

### 4. 승인 요청

1. 도메인 단위로 승인을 요청할 수 있다
   - 요약: 도메인별 FR 수, 남은 OPEN(`deferred` 포함), 정책 항목 수
2. 사용자가 승인한 파일만 `status: approved`가 된다
   - 승인은 사용자가 입력창에서 직접 실행한다: `! bash .claude/scripts/psw/approve.sh docs/req/functional/<domain>`
   - 에이전트의 승인 시도는 hook이 막는다
   - 승인 커밋 트레일러: `Refs: <도메인 접두사>`
3. 다음 단계: `psw-design`

## 커밋

- 최초 작성: `Refs:`에 도메인·영역 접두사 (예: `Refs: FR-ORD, NFR-PERF`)
- 갱신: `Refs:`에 바뀐 ID, 결정이 있으면 `Decision:`
- 메시지 예: `docs: 주문 도메인 REQ 파생`
