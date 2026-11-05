#!/usr/bin/env node
// jhamill: copied from Nikospy/herdr-preview md-preview (MIT, LICENSE-md-preview) and recolored
// with Everforest Dark Hard (blue input, green logic, purple output, red error, its greys).
// Mermaid -> SVG for Herdr's md-preview, in a dark diagram style guide (semantic node types,
// one focus, 8 px grid, Lexend Deca + DM Mono).
//
//   node render.mjs <in.mmd> <out.svg> [--bg #hex] [--fg #hex] [--context <file with the text around it>]
//   prints {"w":…,"h":…,"focus":[…],"why":"…"} on success; an error line on stderr and exit 1 otherwise.
//
// Layout and shapes: beautiful-mermaid (MIT, no browser, ELK layout). Its SVG colors through
// CSS variables and color-mix(), which GPUI's SVG renderer (resvg) doesn't read, so every color
// is computed here and written as a plain value. On top of that, the style guide:
//   - node types (§7): a node nothing points to = A (passive), a node pointing nowhere = C
//     (terminal), the rest B (active); words in the label override (query/file/input -> A,
//     parse/validate/llm/engine -> B, response/output/error/alert -> C).
//   - three levels (§2 Single Focus, §19 "de-emphasize by muted border, dashed lines"), chosen in
//     focus.mjs (the author's `%% focus:`, else the text around the diagram, else its shape):
//     focus (1–2 nodes): its type's color (output #a78bfa, logic #4ade80, input #38bdf8),
//       1.5 px border, glow;
//     spine (the main path): #8a8a93 border, white text, edges #8a8a93;
//     periphery (side branches, options, error paths): #3a3a3a border, muted text, edges #52525b.
//     Besides that, color only where it means something: A's 3 px bar in #38bdf8 (data comes in
//     here), error nodes' #f87171 border. (The guide gives every B a green border; with the whole
//     middle green, color told nothing.) Corners 6 px.
//   - text fits its box: the layout guesses widths for Inter, the SVG draws Lexend Deca 600 and
//     DM Mono (wider), so widths are measured from the fonts' own advances (metrics.json, made
//     with fontTools): an edge label's box is resized to its text, a node label too wide for
//     its box is set smaller (down to 10 px).
//   - edges (§9): line #3f3f46 (on the pane's own background: a step lighter so it shows),
//     1.5 px, arrowhead in the line's color, bends rounded; an edge into an error node or
//     labelled error/błąd: red, dashed. Edge labels in DM Mono 11 px.
//   - type: Lexend Deca for nodes, DM Mono 12 px for edge labels (installed in ~/Library/Fonts).
import { readFileSync, writeFileSync } from "fs";
import { renderMermaidSVG } from "beautiful-mermaid";
import { importance } from "./focus.mjs";

const [inPath, outPath, ...rest] = process.argv.slice(2);
const opt = (k, d) => { const i = rest.indexOf(`--${k}`); return i >= 0 ? rest[i + 1] : d; };
const BG = opt("bg", "#0a0a0a"), FG = opt("fg", "#ffffff"), ctxPath = opt("context", "");

