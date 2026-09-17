#!/usr/bin/env bash
# 설계 교차 검증의 스크립트 항목을 실행한다 (harness-psw 4.3, 10.5).
#   1  승인된 FR이 화면(ia, 목업) 또는 API에서 참조된다
#   2  NFR·SEC·INT가 설계 문서 어딘가에서 참조된다
#   3  목업 메타의 API ID가 API 문서에 있다
#   7  state 문서마다 ERD가 참조한다
#   8  목업이 components.md에 있는 클래스만 쓴다
#   10 화면·API의 refs가 비어 있지 않다
#   11 (경고) API가 쓰지 않는 테이블, 목업이 쓰지 않는 API
#   12 설계 문서가 참조하는 ID가 실제로 정의돼 있다
# 사용법: crosscheck.sh [도메인 코드]
#   도메인 코드(예: ORD)를 주면 항목 1, 3, 10, 12를 그 도메인 ID로 좁힌다
# 오류가 없으면 0, 있으면 1로 끝난다. 경고는 결과에 영향을 주지 않는다.
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "git 저장소 안에서 실행해야 합니다" >&2; exit 1; }
cd "$root"

domain="${1:-}"
D="docs/design"
R="docs/req"
errors=0
warnings=0

err()  { echo "  오류: $*"; errors=$((errors + 1)); }
warn() { echo "  경고: $*"; warnings=$((warnings + 1)); }
in_scope() { [[ -z "$domain" || "$1" == *"-${domain}-"* ]]; }
uniq_lines() { sed '/^$/d' | sort -u; }

# ---------- 정의 수집 ----------

fr_files="$(grep -rlE '^id:[[:space:]]*FR-' "$R/functional" 2>/dev/null || true)"
fr_all="$( [[ -n "$fr_files" ]] && grep -hE '^id:' $fr_files | grep -oE 'FR-[A-Z0-9]+-[0-9]+' | uniq_lines || true)"
fr_approved="$( [[ -n "$fr_files" ]] && grep -lE '^status:[[:space:]]*approved' $fr_files | xargs -r grep -hE '^id:' | grep -oE 'FR-[A-Z0-9]+-[0-9]+' | uniq_lines || true)"

area_ids="$(grep -rhoE '^\|[[:space:]]*(NFR|SEC|INT|DAT)-[A-Z0-9]+-[0-9]+' "$R/non-functional" "$R/security" "$R/integration" "$R/data" 2>/dev/null \
  | grep -oE '(NFR|SEC|INT|DAT)-[A-Z0-9]+-[0-9]+' | uniq_lines || true)"

con_ids="$(grep -hoE '^\|[[:space:]]*CON-[0-9]+' docs/srs/05-constraints.md 2>/dev/null | grep -oE 'CON-[0-9]+' | uniq_lines || true)"

scr_rows="$(grep -hE '^\|[[:space:]]*SCR-[A-Z0-9]+-[0-9]+[[:space:]]*\|' "$D/ui/ia.md" 2>/dev/null || true)"
scr_ids="$(grep -oE '^\|[[:space:]]*SCR-[A-Z0-9]+-[0-9]+' <<<"$scr_rows" | grep -oE 'SCR-[A-Z0-9]+-[0-9]+' | uniq_lines || true)"

# API: "### API-xxx-NNN ..." 제목과 그 아래 첫 "- refs:" 줄 → "ID<TAB>refs"
api_table="$(awk '
  /^### API-[A-Z0-9]+-[0-9]+/ {
    if (id != "") print id "\t" refs
    match($0, /API-[A-Z0-9]+-[0-9]+/); id = substr($0, RSTART, RLENGTH); refs = ""; seen = 0; next
  }
  /^#/ { if (id != "") print id "\t" refs; id = ""; next }
  id != "" && !seen && /^- refs:/ { sub(/^- refs:[[:space:]]*/, ""); refs = $0; seen = 1 }
  END { if (id != "") print id "\t" refs }
' "$D"/api/*.md 2>/dev/null || true)"
api_ids="$(cut -f1 <<<"$api_table" | uniq_lines || true)"

mockups="$(find "$D/ui/screens" -name '*.html' 2>/dev/null | sort || true)"
meta_field() { # meta_field <파일> <키>
  grep -m1 -E '<!--[[:space:]]*psw ' "$1" 2>/dev/null | tr '|' '\n' \
    | sed -nE "s/^[[:space:]]*(<!--[[:space:]]*psw[[:space:]]+)?$2:[[:space:]]*//p" | sed -E 's/[[:space:]]*-->.*$//; s/[[:space:]]*$//' || true
}

component_classes="$(grep -oE '`ui-[a-z0-9-]+`' "$D/ui/components.md" 2>/dev/null | tr -d '`' | uniq_lines || true)"

has_id() { grep -qxF "$1" <<<"$2"; }

