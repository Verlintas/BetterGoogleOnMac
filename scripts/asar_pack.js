// 将目录打包为 asar（Electron 默认应用包格式，与官方字节兼容）
// Pack a directory into asar (byte-compatible with the official Electron format)
const fs = require('fs');
const path = require('path');

const srcDir = process.argv[2];
const outFile = process.argv[3];

const files = [];
function walk(dir, prefix) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    const rel = prefix ? `${prefix}/${entry.name}` : entry.name;
    if (entry.isDirectory()) walk(full, rel);
    else files.push({ rel, full, size: fs.statSync(full).size });
  }
}
walk(srcDir, '');

const ordered = files.sort((a, b) => a.rel.localeCompare(b.rel));
let offset = 0;
const fileMap = {};
for (const f of ordered) {
  fileMap[f.rel] = { size: f.size, offset: String(offset) };
  offset += f.size;
}

const jsonBuf = Buffer.from(JSON.stringify({ files: fileMap }), 'utf8');
const jsonBytes = jsonBuf.length;
const headBytes = 16 + jsonBytes;
const pad = (4 - (headBytes % 4)) % 4;

const out = fs.openSync(outFile, 'w');
const u32 = (v) => {
  const b = Buffer.alloc(4);
  b.writeUInt32LE(v, 0);
  fs.writeSync(out, b);
};
u32(4);
u32(jsonBytes + 8);
u32(jsonBytes + 4);
u32(jsonBytes);
fs.writeSync(out, jsonBuf);
fs.writeSync(out, Buffer.alloc(pad));
for (const f of ordered) {
  fs.writeSync(out, fs.readFileSync(f.full));
}
fs.closeSync(out);
console.log(`packed ${ordered.length} file(s) -> ${outFile}`);
