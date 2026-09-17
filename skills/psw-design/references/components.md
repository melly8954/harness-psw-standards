---
status: draft
refs: []
---

# 공통 컴포넌트

<!-- 목업은 이 표에 있는 클래스만 쓴다 (crosscheck.sh가 읽는다). 새 컴포넌트는 UI 패키지에 먼저 추가하고 여기에 적는다 -->

| 컴포넌트 | 클래스 | 코드 경로 | 용도 | 변형 | 상태 | 쓰지 말아야 할 경우 |
|---|---|---|---|---|---|---|
| Button | `ui-button` | <구현 후 경로> | 행동 실행 | `--primary`, `--secondary`, `--danger`, `--sm` | 기본, 비활성, 로딩 | 페이지 이동만 할 때 (링크 사용) |
| Field | `ui-field` | | 라벨·입력·오류 묶음 | | 기본, 오류 | |
| Input | `ui-input` | | 한 줄 입력 | | 기본, 비활성, 오류 | |
| Select | `ui-select` | | 목록에서 하나 선택 | | 기본, 비활성, 오류 | 선택지가 3개 이하일 때 (라디오) |
| Checkbox | `ui-checkbox` | | 켜기·끄기 | | 기본, 비활성 | |
| Card | `ui-card` | | 내용 묶음 | | | |
| Table | `ui-table` | | 목록 데이터 | | | |
| Badge | `ui-badge` | | 상태 표시 | `--success`, `--warning`, `--danger` | | |
| Alert | `ui-alert` | | 안내·오류 메시지 | `--info`, `--danger` | | |
| Modal | `ui-modal` | | 확인·짧은 입력 | | 열림 | 긴 입력 (별도 화면) |
| Empty | `ui-empty` | | 빈 상태 | | | |
| Spinner | `ui-spinner` | | 로딩 | | | |
| Container | `ui-container` | | 페이지 폭 제한 | | | |
| Stack | `ui-stack` | | 세로 간격 | | | |
| Cluster | `ui-cluster` | | 가로 나열 | | | |
| Grid | `ui-grid` | | 격자 배치 | | | |
