// What matters in a diagram, in three levels: focus (1–2 nodes, color and glow), spine (the main
// path: bright), periphery (side branches, error paths, options: muted). The Diagram Style Guide's
// §19: hierarchy by de-emphasis, so the focus needn't shout.
//
// Where the focus comes from, first match wins:
//   1. the author: `%% focus: D, Walidacja` in the source (ids or labels, up to 3);
//   2. the text around the diagram (the md file's title, the paragraphs above and below): the
//      nodes it names are the ones it talks about (up to 2, spine ones first);
//   3. the shape: the main path's outcome and the diagram's real hub (a branching or merging
//      node, or a decision, through which the most paths go: betweenness centrality).
// The spine: every solid route from the entry of the longest path to its outcome, leaving out
// dashed edges and error paths. Without one (no edges, only cycles) everything stays at the middle level.

const norm = (s) => ` ${String(s).toLowerCase().normalize("NFC").replace(/[^\p{L}\p{N}]+/gu, " ").trim()} `;

// nodes: [{ id, label, kind: "A"|"B"|"C"|"error", shape }]
// edges: [{ from, to, dashed, error }]
export function importance({ nodes, edges, context = "", source = "" }) {
  const byId = new Map(nodes.map((n) => [n.id, n]));
  const main = edges.filter((e) => !e.dashed && !e.error && byId.get(e.to)?.kind !== "error" && byId.has(e.from) && byId.has(e.to));
  const adj = new Map(), inMain = new Map();
  for (const e of main) {
    if (!adj.has(e.from)) adj.set(e.from, []);
    adj.get(e.from).push(e.to);
    inMain.set(e.to, (inMain.get(e.to) ?? 0) + 1);
  }

  // Spine: the longest simple-ish path (a node on the current walk is not entered again).
  const memo = new Map(), walking = new Set();
  const longest = (u) => {
    if (memo.has(u)) return memo.get(u);
    walking.add(u);
    // A path that ends in a real exit (a node leading nowhere) beats an equally long one that
    // stops only because it ran into a loop.
    let best = { len: 0, next: null, exit: !(adj.get(u)?.length) };
    for (const v of adj.get(u) ?? []) {
      if (walking.has(v)) continue;
      const r = longest(v);
      if (r.len + 1 > best.len || (r.len + 1 === best.len && r.exit && !best.exit)) best = { len: r.len + 1, next: v, exit: r.exit };
    }
    walking.delete(u);
    memo.set(u, best);
    return best;
  };
  const entries = nodes.filter((n) => !inMain.get(n.id) && adj.has(n.id));
  let start = null, len = 0;
  for (const n of entries.length ? entries : nodes) {
    const r = longest(n.id);
    if (r.len > len) { len = r.len; start = n.id; }
  }
  const spine = [];
  for (let u = start; u && spine.length <= nodes.length; u = memo.get(u)?.next) spine.push(u);
  // Every solid route from that entry to that outcome is the main flow (parallel branches that
  // meet again belong to it), not just the longest one.
  const reach = (from, next) => {
    const seen = new Set([from]), todo = [from];
    while (todo.length) for (const v of next(todo.pop()) ?? []) if (!seen.has(v)) { seen.add(v); todo.push(v); }
    return seen;
  };
  const back = new Map();
  for (const e of main) { if (!back.has(e.to)) back.set(e.to, []); back.get(e.to).push(e.from); }
  const spineSet = new Set();
  if (len > 0) {
    const down = reach(start, (u) => adj.get(u)), up = reach(spine.at(-1), (u) => back.get(u));
    for (const id of down) if (up.has(id)) spineSet.add(id);
  }
  const spineEdges = new Set(main.filter((e) => spineSet.has(e.from) && spineSet.has(e.to)).map((e) => `${e.from}>${e.to}`));

  // Betweenness centrality over the solid edges (Brandes; diagrams are small).
  const bc = new Map(nodes.map((n) => [n.id, 0]));
  for (const s of nodes) {
    const stack = [], pred = new Map(), sigma = new Map([[s.id, 1]]), dist = new Map([[s.id, 0]]), queue = [s.id];
    while (queue.length) {
      const v = queue.shift();
      stack.push(v);
      for (const w of adj.get(v) ?? []) {
        if (!dist.has(w)) { dist.set(w, dist.get(v) + 1); queue.push(w); }
        if (dist.get(w) === dist.get(v) + 1) {
          sigma.set(w, (sigma.get(w) ?? 0) + sigma.get(v));
          if (!pred.has(w)) pred.set(w, []);
          pred.get(w).push(v);
        }
      }
    }
    const delta = new Map();
    while (stack.length) {
      const w = stack.pop();
      for (const v of pred.get(w) ?? []) delta.set(v, (delta.get(v) ?? 0) + (sigma.get(v) / sigma.get(w)) * (1 + (delta.get(w) ?? 0)));
      if (w !== s.id) bc.set(w, bc.get(w) + (delta.get(w) ?? 0));
    }
  }
  const degree = (id) => edges.filter((e) => e.from === id || e.to === id).length;
  const rank = (a, b) => (spineSet.has(b) - spineSet.has(a)) || bc.get(b) - bc.get(a);

  // 1. The author.
  let focus = [], why = "";
  const asked = source.match(/^\s*%%\s*focus\s*:\s*(.+)$/m)?.[1];
  if (asked) {
    for (const want of asked.split(/\s*,\s*/).map((s) => s.trim()).filter(Boolean)) {
      const n = byId.get(want) ?? nodes.find((x) => norm(x.label) === norm(want));
      if (n && !focus.includes(n.id)) focus.push(n.id);
    }
    focus = focus.slice(0, 3);
    if (focus.length) why = "author (%% focus)";
  }
  // 2. The text around it.
  if (!focus.length && context) {
    const text = norm(context);
    // A one-word label ("TURN", "Gateway") is a common word too: it counts only written exactly
    // so (same letters and case, a whole word); longer labels match loosely.
    const exact = (label) => new RegExp(`(^|[^\\p{L}\\p{N}])${label.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}([^\\p{L}\\p{N}]|$)`, "u").test(context);
    const named = nodes.filter((n) => {
      const words = norm(n.label).trim().split(" ");
      if (words.join(" ").length < 4) return false;
      return words.length > 1 ? text.includes(norm(n.label)) : words[0].length >= 5 && exact(n.label.trim());
    });
    // Naming nearly every node says nothing about which one matters.
    if (named.length && named.length <= Math.max(2, nodes.length / 2)) {
      focus = named.sort((a, b) => rank(a.id, b.id)).slice(0, 2).map((n) => n.id);
      why = "text around the diagram";
    }
  }
  // 3. The shape.
  if (!focus.length && spineSet.size) {
    const outcome = spine.at(-1);
    if (byId.get(outcome)?.kind !== "error") focus.push(outcome);
    const hubs = nodes.filter((n) => n.id !== outcome && spineSet.has(n.id) && bc.get(n.id) > 0 && (degree(n.id) >= 3 || n.shape === "diamond"))
      .sort((a, b) => bc.get(b.id) - bc.get(a.id));
    if (hubs[0]) focus.push(hubs[0].id);
    why = "shape: outcome of the main flow" + (hubs[0] ? " + the node most routes pass through" : "");
  }
  return { focus: new Set(focus), spine: spineSet, spineEdges, why };
}
