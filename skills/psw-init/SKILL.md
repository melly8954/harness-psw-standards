---
name: psw-init
description: harness-psw 프로젝트 골격(CLAUDE.md, docs/, records/, glossary.md, .env.example, .gitignore)을 만든다. 새 프로젝트에 harness-psw를 처음 적용할 때 사용한다.
---

# psw-init

프로젝트에 harness-psw 문서 골격을 만든다. 문서 내용은 쓰지 않는다.

## 전제

- `install.sh`로 이 스킬이 설치된 프로젝트 루트에서 실행한다
- 템플릿은 이 스킬의 `templates/`에 있다

## 절차

### 1. 상태 확인

- git 저장소가 아니면 사용자에게 `git init` 여부를 묻는다
- 아래 경로 중 이미 있는 것을 확인한다
  - `CLAUDE.md`, `docs/`, `records/`, `.env.example`, `.gitignore`
- MUST: 이미 있는 파일은 덮어쓰지 않는다. 목록을 보고하고 진행 여부를 묻는다
  - 예외: `.gitignore`는 5단계 규칙으로 블록만 추가한다

### 2. 사용자에게 묻기

- 프로젝트명
- 한 줄 요약
  - 아직 정하지 못했으면 `(인터뷰 후 작성)`으로 두고, `psw-srs`가 SRS 개요를 쓴 뒤 갱신한다

### 3. 디렉터리 생성

아래 디렉터리를 만들고, 빈 디렉터리에는 `.gitkeep`을 둔다.

```text
docs/srs/
docs/req/
docs/design/
docs/ops/
records/decisions/
records/changes/
records/open/
records/interviews/
records/references/
records/verifications/
```

- `docs/design/` 아래 하위 폴더는 `psw-design`이 필요할 때 만든다

### 4. 템플릿 복사

| 템플릿 | 대상 | 처리 |
|---|---|---|
| `templates/CLAUDE.md.tmpl` | `CLAUDE.md` | `{{PROJECT_NAME}}`, `{{SUMMARY}}`를 2단계 답으로 바꾼다 |
| `templates/glossary.md` | `docs/glossary.md` | 그대로 복사 |
| `templates/env.example` | `.env.example` | 그대로 복사 |

### 5. `.gitignore`

- 없으면 `templates/gitignore`를 `.gitignore`로 복사한다
- 있으면 `# harness-psw` 블록이 없을 때만 `templates/gitignore` 내용을 끝에 추가한다

### 6. 확인

- 3~5단계의 결과 경로가 모두 있는지 확인한다
- `CLAUDE.md`에 `{{`가 남아 있지 않은지 확인한다

### 7. 보고

- 생성한 파일과 디렉터리 목록
- 건너뛴 파일과 이유
- 다음 단계: `psw-interview`로 기획 인터뷰를 시작한다
- 커밋은 사용자 승인 후에 한다. 메시지 예: `chore: harness-psw 골격 생성`

## 하지 않는 것

- hook·CI 설정
  → 커밋 검사 도구가 프로젝트별 결정 항목(harness-psw 1.5)이므로 구현 착수 전에 설정한다
- SRS, REQ, 설계 문서 작성
- 기존 파일 덮어쓰기
