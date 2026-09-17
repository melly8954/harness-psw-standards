# UI 패키지

토큰, 레이아웃, 공통 컴포넌트의 정본이다 (harness-psw 4.5).
목업(`docs/design/ui/screens/`)과 프론트 코드가 모두 여기서 스타일을 가져간다.

## 구성

| 경로 | 내용 |
|---|---|
| `tokens/tokens.json` | 토큰 정본 |
| `scripts/build-tokens.mjs` | `tokens.json` → `dist/tokens.css` |
| `css/base.css` | 기본 스타일 |
| `css/layout.css` | 레이아웃 프리미티브 (`ui-container`, `ui-stack`, `ui-cluster`, `ui-grid`) |
| `css/components.css` | 공통 컴포넌트 클래스 (`ui-` 접두사) |
| `ui.css` | 위 파일을 모두 불러오는 진입점. 목업은 이 파일을 링크한다 |

## 빌드

```bash
node scripts/build-tokens.mjs
```

- `tokens.json`을 고친 뒤 실행한다
- `dist/`는 빌드 결과다. 목업을 빌드 없이 열어보려면 커밋한다

## 규칙

- 값은 `tokens.json`에만 둔다. CSS에는 `var(--...)`만 쓴다
- 새 컴포넌트는 `css/components.css`에 추가하고 `docs/design/ui/components.md`에 적는다
- 클래스 이름: 블록 `ui-<이름>`, 변형 `ui-<이름>--<변형>`, 요소 `ui-<이름>__<요소>`
- 기술 스택의 UI 라이브러리를 쓰면 이 컴포넌트 클래스 대신 라이브러리 컴포넌트를 `components.md`에 대응시킨다
