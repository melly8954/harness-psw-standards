---
status: draft
refs: []
---

# API 공통 규약

<!-- API 문서마다 반복하지 않는 규칙 -->

## 기본

- 기본 경로: <예: /api/v1>
- 형식: <예: JSON, UTF-8>
- 이름 규칙: <예: 경로는 kebab-case 복수형, 필드는 camelCase>

## 인증

- <헤더와 방식. 예: Authorization: Bearer <token>>

## 오류 응답

```json
{ "code": "<ERROR_CODE>", "message": "<사용자에게 보여줄 문장>" }
```

| HTTP | 코드 | 의미 |
|---|---|---|
| 400 | VALIDATION_FAILED | 입력 검증 실패 |
| 401 | UNAUTHORIZED | 인증 필요 |
| 403 | FORBIDDEN | 권한 없음 |
| 404 | NOT_FOUND | 대상 없음 |
| 409 | INVALID_STATE | 현재 상태에서 할 수 없는 요청 |

## 페이징

- <예: page, size 파라미터, 응답에 total>

## 버전

- <예: 경로에 버전. 호환되지 않는 변경은 새 버전>
