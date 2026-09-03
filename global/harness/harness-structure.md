# Harness Structure

전역 하네스와 프로젝트 기준 문서가 사용하는 표준 구조와 책임을 정의한다.

이 문서는 하네스 초기화, 전체 감사, 구조 변경 또는 경로 확인이 필요한 경우에만 읽는다.

## 1. 전역 하네스 구조

```text
~/.claude/
├─ CLAUDE.md
├─ harness/
│  ├─ common-execution-rules.md
│  └─ harness-structure.md
└─ skills/
   ├─ prd-design/
   │  └─ SKILL.md
   ├─ architecture-design/
   │  └─ SKILL.md
   ├─ erd-design/
   │  └─ SKILL.md
   ├─ api-design/
   │  └─ SKILL.md
   ├─ app-design/
   │  └─ SKILL.md
   ├─ coding-convention-design/
   │  └─ SKILL.md
   ├─ decisions-sync/
   │  └─ SKILL.md
   ├─ harness-bootstrap/
   │  └─ SKILL.md
   └─ harness-audit/
      └─ SKILL.md
```

### 책임

- `CLAUDE.md`: 전역 진입점, 규칙 우선순위와 컨텍스트 라우팅
- `common-execution-rules.md`: 모든 스킬의 공통 읽기·수정·검증 원칙
- `harness-structure.md`: 지원 경로와 루트·상세 문서 구조
- `skills/*/SKILL.md`: 문서 영역별 설계·수정·검증 절차

프로젝트의 실제 제품과 기술 결정은 전역 하네스에 기록하지 않는다.

## 2. 기본 프로젝트 구조

새 프로젝트는 기본적으로 루트 기준 문서만 준비한다.

```text
프로젝트/
├─ CLAUDE.md
└─ docs/
   ├─ prd.md
   ├─ Architecture.md
   ├─ ERD.md
   ├─ API.md
   ├─ app-design.md
   ├─ coding-convention.md
   └─ decisions.md
```

모든 프로젝트에 모든 문서를 강제하지 않는다.

프로젝트 성격상 필요하지 않은 문서는 제외할 수 있으며 제외 이유와 대체 기준을 `CLAUDE.md`에 기록한다.

## 3. 확장 프로젝트 구조

문서가 커져 선택적 로딩이 어려운 경우에만 상세 디렉터리를 추가한다.

```text
프로젝트/
├─ CLAUDE.md
└─ docs/
   ├─ prd.md
   ├─ prd/
   │  └─ <feature>.md
   ├─ Architecture.md
   ├─ architecture/
   │  └─ <concern>.md
   ├─ ERD.md
   ├─ erd/
   │  ├─ common.md
   │  └─ <domain>.md
   ├─ API.md
   ├─ api/
   │  ├─ common.md
   │  └─ <domain>.md
   ├─ app-design.md
   ├─ app-design/
   │  ├─ common.md
   │  └─ <flow>.md
   ├─ coding-convention.md
   ├─ conventions/
   │  └─ <area>.md
   ├─ decisions.md
   └─ decisions/
      └─ DEC-<number>-<topic>.md
```

상세 디렉터리는 선택 사항이며 빈 디렉터리를 미리 만들지 않는다.

## 4. 문서별 분리 기준

| 루트 문서 | 상세 디렉터리 | 분리 기준 |
| --- | --- | --- |
| `prd.md` | `prd/` | 제품 기능과 정책 |
| `Architecture.md` | `architecture/` | 인증·실시간·배포 등 기술 관심사 |
| `ERD.md` | `erd/` | 데이터 도메인과 공통 데이터 규칙 |
| `API.md` | `api/` | API 비즈니스 도메인과 공통 계약 |
| `app-design.md` | `app-design/` | 사용자 흐름과 화면 묶음 |
| `coding-convention.md` | `conventions/` | 백엔드·프론트·DB·테스트 등 구현 영역 |
| `decisions.md` | `decisions/` | 기록이 많아진 경우 개별 결정 |

작은 문서는 단일 파일로 유지한다.

## 5. 루트 문서 역할

루트 기준 문서는 다음을 담당한다.

- 문서 목적과 전체 범위
- 전 영역에 공통인 기준
- 상세 문서의 경로와 짧은 설명
- 상세 문서 선택 로딩 안내
- 전체 수준의 미확정 사항과 변경 영향

루트 문서가 인덱스로 전환되어도 전체 판단에 필요한 핵심 기준까지 제거하지 않는다.

## 6. 상세 문서 역할

상세 문서는 현재 영역에 직접 필요한 내용만 가진다.

- 기능 또는 도메인의 상세 정책
- 기술 관심사의 처리 흐름
- 데이터 모델과 제약
- API 계약
- 화면과 상호작용 상태
- 구현 영역의 코딩 규칙
- 개별 결정의 배경과 영향

공통 내용을 루트나 공통 문서와 중복해서 정의하지 않는다.

## 7. 파일명 규칙

- 루트 기준 문서의 기존 대소문자는 프로젝트 규칙을 우선한다.
- 새 상세 문서는 소문자 kebab-case를 기본으로 한다.
- 결정 상세 파일은 `DEC-<number>-<topic>.md` 형식을 사용한다.
- 같은 이름의 `api.md`, `erd.md`를 여러 도메인 폴더에 반복 생성하지 않는다.
- 파일 이동이나 대소문자 변경이 Git·CI·운영체제에 영향을 주면 자동 변경하지 않는다.

## 8. 프로젝트 CLAUDE.md 역할

프로젝트 `CLAUDE.md`에는 다음만 기록한다.

- 전역 규칙과 프로젝트 규칙의 우선순위
- 실제 기준 문서와 경로
- 작업별 선택 로딩 순서
- 프로젝트 전용 금지 사항
- 구현 전 확인 사항
- 검증 명령과 완료 조건
- 문서 변경 시 동기화 대상

공통 실행 규칙과 각 스킬의 세부 절차를 복사하지 않는다.

## 9. 구조 변경 원칙

- 기존 구조를 무조건 표준 구조로 이동하지 않는다.
- 같은 목적의 문서가 다른 경로에 있으면 호환 가능성을 먼저 검토한다.
- 문서를 분리할 때 내용의 의미와 결정 원천을 보존한다.
- 상세 문서 생성·이동·삭제 시 루트 인덱스를 갱신한다.
- 기존 외부 링크, CI, 스크립트와 문서 참조에 미치는 영향을 확인한다.
- 전체 구조 변경 후 `harness-audit`으로 경로와 정합성을 검증한다.
