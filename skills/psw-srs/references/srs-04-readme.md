# 요구사항 목록

## 도메인 코드

| 코드 | 이름 | 파일 | 요구사항 ID 접두사 |
|---|---|---|---|
| <ORD> | <주문> | `<order>.md` | `FR-<ORD>-` |

## 영역 코드

| 접두사 | 영역 | 파일 | REQ 파일 |
|---|---|---|---|
| `NFR-PERF-` | 성능 | `non-functional.md` | `docs/req/non-functional/performance.md` |

## 규칙

- 코드는 이 표에서만 정의한다 (harness-psw 1.2)
- ID 번호는 `.claude/scripts/psw/next-id.sh <접두사>`로 발급한다 (예: `next-id.sh FR-ORD`)
- 삭제한 요구사항의 ID는 다시 쓰지 않는다
- 제약사항(`CON-`)은 `../05-constraints.md`에 둔다
