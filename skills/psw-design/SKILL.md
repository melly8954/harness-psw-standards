---
name: psw-design
description: 승인된 harness-psw REQ를 근거로 설계 문서를 작성한다. 아키텍처·보안 설계, UI 기초(프론트 키트의 테마·컴포넌트 적용, IA), 도메인별 ERD·상태 전이·API·연동·HTML 목업, 구현 착수 전 프로젝트별 결정(도구·경로)을 채운다. REQ가 승인된 도메인의 설계를 시작하거나 설계를 고칠 때 사용한다.
---

# psw-design

`docs/design/`, 프론트 테마·컴포넌트, `docs/conventions.md`를 쓴다.

UI는 디자인을 새로 만들지 않는다. 프론트 키트(`harness-psw-frontend`)의 테마와 컴포넌트를 가져와 쓴다.

## 입력과 출력

| 입력 | 출력 |
|---|---|
| `approved` REQ (도메인 단위) | `docs/design/` 설계 문서, HTML 목업 |
| SRS `05-constraints.md` (기술 스택) | 프론트 테마와 컴포넌트 (프론트 키트에서 가져옴) |
| 프론트 키트 (`harness-psw-frontend`, 태그) | `docs/design/ui/components.md` |
| DEC (설계 결정) | `docs/conventions.md`, `CLAUDE.md` 명령 (구현 준비) |

## 규칙

- 전제: SRS 기준선 태그가 있고, 설계할 도메인의 REQ가 `approved`다
- 템플릿: `references/*.md`
- 프론트 키트
  - 저장소: `https://github.com/melly8954/harness-psw-frontend.git` (비공개). 로컬 사본 `C:\psw\github\harness-psw-frontend`가 있으면 그 경로를 써도 된다
  - 목업 템플릿, 컴포넌트 조각, 기본 컴포넌트 목록, 프레임워크별 적용 절차는 키트가 소유한다. 하네스에 복사해 두지 않는다
- 순서: 아키텍처 → UI 기초 → DB · API · 화면. DB · API · 화면은 맞물려 진행하고 교차 검증으로 맞춘다
- 문서 축
  - 전역: `architecture.md`, `security.md`, `database/erd.md`, `ui/ia.md`, `ui/ui-rules.md`, `ui/components.md`, `api/_conventions.md`
  - 도메인별: `api/<domain>.md`, `ui/screens/<domain>/`
  - 외부 시스템별: `integration/<system>.md`
  - 엔터티별: `state/<entity>.md` (상태가 3개 이상이거나, 시간·외부 이벤트로 상태가 바뀌는 엔터티)
- 모든 설계 문서의 frontmatter에 `status`와 `refs`(근거 요구사항 ID)를 적는다
- 다른 문서가 정본인 값은 옮겨 적지 않고 참조한다
  - 상태값: `state/<entity>.md` / 테마·컴포넌트: 프론트 코드 (경로는 `architecture.md` UI 절) / 정책 수치: `_policy.md` / 역할별 권한: `docs/req/actors.md`
  - 예외: API 문서의 허용 역할은 적는다. 어긋남은 교차 검증으로 잡는다
- 교차 검증 스크립트가 읽는 형식을 지킨다 (각 템플릿의 주석 참고)
  - `ia.md` 화면 목록 행, 목업 첫 줄 메타 주석, API 제목과 `- refs:` 줄, ERD의 `### <테이블>` 제목, 목업의 `data-component`와 `components.md` 첫 열
- ID는 `.claude/scripts/psw/next-id.sh SCR-<도메인>`, `next-id.sh API-<도메인>`으로 발급한다
- 요구사항에 결함이 있으면 설계에서 고치지 않는다. `psw-change`로 기획 루프를 호출한다
- 모르는 것은 `psw-change`로 OPEN을 등록한다
- 프로젝트별 결정(도구, 경로)은 사용자가 정하고 DEC로 남긴다
- `approved`로는 바꾸지 않는다

## 절차

### 1. 아키텍처 (전역, 첫 도메인에서 만들고 이후 갱신)

1. `05-constraints.md`의 기술 스택과 적용 NFR·SEC를 읽는다
2. `architecture.md`, `security.md`를 쓴다
3. 프로젝트별 결정: 프론트 키트의 프레임워크, 태그, 테마를 사용자에게 정하게 하고 DEC로 남긴다
   - 키트에 없는 프레임워크면 멈추고 알린다. 키트에 프레임워크를 먼저 추가한다

### 2. UI 기초 (전역, 첫 도메인에서 만들고 이후 갱신)

1. 프론트 키트를 고른 태그로 임시 폴더에 가져온다
   - 권장: 가장 최근 태그. 키트는 검증을 마친 커밋에만 태그를 단다
   - 조회: `git ls-remote --tags --sort=-v:refname <키트 저장소> 'v*'`. 태그마다 바뀐 점은 태그 메시지에 있다
   - `git clone --depth 1 --branch <태그> <키트 저장소> <임시 폴더>`
