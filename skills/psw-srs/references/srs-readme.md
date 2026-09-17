# 요구사항 정의서 (SRS)

이 폴더가 SRS의 정본이다. PDF는 기준선 태그 시점에 여기서 만든다.

## 파일

| 파일 | 내용 |
|---|---|
| `01-overview.md` | 배경, 대상 사용자, 목표, 성공 기준, 레퍼런스 |
| `02-scope.md` | 범위 안, 범위 밖, MVP, 해당 없음 |
| `03-actors.md` | 사용자 역할 목록 |
| `04-requirements/` | 요구사항 목록 (ID + 한 줄 + 우선순위). 코드표는 `04-requirements/README.md` |
| `05-constraints.md` | 제약사항 |

## 기준선

- 승인된 기준선은 git 태그 `srs-vMAJOR.MINOR`다. 목록: `git tag -l "srs-v*"`
- 기준선 이후의 변경은 `psw-change`(CR 또는 OPEN)를 거친다

## PDF

- 생성 도구: <프로젝트별 결정. 예: pandoc>
- 생성 명령: <프로젝트별 결정>
- 출력: `exports/srs-vX.Y.pdf` (커밋하지 않음)
