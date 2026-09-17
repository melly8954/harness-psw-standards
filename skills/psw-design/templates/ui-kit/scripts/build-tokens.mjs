// tokens.json을 CSS 변수로 변환한다 (harness-psw 4.5).
// 의존성 없이 Node만으로 실행한다: node scripts/build-tokens.mjs
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const tokens = JSON.parse(readFileSync(join(root, 'tokens/tokens.json'), 'utf8'));

// { color: { primary: { value } } } → --color-primary
const lines = [];
const walk = (node, path) => {
  if (node && typeof node === 'object' && 'value' in node) {
    lines.push(`  --${path.join('-')}: ${node.value};`);
    return;
  }
  for (const [key, child] of Object.entries(node)) walk(child, [...path, key]);
};
walk(tokens, []);

const css = `/* 자동 생성 파일이다. tokens/tokens.json을 고치고 다시 빌드한다. */\n:root {\n${lines.join('\n')}\n}\n`;

mkdirSync(join(root, 'dist'), { recursive: true });
writeFileSync(join(root, 'dist/tokens.css'), css);
console.log(`dist/tokens.css: ${lines.length}개 토큰`);