2. 키트의 `web/frameworks/<프레임워크>/README.md` 절차를 따른다
   - 프레임워크 초기화, UI 라이브러리 초기화, 테마 적용, 컴포넌트 추가
   - 절차가 정한 테마 파일과 컴포넌트 코드 경로를 `architecture.md` UI 절에 적는다. 구현자는 이 경로를 공유 파일로 보고 고치지 않는다
   - 키트의 `web/components.md`를 `docs/design/ui/components.md`로 복사하고, 쓰지 않을 컴포넌트는 뺀다
3. `ui/ui-rules.md`를 쓴다
   - 커스터마이즈는 테마 변수로만 한다. 컴포넌트 코드의 스타일을 직접 바꾸지 않는다
4. `ui/ia.md`에 화면 목록, 메뉴 계층, 화면 흐름을 쓴다
   - 화면 ID는 사용자가 보는 화면 단위다. 모달과 단계형 폼의 각 단계도 화면이다

### 3. 도메인 설계

1. `database/erd.md`에 도메인 테이블을 추가한다
2. 상태가 있는 엔터티는 `state/<entity>.md`를 쓰고, ERD의 상태 컬럼이 이 문서를 참조하게 한다
3. `api/_conventions.md`(없으면)와 `api/<domain>.md`를 쓴다
4. 외부 연동이 있으면 `integration/<system>.md`를 쓰고, 실패 처리를 API 오류나 상태 전이에 반영한다
5. 화면마다 `ui/screens/<domain>/<screen>.html` 목업을 만든다
   - 만드는 방법은 키트의 `web/mockup/README.md`를 따른다. 키트는 `architecture.md`에 적은 태그로 가져온다
   - 첫 줄은 메타 주석이다. `crosscheck.sh`가 읽는 형식이라 바꾸지 않는다
     `<!-- psw id: SCR-ORD-001 | refs: FR-ORD-001 | api: API-ORD-001, API-ORD-003 | status: draft -->`
   - 컴포넌트는 키트 조각을 그대로 쓰고, 컴포넌트를 쓴 요소에 `data-component`를 단다
   - 기본, 빈 상태, 로딩, 오류 네 가지 상태를 채운다
   - `components.md`에 있는 컴포넌트만 쓴다. 새 컴포넌트가 필요하면 `components.md`에 먼저 추가하고 프로젝트에 컴포넌트를 추가한다

### 4. 교차 검증

- `psw-crosscheck`를 실행한다. 불일치가 없어질 때까지 3단계와 반복한다

### 5. 승인 요청 (도메인 단위)

1. `.claude/scripts/psw/loop-status.sh docs/design`으로 종료 조건을 확인한다
2. 사용자에게 도메인 설계 승인을 요청한다
   - 요약: 화면 수, API 수, 추가·변경한 테이블, 상태 전이 문서, 남은 OPEN, 교차 검증 결과
   - 목업은 파일 경로를 알려 사용자가 브라우저로 열어보게 한다. 여는 데 필요한 조건(인터넷 연결 등)은 키트 `web/mockup/README.md`를 보고 함께 알린다
3. 승인은 사용자가 입력창에서 직접 실행한다: `! bash .claude/scripts/psw/approve.sh <설계 문서·목업 경로>`
   - 에이전트의 승인 시도는 hook이 막는다
4. 승인 시점의 모양을 남겨야 하면 목업 스크린샷을 `records/`에 저장한다
5. 키트의 조각과 설치한 컴포넌트의 클래스가 다르면 키트를 고치도록 사용자에게 알린다

### 6. 구현 준비 (구현 착수 전 한 번)

1. 프로젝트별 결정을 사용자와 정하고 각각 DEC로 남긴다
   - 시크릿 저장소 도구 → `architecture.md` 배포 단위
   - lint, 포맷, 커밋 검사, 시크릿 스캔, AC 테스트 도구 → `docs/conventions.md` (`references/conventions.md`에서 시작)
     - 커밋 검사 도구의 기본안은 하네스 스크립트(`check-commit-msg.sh`)다. 스택과 상관없이 동작한다
   - 개발 서버, lint, AC 테스트 명령 → `CLAUDE.md` 명령 표
   - AC 테스트 파일 경로 → `.claude/psw.conf`의 `PSW_TEST_GLOBS` (`templates/psw.conf`에서 시작)
     → 역할별 경로 검사가 이 패턴으로 테스트 파일을 가린다
2. 커밋 검사 hook과 CI는 `psw-implement` 준비 단계에서 설정한다 (`templates/githooks/`, `templates/github-workflow-psw.yml`)
3. 다음 단계: `psw-implement`

## 커밋

- 트레일러: `Refs:`에 근거 요구사항 ID, 결정이 있으면 `Decision:`
- 메시지 예: `docs: 주문 도메인 API·목업 설계`
