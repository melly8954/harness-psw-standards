---
status: draft
refs: []
---

# 정보 구조 (IA)

## 화면 목록

<!-- 행 형식은 crosscheck.sh가 읽는다. refs가 비면 안 된다 -->

| ID | 이름 | 경로 | 접근 역할 | refs |
|---|---|---|---|---|
| SCR-XXX-NNN | <주문서> | </checkout> | <회원, 비회원> | <FR-ORD-001> |

- ID는 라우트가 아니라 사용자가 보는 화면 단위다. 모달과 단계형 폼의 각 단계도 화면이다

## 메뉴 계층

```text
<홈>
├─ <상품>
└─ <마이페이지>
   └─ <주문 내역>
```

## 화면 흐름

```mermaid
flowchart LR
  A[SCR-XXX-001] --> B[SCR-XXX-002]
```
