---
status: draft
refs: []
---

# UI 규칙

- 토큰·컴포넌트·레이아웃의 값은 UI 패키지가 정본이다. 여기에는 값을 적지 않는다
- UI 패키지 경로: `docs/design/architecture.md`

## 토큰 사용 규칙

- <예: 색은 의미 토큰(color-danger 등)만 쓰고 원색 값을 직접 쓰지 않는다>

## 레이아웃 규칙

- <예: 페이지는 ui-container 안에 둔다. 브레이크포인트는 토큰의 bp-* 기준>

## 상태 표시 규칙

- 빈 상태: <ui-empty 사용, 다음 행동 버튼 포함>
- 로딩: <ui-spinner, 300ms 이상일 때만 표시>
- 오류: <ui-alert--danger, 다시 시도 버튼 포함>

## 문구 규칙

- <예: 버튼은 동사로 끝낸다. 용어는 glossary.md를 따른다>

## 예외

| 화면 | 예외 | 이유 |
|---|---|---|
