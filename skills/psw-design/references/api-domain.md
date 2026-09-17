---
status: draft
refs: []
---

# <도메인 이름> API

- 공통 규약: `_conventions.md`
- API마다 "### API-xxx-NNN <메서드> <경로>" 제목과 바로 아래 "- refs:" 줄을 둔다 (crosscheck.sh가 읽는다)

### API-XXX-NNN POST /<resources>

- refs: <FR-XXX-NNN, NFR-PERF-NNN>
- 허용 역할: <회원, 비회원> (`docs/req/actors.md`와 일치해야 한다)
- 멱등성: <있음 (Idempotency-Key 헤더) / 없음>
- 상태 전이: <Order: → PENDING_PAYMENT> (`state/<entity>.md`)

요청

| 필드 | 타입 | 필수 | 설명 (ERD 컬럼) |
|---|---|---|---|

응답 (<201>)

| 필드 | 타입 | 설명 (ERD 컬럼 또는 파생) |
|---|---|---|

오류

| HTTP | 코드 | 조건 |
|---|---|---|