const SEM = { input: "#7fbbb3", logic: "#a7c080", output: "#d699b6", error: "#e67e80" };
const CARD = "#2e383c", BORDER = "#4f5b58", MUTED = "#859289";
const SPINE = "#9da9a0"; // the main path: brighter than the side lines, still under the focus
const METRICS = JSON.parse(readFileSync(new URL("./metrics.json", import.meta.url), "utf8"));
const unescape = (t) => t.replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g, '"').replace(/&#39;|&apos;/g, "'").replace(/&amp;/g, "&");
// Width in px of text in a font from metrics.json (unknown glyphs: an average letter).
const textWidth = (text, font, size) => [...unescape(text)].reduce((w, ch) => w + (METRICS[font][ch] ?? (font === "dmmono400" ? 0.6 : 0.65)), 0) * size;
const LINE = "#7a8478"; // the guide's #3f3f46 vanishes on Herdr's near-black pane: one step up (zinc 600)

const hex = (h) => { h = h.replace("#", ""); if (h.length === 3) h = [...h].map((c) => c + c).join(""); return [0, 2, 4].map((i) => parseInt(h.slice(i, i + 2), 16)); };
const toHex = (c) => "#" + c.map((v) => Math.round(v).toString(16).padStart(2, "0")).join("");
const mix = (a, p, b) => { const x = hex(a), y = hex(b); return toHex(x.map((v, i) => v * p + y[i] * (1 - p))); };

const VARS = {
  bg: BG, fg: FG,
  _text: FG,
  "_text-sec": MUTED,
  "_text-muted": MUTED,
  "_text-faint": mix(FG, 0.25, BG),
  _line: LINE,
  _arrow: LINE,
  "_node-fill": CARD,
  "_node-stroke": BORDER,
  "_group-fill": BG,
  "_group-hdr": mix(FG, 0.05, BG),
  "_inner-stroke": BORDER,
  "_key-badge": mix(FG, 0.1, BG),
  accent: SEM.logic, line: LINE, muted: MUTED, surface: CARD, border: BORDER,
};

function main() {
  const src = readFileSync(inPath, "utf8");
  let svg = renderMermaidSVG(src, { bg: BG, fg: FG, line: LINE, accent: LINE, muted: MUTED, surface: CARD, border: BORDER, font: "Lexend Deca", transparent: true, padding: 24 });

  // Plain colors instead of variables; no <style> (no web fonts, no custom properties).
  svg = svg.replace(/<style>[\s\S]*?<\/style>/, "");
  for (let i = 0; i < 4 && /var\(--/.test(svg); i++) {
    svg = svg.replace(/var\(--([\w-]+)(?:,\s*([^()]*(?:\([^()]*\)[^()]*)*))?\)/g, (m, name, fb) => VARS[name] ?? fb?.trim() ?? FG);
  }
  svg = svg.replace(/color-mix\(in srgb, (#[0-9a-f]{3,6}) (\d+)%, (#[0-9a-f]{3,6})\)/gi, (_m, a, p, b) => mix(a, Number(p) / 100, b));
  svg = svg.replace(/(<svg[^>]*?) style="[^"]*"/, "$1");
  svg = svg.replace(/<svg /, `<svg font-family="Lexend Deca, sans-serif" `);

  // Who points where: sources and sinks for the node types.
  const into = new Map(), out = new Map();
  for (const m of svg.matchAll(/class="edge" data-from="([^"]*)" data-to="([^"]*)"/g)) {
    out.set(m[1], (out.get(m[1]) ?? 0) + 1);
    into.set(m[2], (into.get(m[2]) ?? 0) + 1);
  }
  const kindOf = (id, label) => {
    const l = label.toLowerCase();
    if (/\b(error|alert|błąd|blad)\b/.test(l)) return "error";
    if (/\b(response|output|odpowied)/.test(l)) return "C";
    if (/\b(parse|validate|walidac|llm|engine|silnik)/.test(l)) return "B";
    if (/\b(query|file|input|zapytanie|plik|wejście)/.test(l)) return "A";
    if (!into.get(id)) return "A";
    if (!out.get(id)) return "C";
    return "B";
  };
  const errorNodes = new Set();
  // Pass 1: the type of every node, then the levels (focus.mjs).
  const kinds = new Map(), nodes = [];
  for (const m of svg.matchAll(/<g class="node" data-id="([^"]*)" data-label="([^"]*)" data-shape="([^"]*)"/g)) {
    const label = unescape(m[2]), kind = kindOf(m[1], label);
    kinds.set(m[1], kind);
    nodes.push({ id: m[1], label, kind, shape: m[3] });
  }
  const isErrLabel = (l) => /\b(error|błąd|blad|fail)/.test(l.toLowerCase());
  const edges = [...svg.matchAll(/<polyline class="edge" data-from="([^"]*)" data-to="([^"]*)" data-style="([^"]*)"([^>]*)>/g)].map((m) => ({
    from: m[1], to: m[2], dashed: m[3] === "dotted", error: kinds.get(m[2]) === "error" || isErrLabel(m[4].match(/data-label="([^"]*)"/)?.[1] ?? ""),
  }));
  const context = ctxPath ? readFileSync(ctxPath, "utf8") : "";
  const levels = importance({ nodes, edges, context, source: src });
  const leveled = levels.spine.size > 0 || levels.focus.size > 0;

  svg = svg.replace(/<g class="node" data-id="([^"]*)" data-label="([^"]*)" data-shape="([^"]*)">([\s\S]*?)<\/g>/g, (all, id, label, shape, body) => {
    const k = kinds.get(id) ?? "B";
    if (k === "error") errorNodes.add(id);
    const focal = levels.focus.has(id);
    const side = leveled && !focal && !levels.spine.has(id);
    const typeColor = k === "A" ? SEM.input : k === "B" ? SEM.logic : k === "error" ? SEM.error : SEM.output;
    const color = focal ? (shape === "diamond" ? SEM.logic : typeColor) : k === "A" ? SEM.input : k === "error" ? SEM.error : side ? BORDER : SPINE;
    let bar = "";
    body = body.replace(/<(rect|polygon|ellipse|circle|path)([^>]*?)fill="[^"]*" stroke="[^"]*" stroke-width="[^"]*"/, (m, tag, attrs) => {
      if (tag === "rect") attrs = attrs.replace(/rx="[^"]*" ry="[^"]*"/, 'rx="6" ry="6"');
      if (k === "A") {
        if (tag === "rect") {
          const x = attrs.match(/ x="([\d.]+)"/)?.[1], y = attrs.match(/ y="([\d.]+)"/)?.[1], h = attrs.match(/ height="([\d.]+)"/)?.[1];
          if (x && y && h) bar = `<rect x="${x}" y="${Number(y) + 3}" width="3" height="${Number(h) - 6}" fill="${side ? mix(SEM.input, 0.45, CARD) : color}" />`;
          // A focused entry keeps its bar and gets the border and glow too.
          return focal ? `<${tag}${attrs}fill="${CARD}" stroke="${color}" stroke-width="1.5" filter="url(#glow)"` : `<${tag}${attrs}fill="${CARD}" stroke="none" stroke-width="0"`;
        }
        return `<${tag}${attrs}fill="${CARD}" stroke="${color}" stroke-width="${focal ? 1.5 : 1}"${focal ? ' filter="url(#glow)"' : ""}`;
      }
      return `<${tag}${attrs}fill="${CARD}" stroke="${color}" stroke-width="${focal ? 1.5 : 1}"${focal ? ' filter="url(#glow)"' : ""}`;
    });
    // The label's own weight: 600 for node titles (guide: 15–16 px title, here kept at the layout's 13).
    body = body.replace(/(<text[^>]*?)font-weight="500"/g, '$1font-weight="600"');
    if (side) body = body.replace(/(<text[^>]*?)fill="[^"]*"/g, `$1fill="${MUTED}"`);
    // Too wide for its box (measured in Lexend Deca 600): a smaller size, not an overflow.
    const box = Number(body.match(/<rect[^>]*?width="([\d.]+)"/)?.[1] ?? 0) || (() => {
      const xs = [...(body.match(/points="([^"]*)"/)?.[1] ?? "").matchAll(/([\d.]+),/g)].map((m) => Number(m[1]));
      return xs.length ? (Math.max(...xs) - Math.min(...xs)) * 0.85 : 0; // a diamond's text room: its middle line
    })();
    if (box) body = body.replace(/(<text[^>]*?)font-size="([\d.]+)"([^>]*>)([\s\S]*?)<\/text>/g, (m, a, size, b, inner) => {
      const lines = inner.includes("<tspan") ? [...inner.matchAll(/<tspan[^>]*>([^<]*)<\/tspan>/g)].map((x) => x[1]) : [inner];
      const need = Math.max(...lines.map((l) => textWidth(l, "lexend600", Number(size))));
      const room = box - (shape === "diamond" ? 8 : 24);
      if (need <= room) return m;
      const fit = Math.max(10, Math.floor(Number(size) * (room / need) * 10) / 10);
      return `${a}font-size="${fit}"${b}${inner}</text>`;
    });
    return `<g class="node" data-id="${id}" data-label="${label}" data-shape="${shape}" data-type="${k}">${body}${bar}</g>`;
  });

  // Edges: rounded bends, 1.5 px; error paths red and dashed.
  svg = svg.replace(/<polyline class="edge" data-from="([^"]*)" data-to="([^"]*)"([^>]*?)points="([^"]*)"([^>]*?)\/>/g, (all, from, to, mid, points, tail) => {
    const label = (mid.match(/data-label="([^"]*)"/)?.[1] ?? "").toLowerCase();
    const err = errorNodes.has(to) || /\b(error|błąd|blad|fail)/.test(label);
    const p = points.trim().split(/\s+/).map((s) => s.split(",").map(Number));
    let d = `M${p[0][0]},${p[0][1]}`;
    for (let i = 1; i < p.length - 1; i++) {
      const [a, b, c] = [p[i - 1], p[i], p[i + 1]];
      const r = Math.min(8, Math.hypot(b[0] - a[0], b[1] - a[1]) / 2, Math.hypot(c[0] - b[0], c[1] - b[1]) / 2);
      const ux = (b[0] - a[0]) / (Math.hypot(b[0] - a[0], b[1] - a[1]) || 1), uy = (b[1] - a[1]) / (Math.hypot(b[0] - a[0], b[1] - a[1]) || 1);
      const vx = (c[0] - b[0]) / (Math.hypot(c[0] - b[0], c[1] - b[1]) || 1), vy = (c[1] - b[1]) / (Math.hypot(c[0] - b[0], c[1] - b[1]) || 1);
      d += ` L${b[0] - ux * r},${b[1] - uy * r} Q${b[0]},${b[1]} ${b[0] + vx * r},${b[1] + vy * r}`;
    }
    d += ` L${p.at(-1)[0]},${p.at(-1)[1]}`;
    const onSpine = levels.spineEdges.has(`${from}>${to}`);
    tail = tail.replace(/stroke="[^"]*"/, `stroke="${err ? SEM.error : onSpine ? SPINE : LINE}"`).replace(/stroke-width="[^"]*"/, `stroke-width="${onSpine || err ? 1.5 : 1.25}"`);
    if (onSpine) tail = tail.replace(/marker-end="url\(#arrowhead\)"/, 'marker-end="url(#arrowhead-spine)"');
    if (err) {
      tail = tail.replace(/marker-end="url\(#arrowhead\)"/, 'marker-end="url(#arrowhead-err)"');
      if (!/stroke-dasharray/.test(tail)) tail = tail.replace(/fill="none"/, 'fill="none" stroke-dasharray="4 4"');
    }
    return `<path class="edge" data-from="${from}" data-to="${to}"${mid}d="${d}"${tail}/>`;
  });

  // Edge labels in DM Mono 12 px, each box resized to its text (8 px each side).
  svg = svg.replace(/<g class="edge-label"([^>]*)>\s*<rect x="([\d.]+)" y="([\d.]+)" width="([\d.]+)"([^>]*)\/>\s*<text([^>]*?)font-size="[\d.]+"([^>]*)>([^<]*)<\/text>/g,
    (m, g, x, y, w, rest, ta, tb, label) => {
      const cx = Number(x) + Number(w) / 2, nw = textWidth(label, "dmmono400", 12) + 16;
      return `<g class="edge-label"${g}>\n  <rect x="${cx - nw / 2}" y="${y}" width="${nw}"${rest}/>\n  <text font-family="DM Mono, monospace"${ta}font-size="12"${tb}>${label}</text>`;
    });
  // Labels the pattern above didn't take (another shape): font only, inside their own group.
  svg = svg.replace(/(<g class="edge-label"[^>]*>\s*(?:<rect[^>]*\/>\s*)?<text)(?![^>]*font-family)/g, '$1 font-family="DM Mono, monospace"');

  // Glow filter and the red arrowhead.
  svg = svg.replace(/<defs>/, `<defs>
  <filter id="glow" x="-20%" y="-20%" width="140%" height="140%"><feGaussianBlur stdDeviation="3" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  <marker id="arrowhead-err" markerWidth="8" markerHeight="5" refX="7" refY="2.5" orient="auto"><polygon points="0 0, 8 2.5, 0 5" fill="${SEM.error}" /></marker>
  <marker id="arrowhead-spine" markerWidth="8" markerHeight="5" refX="7" refY="2.5" orient="auto"><polygon points="0 0, 8 2.5, 0 5" fill="${SPINE}" /></marker>`);

  writeFileSync(outPath, svg);
  const vb = svg.match(/viewBox="[-\d.]+ [-\d.]+ ([\d.]+) ([\d.]+)"/);
  process.stdout.write(JSON.stringify({ w: Math.ceil(Number(vb?.[1] ?? 600)), h: Math.ceil(Number(vb?.[2] ?? 300)), focus: [...levels.focus], why: levels.why }) + "\n");
}

try { main(); } catch (e) { process.stderr.write(String(e?.message ?? e).split("\n")[0] + "\n"); process.exit(1); }
