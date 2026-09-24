---
status: draft
refs: []
---

# 아키텍처

<!-- 전역 문서. 도메인 설계가 추가될 때마다 갱신한다 -->

## 구성도

```mermaid
flowchart LR
  client[클라이언트] --> api[API 서버]
  api --> db[(DB)]
```

## 구성 요소

| 구성 요소 | 책임 | 기술 |
|---|---|---|

## 기술 스택

| 영역 | 선택 | 근거 |
|---|---|---|
| <프론트엔드> | <기술> | CON-NNN |

## 모듈 경계와 의존 방향

- <모듈 목록과 허용하는 의존 방향. 예: ui → application → domain, domain은 아무것도 의존하지 않는다>

## UI

- 프론트 키트: `harness-psw-frontend` <태그>, 테마 <이름>, 프레임워크 <이름> (DEC-NNNN)
- 테마 파일: <예: app/theme.css>
- 컴포넌트 코드: <예: components/ui/>
- 셸: <형태, 예: 사이드바형>, 설정 <예: 왼쪽 · 아이콘만 남김 · 벽에 붙음 · 펼침> (DEC-NNNN). 목업 셸 `ui/shell.js`
- 셸 코드: <예: components/app-sidebar.tsx, app/layout.tsx>

## 백엔드

- 백엔드 키트: `harness-psw-backend` <태그>, 프레임워크 <이름>, 헬퍼 <목록 또는 없음>, 패키지 <이름> (DEC-NNNN)
- 코드 루트: <예: backend/>
- 공유 파일: <예: backend/src/main/resources/db/migration/ (DB 마이그레이션)>. 구현자는 고치지 않고 통합 요청으로 보고한다
- 테스트 위치: <예: backend/src/test/>. `.claude/psw.conf`의 `PSW_TEST_GLOBS`에 넣는다

## 배포 단위

| 단위 | 대상 | 비고 |
|---|---|---|

- 시크릿 저장소: <프로젝트별 결정> (DEC-NNNN)

## 적용 요구사항

- <아키텍처로 해결하는 NFR·SEC·INT ID와 방법>

## 금지·제약

- <예: 도메인 계층에서 외부 SDK를 직접 호출하지 않는다>
