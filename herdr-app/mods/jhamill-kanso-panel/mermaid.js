// jhamill: ```mermaid blocks drawn as diagrams in the Markdown preview. A block asks get() for
// its diagram; a source not seen before is queued, and pump(cx) (on the preview's timer) renders
// one at a time with mermaid/render.mjs (beautiful-mermaid on Node, no browser, about 0.1 s) into
// data/jhamill-kanso-panel/mermaid/<hash>.svg, kept by source and colors so a diagram drawn once
// shows at once next time. Node comes from mermaid/runtime.json: Herdr's PATH may not have it.

import { exec, appHome, readTextFile, writeTextFile } from "herdr";

const MOD = "jhamill-kanso-panel";
const CACHE = `data/${MOD}/mermaid`; // under the app home: image() reads only there

// FNV-1a, as hex: the cache name of a source in some colors.
function hash(text) {
  let h = 0x811c9dc5;
  for (let i = 0; i < text.length; i++) { h ^= text.charCodeAt(i); h = Math.imul(h, 0x01000193) >>> 0; }
  return h.toString(16).padStart(8, "0");
}

// The diagram inside a fenced block's lines, or null when the fence isn't mermaid.
export function mermaidSource(lines) {
  const open = /^\s{0,3}(`{3,}|~{3,})\s*mermaid\b/i.exec(lines[0] ?? "");
  if (!open) return null;
  const close = new RegExp(`^\\s{0,3}${open[1][0] === "`" ? "`" : "~"}{${open[1].length},}\\s*$`);
  const body = lines.slice(1);
  if (body.length && close.test(body[body.length - 1])) body.pop();
  return body.join("\n");
}

export class Mermaid {
  constructor() {
    this.diagrams = new Map(); // key -> { state: "wait" | "ok" | "bad", rel, w, h, error }
    this.queue = [];
    this.busy = false;
  }

  // A diagram's state now; a new one is queued for pump().
  get(src, bg, fg) {
    const key = hash(`${bg}\n${fg}\n${src}`);
    let d = this.diagrams.get(key);
    if (!d) {
      d = { state: "wait" };
      this.diagrams.set(key, d);
      this.queue.push({ key, src, bg, fg });
    }
    return d;
  }

  // Renders the next queued diagram, if any and none is running.
  pump(cx) {
    if (this.busy || !this.queue.length) return;
    const job = this.queue.shift();
    this.busy = true;
    cx.spawn(async (cx) => {
      const d = this.diagrams.get(job.key);
      try { Object.assign(d, await this.render(job)); }
      catch (e) { Object.assign(d, { state: "bad", error: String(e?.message ?? e) }); }
      this.busy = false;
      cx.notify();
    });
  }

  async render({ key, src, bg, fg }) {
    const dir = `${appHome()}/${CACHE}`;
    const rel = `${CACHE}/${key}.svg`;
    // Drawn before (this pane or an earlier one): its size is kept beside it.
    const kept = await readTextFile(`${dir}/${key}.json`).catch(() => null);
    if (kept) {
      try { const m = JSON.parse(kept); if (m.w && m.h) return { state: "ok", rel, w: m.w, h: m.h }; } catch {}
    }
    await exec("mkdir", ["-p", dir]);
    // writeTextFile(…, null) only creates: clear what an interrupted render left.
    await exec("rm", ["-f", `${dir}/${key}.mmd`, `${dir}/${key}.json`]);
    await writeTextFile(`${dir}/${key}.mmd`, src, null);
    const runtime = JSON.parse((await readTextFile(`${appHome()}/mods/${MOD}/mermaid/runtime.json`)) ?? "{}");
    const r = await exec(runtime.node ?? "node", [`${appHome()}/mods/${MOD}/mermaid/render.mjs`, `${dir}/${key}.mmd`, `${dir}/${key}.svg`, "--bg", bg, "--fg", fg]);
    await exec("rm", ["-f", `${dir}/${key}.mmd`]).catch(() => {});
    if (r.code !== 0) {
      const why = (r.stderr || r.stdout).trim().split("\n")[0] || `render.mjs exited ${r.code}`;
      if (/Cannot find (package|module)|ERR_MODULE_NOT_FOUND/i.test(why)) return { state: "bad", error: "the renderer isn't installed: run `make herdr-mods` in ~/dotfiles" };
      return { state: "bad", error: why };
    }
    const m = JSON.parse(r.stdout.trim().split("\n").pop());
    await writeTextFile(`${dir}/${key}.json`, JSON.stringify({ w: m.w, h: m.h }), null);
    return { state: "ok", rel, w: m.w, h: m.h };
  }
}