# ---------- 1 ----------
echo "[1] 승인된 FR이 화면 또는 API에서 참조된다"
targets="$fr_approved"
if [[ -z "$targets" ]]; then
  echo "  (approved FR이 없어 전체 FR로 검사한다)"
  targets="$fr_all"
fi
while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  in_scope "$id" || continue
  grep -rqF "$id" "$D/api" "$D/ui" 2>/dev/null || err "$id 를 참조하는 화면·API 없음"
done <<<"$targets"

# ---------- 2 ----------
echo "[2] NFR·SEC·INT가 설계 문서에서 참조된다"
while IFS= read -r id; do
  [[ -z "$id" || "$id" == DAT-* ]] && continue
  grep -rqF "$id" "$D" 2>/dev/null || err "$id 를 참조하는 설계 문서 없음"
done <<<"$area_ids"

# ---------- 3, 10(목업) ----------
echo "[3] 목업 메타의 API ID가 API 문서에 있다 / [10] 목업 refs"
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  mid="$(meta_field "$f" id)"
  if [[ -z "$mid" ]]; then err "$f 메타 주석 없음"; continue; fi
  in_scope "$mid" || continue
  [[ -z "$(meta_field "$f" refs)" ]] && err "$mid ($f) refs 비어 있음"
  for aid in $(meta_field "$f" api | grep -oE 'API-[A-Z0-9]+-[0-9]+' || true); do
    has_id "$aid" "$api_ids" || err "$mid ($f) 가 없는 API $aid 를 참조"
  done
done <<<"$mockups"

# ---------- 7 ----------
echo "[7] state 문서마다 ERD가 참조한다"
for f in "$D"/state/*.md; do
  [[ -f "$f" ]] || continue
  name="state/$(basename "$f")"
  grep -qF "$name" "$D/database/erd.md" 2>/dev/null || err "ERD가 $name 를 참조하지 않음"
done

# ---------- 8 ----------
echo "[8] 목업이 components.md의 클래스만 쓴다"
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  used="$(grep -oE 'class="[^"]*"' "$f" | sed -E 's/^class="//; s/"$//' | tr ' ' '\n' \
    | grep -E '^ui-' | sed -E 's/(--|__).*$//' | uniq_lines || true)"
  while IFS= read -r c; do
    [[ -z "$c" ]] && continue
    has_id "$c" "$component_classes" || err "$f 가 components.md에 없는 클래스 $c 사용"
  done <<<"$used"
done <<<"$mockups"

# ---------- 10 ----------
echo "[10] 화면·API의 refs가 비어 있지 않다"
while IFS= read -r row; do
  [[ -z "$row" ]] && continue
  id="$(grep -oE 'SCR-[A-Z0-9]+-[0-9]+' <<<"$row" | head -1)"
  in_scope "$id" || continue
  refs="$(awk -F'|' '{print $(NF-1)}' <<<"$row" | tr -d '[:space:]')"
  [[ -z "$refs" ]] && err "$id (ia.md) refs 비어 있음"
done <<<"$scr_rows"
while IFS=$'\t' read -r id refs; do
  [[ -z "$id" ]] && continue
  in_scope "$id" || continue
  grep -qE '(FR|NFR|SEC|INT|DAT)-[A-Z0-9]+-[0-9]+' <<<"$refs" || err "$id refs 비어 있음"
done <<<"$api_table"

# ---------- 11 ----------
echo "[11] (경고) 쓰이지 않는 테이블·API"
for t in $(grep -hoE '^### [a-z0-9_]+[[:space:]]*$' "$D/database/erd.md" 2>/dev/null | sed -E 's/^### //; s/[[:space:]]*$//' || true); do
  grep -rqwF "$t" "$D/api" 2>/dev/null || warn "테이블 $t 를 언급하는 API 문서 없음"
done
all_meta_api="$(while IFS= read -r f; do [[ -n "$f" ]] && meta_field "$f" api; done <<<"$mockups" | grep -oE 'API-[A-Z0-9]+-[0-9]+' | uniq_lines || true)"
while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  has_id "$id" "$all_meta_api" || warn "$id 를 쓰는 목업 없음 (서버 전용 API면 무시)"
done <<<"$api_ids"

# ---------- 12 ----------
echo "[12] 참조한 ID가 정의돼 있다"
defined="$(printf '%s\n' "$fr_all" "$area_ids" "$con_ids" "$scr_ids" "$api_ids" | uniq_lines)"
refs_found="$(grep -rhoE '\b((FR|NFR|SEC|INT|DAT|SCR|API)-[A-Z0-9]+-[0-9]+|CON-[0-9]+)\b' "$D" 2>/dev/null | uniq_lines || true)"
while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  in_scope "$id" || [[ "$id" != FR-* && "$id" != SCR-* && "$id" != API-* ]] || continue
  has_id "$id" "$defined" || err "정의되지 않은 ID $id ($(grep -rlF "$id" "$D" | head -3 | tr '\n' ' '))"
done <<<"$refs_found"

echo "== 결과: 오류 $errors, 경고 $warnings =="
[[ $errors -eq 0 ]]
