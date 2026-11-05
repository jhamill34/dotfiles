// jhamill: the gh-inbox lists inside the PR panel. "Mine" is your open pull requests in the
// org (data.js ORG), grouped into stacks; "Review" is the ones asking for your review. Ported
// from the gh-inbox mod (PostHog/herdr's github-and-trunk, MIT) without its Trunk merge queue.
// A row click hands the pull request to the PR panel (`onOpen`); its hover icons start Claude
// Code on it, copy its link or open it on GitHub. Read with `gh` every minute while shown.
// "Merged" lists the pull requests merged into their default branch in the last 14 days, in the
// focused space's GitHub repository (or the whole org, by choice or outside one),
// optionally by one author, with the git tags on each one's merge commit (Oscilar tags every
// main commit with its build, e.g. v0.9387.0). Read only while that tab shows.

import { div, svg, image } from "gpui-kit";
import { v_flex, h_flex, Input, InputState } from "gpui-base";
import { notify, exec, appHome, writeTextFile } from "herdr";
import { ORG, login, searchPrs, stacks } from "./data.js";
import { location, key } from "./lib.js";
import { CLAUDE_ICON, startClaude } from "./claude.js";

const ICON = (name) => `mods/jhamill-kanso-panel/inbox-icons/${name}.svg`;
const EVERY = 60000;
const MERGED_DAYS = 14, MERGED_MAX = 50;
const MERGED = `query($q: String!) { search(query: $q, type: ISSUE, first: ${MERGED_MAX}) { nodes { ... on PullRequest {
  number title url mergedAt baseRefName author { login }
  repository { nameWithOwner defaultBranchRef { name } } mergeCommit { oid } } } } }`;

function ago(ms) {
  const m = Math.floor(Math.max(0, ms) / 60000);
  if (m < 1) return "now";
  if (m < 60) return `${m}m`;
  const h = Math.floor(m / 60);
  return h < 24 ? `${h}h` : `${Math.floor(h / 24)}d`;
}
const plural = (n, word) => `${n} ${word}${n === 1 ? "" : "s"}`;

// Theme colors for each kind of state, from the panel's tokens.
const palette = (c, t) => ({ ok: c.green, bad: c.red, warn: c.yellow, run: t.working ?? c.accent, merged: c.violet, dim: c.dim, muted: c.muted });

// Visual review runs with changes waiting for a person to approve.
const visualAsks = (pr) => (pr.visual ?? []).filter((v) => v.kind === "approve");

export class Inbox {
  init(cx, { onOpen }) {
    this.onOpen = onOpen;
    this.me = null;
    this.mine = null;
    this.reviews = null;
    this.error = null;
    this.busy = false;
    this.hovered = null;
    this.folded = new Set(JSON.parse(localStorage.getItem("inbox.folded") ?? '["review:teams"]'));
    this.refresh(cx);
    cx.timer.every(EVERY, (cx) => this.refresh(cx));
    // Merged: read while its tab shows (render sets wantMerged), again when the user filter
    // settles or a minute passes.
    this.merged = null; this.mergedFor = null; this.mergedAt = 0; this.mergedBusy = false; this.mergedError = null;
    this.mergedUser = localStorage.getItem("inbox.mergedUser") ?? "";
    this.typedAt = 0; this.wantMerged = false;
    this.mergedAll = localStorage.getItem("inbox.mergedAll") === "1"; // the whole org, not this space's repo
    this.mergedRepo = null; // the repository the list is for; null: the whole org
    this.here = { key: null, repo: null }; // the focused folder, and its GitHub repository once looked up
    this.userInput = InputState.new({ placeholder: "GitHub user (empty: everyone)", value: this.mergedUser });
    this.userInput.on("change", (_e, cx) => { this.typedAt = Date.now(); cx.notify(); });
    this.userInput.on("submit", (_e, cx) => { this.typedAt = 0; this.setUser(this.userInput.value(), cx); });
    cx.timer.every(1000, (cx) => this.tickMerged(cx));
  }

  setUser(user, cx) {
    this.mergedUser = user.trim().replace(/^@/, "");
    localStorage.setItem("inbox.mergedUser", this.mergedUser);
    if (this.userInput.value() !== this.mergedUser) this.userInput.set_value(this.mergedUser);
    cx.notify();
  }

  tickMerged(cx) {
    // Which repository the focused folder is in, looked up again only when the folder changes.
    const k = key();
    if (k !== this.here.key && !this.hereBusy) {
      this.hereBusy = true;
      cx.spawn(async (cx) => {
        const repo = await this.repoHere().catch(() => null);
        this.here = { key: k, repo }; this.hereBusy = false; cx.notify();
      });
    }
    if (this.typedAt && Date.now() - this.typedAt > 700) { this.typedAt = 0; this.setUser(this.userInput.value(), cx); }
    const stale = this.mergedFor !== this.mergedWant() || Date.now() - this.mergedAt > EVERY;
    if (this.wantMerged && stale && !this.mergedBusy && (this.mergedAll || this.here.key !== null)) this.loadMerged(cx);
    this.wantMerged = false; // render sets it again while the tab shows
  }

  // What the list should be for now: the user filter and the scope (the whole org, or this place).
  mergedWant() { return JSON.stringify([this.mergedUser, this.mergedAll ? "all" : this.here.repo]); }

  setAll(all, cx) {
    this.mergedAll = all;
    localStorage.setItem("inbox.mergedAll", all ? "1" : "0");
    cx.notify();
  }

  // The GitHub repository (owner/name) the focused pane's folder belongs to, or null.
  async repoHere() {
    const { cwd, on } = location();
    if (!cwd) return null;
    const r = await exec("git", ["remote", "get-url", "origin"], { cwd, on }).catch(() => null);
    // SSH host aliases too (git@github-personal:owner/name).
    return /github[^:/\s]*[:/]([^/\s]+\/[^/\s]+?)(?:\.git)?\s*$/.exec(r?.code === 0 ? r.stdout : "")?.[1] ?? null;
  }

  loadMerged(cx) {
    const user = this.mergedUser, want = this.mergedWant(), all = this.mergedAll;
    this.mergedBusy = true;
    cx.notify();
    cx.spawn(async (cx) => {
      try {
        const since = new Date(Date.now() - MERGED_DAYS * 86400000).toISOString().slice(0, 10);
        const repo = all ? null : this.here.repo;
        const q = `${repo ? `repo:${repo}` : `org:${ORG}`} is:pr is:merged merged:>=${since} sort:updated-desc${user ? ` author:${user}` : ""}`;
        const r = await exec("gh", ["api", "graphql", "-f", `query=${MERGED}`, "-f", `q=${q}`]);
        if (r.code !== 0) throw new Error(r.stderr.trim().split("\n").pop() || `gh exited ${r.code}`);
        const nodes = JSON.parse(r.stdout).data.search.nodes.filter((n) => n?.number && n.mergeCommit
          && n.baseRefName === (n.repository.defaultBranchRef?.name ?? n.baseRefName));
        const list = nodes.map((n) => ({
          key: `${n.repository.nameWithOwner}#${n.number}`, repo: n.repository.nameWithOwner, number: n.number,
          title: n.title, url: n.url, author: n.author?.login ?? "ghost", merged: Date.parse(n.mergedAt), sha: n.mergeCommit.oid, tags: [],
        })).sort((a, b) => b.merged - a.merged);
        await this.tagsFor(list);
        // Shown even if the scope moved meanwhile: the next tick reads the new one.
        this.merged = list; this.mergedRepo = repo; this.mergedFor = want; this.mergedAt = Date.now(); this.mergedError = null;
      } catch (e) {
        this.mergedError = String(e?.message ?? e);
        this.mergedAt = Date.now(); this.mergedFor = want; // try again in a minute, not every second
      }
      this.mergedBusy = false;
      cx.notify();
    });
  }

  // The tags on each merge commit: one `git ls-remote --tags` per repository, kept to the lines
  // naming those commits (backend has thousands of tags), through gh's git credentials.
  async tagsFor(list) {
    const dir = `${appHome()}/data/jhamill-kanso-panel`;
    await exec("mkdir", ["-p", dir]);
    for (const repo of [...new Set(list.map((p) => p.repo))]) {
      const mine = list.filter((p) => p.repo === repo);
      const file = `${dir}/merged-${repo.replace(/[^\w.-]+/g, "_")}.shas`;
      await exec("rm", ["-f", file]);
      await writeTextFile(file, mine.map((p) => p.sha).join("\n") + "\n", null);
      const r = await exec("sh", ["-c", 'GIT_TERMINAL_PROMPT=0 git ls-remote --tags "https://github.com/$1.git" | grep -F -f "$2"', "sh", repo, file]).catch(() => null);
      await exec("rm", ["-f", file]).catch(() => {});
      const bySha = new Map();
      for (const line of (r?.stdout ?? "").split("\n")) {
        const m = /^([0-9a-f]{40})\trefs\/tags\/(.+?)(\^\{\})?$/.exec(line.trim());
        if (m) bySha.set(m[1], [...new Set([...(bySha.get(m[1]) ?? []), m[2]])]);
      }
      for (const p of mine) p.tags = bySha.get(p.sha) ?? [];
    }
  }

  refresh(cx) {
    this.mergedAt = 0; // the header's refresh reads Merged again too, when it shows
    if (this.busy) return;
    this.busy = true;
    cx.notify();
    cx.spawn(async (cx) => {
      try {
        this.me ??= await login();
        const [mine, reviews] = await Promise.all([searchPrs("author:@me"), searchPrs("review-requested:@me -author:@me")]);
        // GitHub search now and then answers with nothing and no error: an empty list
        // replaces a full one only when the next refresh agrees.
        this.mine = this.settle("mine", mine);
        this.reviews = this.settle("reviews", reviews);
        this.error = null;
        this.updated = Date.now();
      } catch (e) {
        this.error = String(e?.message ?? e);
      }
      this.busy = false;
      cx.notify();
    });
  }

  settle(kind, list) {
    this.emptyOnce ??= {};
    const had = this[kind]?.length > 0;
    if (list.length || !had || this.emptyOnce[kind]) {
      this.emptyOnce[kind] = false;
      return list;
    }
    this.emptyOnce[kind] = true;
    return this[kind];
  }

  // For the switch: how many in each list (direct review requests when there are any).
  counts() {
    const direct = (this.reviews ?? []).filter((r) => r.requested.includes(this.me)).length;
    return { mine: this.mine?.length ?? null, review: direct || (this.reviews?.length ?? null), merged: this.merged?.length ?? null };
  }

  fold(id, cx) {
    this.folded.has(id) ? this.folded.delete(id) : this.folded.add(id);
    localStorage.setItem("inbox.folded", JSON.stringify([...this.folded]));
    cx.notify();
  }

  // Why a pull request can't merge yet, most blocking first.
  blocker(pr, p) {
    if (pr.draft) return { icon: "pr-draft", color: p.dim, label: "Draft" };
    if (pr.conflicts) return { icon: "conflict", color: p.bad, label: "Conflicts" };
    const v = visualAsks(pr)[0];
    if (v) return { icon: "eye", color: p.warn, label: `Visuals: ${v.summary}` };
    if (pr.checks.fail) return { icon: "fail", color: p.bad, label: `${plural(pr.checks.fail, "check")} failing` };
    if (pr.decision === "CHANGES_REQUESTED") return { icon: "changes", color: p.bad, label: "Changes requested" };
    if (pr.checks.running) return { icon: "spinner", spin: true, color: p.run, label: `CI ${pr.checks.pass}/${pr.checks.total}` };
    if (pr.decision === "REVIEW_REQUIRED") return { icon: "waiting", color: p.warn, label: "Needs review" };
    return null;
  }

  step(pr, p) {
    return this.blocker(pr, p) ?? { icon: "check", color: p.ok, label: "Ready to merge" };
  }

  reviewStep(pr, p) {
    if (pr.draft) return { icon: "pr-draft", color: p.dim, label: "Draft" };
    if (pr.checks.fail) return { icon: "fail", color: p.bad, label: "CI failing" };
    if (pr.checks.running) return { icon: "spinner", spin: true, color: p.run, label: "CI running" };
    return { icon: "pr", color: p.ok, label: "Ready for review" };
  }

  // The nearest layer under this one in its stack that can't merge yet.
  blockedBelow(pr, group, p) {
    if (!group) return null;
    const idx = group.members.findIndex((m) => m.pr.key === pr.key);
    for (let i = idx - 1; i >= 0; i--) if (this.blocker(group.members[i].pr, p)) return group.members[i].pr;
    return null;
  }

  icon(name, color, size = 14, spin = false) {
    const el = svg(ICON(name)).size(size).flex_none().text_color(color);
    return spin ? el.spin(900) : el;
  }

  chip(s, size = 11) {
    return h_flex().gap(4).items_center().flex_none().text_size(size).text_color(s.color)
      .child(this.icon(s.icon, s.color, size + 1, s.spin))
      .child(div().whitespace_nowrap().child(s.label));
  }

  // Shown on the hovered row: start Claude Code on it, copy its link, open it on GitHub.
  linkIcons(c, key, url, claude) {
    const icon = (id, glyph, tip, onClick) => div().id(`ibx-${id}-${key}`).p(2).rounded(4).flex_none().cursor_pointer()
      .text_color(c.dim).hover((st) => st.bg(c.raised).text_color(c.text)).tooltip(tip)
      .on_click((_e, cx) => { cx.stop_propagation(); onClick(cx); })
      .child(glyph);
    return h_flex().flex_none().gap(2).items_center()
      .child(icon("claude", image(CLAUDE_ICON).size(13), "Start Claude Code on this PR", (cx) => cx.spawn(claude)))
      .child(icon("copy", svg(ICON("copy")).size(13), "Copy link", (cx) => {
        cx.write_to_clipboard(url);
        notify({ title: "Link copied", body: url, level: "success", timeout: 2500 });
      }))
      .child(icon("open", svg(ICON("external")).size(13), "Open on GitHub", (cx) => cx.open_url(url)));
  }

  hover(key, on, cx) {
    if (on) this.hovered = key;
    else if (this.hovered === key) this.hovered = null;
    cx.notify();
  }

  // A row: what's next, then CI, approvals and open threads. A click shows it in the PR panel.
  prRow(c, t, pr, { group = null, depth = 0, review = false } = {}) {
    const p = palette(c, t);
    let s = review ? this.reviewStep(pr, p) : this.step(pr, p);
    const below = !review && s.icon === "check" ? this.blockedBelow(pr, group, p) : null;
    if (below) s = { icon: "stack", color: p.warn, label: `Waiting on #${below.number} below` };
    const ch = pr.checks;
    const ci = ch.fail ? { icon: "fail", color: p.bad, label: `${ch.fail}` } : ch.running ? { icon: "spinner", spin: true, color: p.run, label: `${ch.pass}/${ch.total}` } : ch.total ? { icon: "check", color: p.ok, label: "" } : null;
    const meta = [];
    if (review) meta.push(div().text_color(c.dim).child(`${pr.author} · ${ago(Date.now() - pr.created)}`));
    else meta.push(this.chip(s));
    if (ci && (review || !["spinner", "fail", "check"].includes(s.icon))) meta.push(this.chip(ci));
    if (pr.approvedBy.length && s.icon !== "check") meta.push(this.chip({ icon: "approved", color: p.ok, label: String(pr.approvedBy.length) }));
    if (pr.unresolved) meta.push(this.chip({ icon: "comment", color: p.warn, label: String(pr.unresolved) }));
    const claude = () => startClaude(pr, { me: this.me, review, status: s.label, stack: group, asOf: this.updated });
    const lead = this.icon(pr.draft ? "pr-draft" : "pr", pr.draft ? p.dim : review ? c.muted : s.color, 15);
    return h_flex().id(`ibx-pr-${pr.key}`).px(8).py(6).gap(8).items_start().rounded(6).cursor_pointer()
      .hover((st) => st.bg(c.subtle))
      .on_hover((on, cx) => this.hover(pr.key, on, cx))
      .on_click((_e, cx) => this.onOpen(pr, cx))
      .when(depth > 0, (el) => el.pl(8 + 14 * Math.min(depth, 3)))
      .child(div().mt(1).child(lead))
      .child(v_flex().flex_1().min_w(0).gap(3)
        .child(h_flex().gap(5).items_center().min_w(0)
          .child(div().flex_none().text_size(11).text_color(c.dim).child(`#${pr.number}`))
          .child(div().flex_1().min_w(0).truncate().text_size(12.5).text_color(pr.draft ? c.muted : c.text).child(pr.title))
          .when(this.hovered === pr.key, (el) => el.child(this.linkIcons(c, pr.key, pr.url, claude))))
        .child(h_flex().gap(8).items_center().min_w(0).overflow_hidden().text_size(11).children(meta)));
  }

  sectionHeader(c, id, label, count, extra = null) {
    const open = !this.folded.has(id);
    return h_flex().id(`ibx-sec-${id}`).px(8).h(28).mt(6).flex_none().items_center().gap(6).rounded(6).cursor_pointer()
      .text_size(11).font_medium().text_color(c.dim).hover((s) => s.text_color(c.muted))
      .on_click((_e, cx) => this.fold(id, cx))
      .child(this.icon(open ? "chevron-down" : "chevron-right", c.dim, 11))
      .child(div().child(label))
      .child(div().text_color(c.dim).child(String(count)))
      .child(div().flex_1())
      .when(Boolean(extra), (el) => el.child(extra));
  }

  note(c, text, color = c.dim) {
    return div().px(8).py(10).text_size(12.5).text_color(color).child(text);
  }

  mineRows(c, t) {
    if (this.error && !this.mine) return [this.note(c, `gh: ${this.error}`, c.red)];
    if (!this.mine) return [this.note(c, "Loading your pull requests…")];
    if (!this.mine.length) return [this.note(c, "No open pull requests.")];
    const p = palette(c, t);
    const rows = [];
    let repo = null;
    for (const g of stacks(this.mine)) {
      const r = g.members[0].pr.repo;
      if (r !== repo) rows.push(div().px(8).pt(10).pb(2).text_size(10.5).font_medium().text_color(c.dim).child(r));
      repo = r;
      if (g.members.length === 1) { rows.push(this.prRow(c, t, g.members[0].pr, { group: g })); continue; }
      const id = `stack:${g.id}`;
      const top = g.members.at(-1).pr;
      const ready = g.members.filter((m) => !this.blocker(m.pr, p)).length;
      const all = ready === g.members.length;
      rows.push(this.sectionHeader(c, id, `Stack of ${g.members.length} · ${top.head}`, "",
        this.chip(all ? { icon: "check", color: p.ok, label: "All ready" } : { icon: "stack", color: c.dim, label: `${ready}/${g.members.length} ready` }, 10.5)));
      // Top of the stack first, as `gh stack view` shows it.
      if (!this.folded.has(id)) for (const m of [...g.members].reverse()) rows.push(this.prRow(c, t, m.pr, { group: g, depth: 1 }));
    }
    if (this.error) rows.unshift(this.note(c, `Last refresh failed: ${this.error}`, c.yellow));
    return rows;
  }

  reviewRows(c, t) {
    if (this.error && !this.reviews) return [this.note(c, `gh: ${this.error}`, c.red)];
    if (!this.reviews) return [this.note(c, "Loading review requests…")];
    if (!this.reviews.length) return [this.note(c, "Nothing is waiting on your review.")];
    const direct = this.reviews.filter((r) => r.requested.includes(this.me));
    const teams = this.reviews.filter((r) => !r.requested.includes(this.me));
    const rows = [];
    for (const [id, label, list] of [["review:you", "Requested from you", direct], ["review:teams", "Your teams", teams]]) {
      if (!list.length) continue;
      rows.push(this.sectionHeader(c, id, label, list.length));
      if (!this.folded.has(id)) for (const pr of [...list].sort((a, b) => b.updated - a.updated)) rows.push(this.prRow(c, t, pr, { review: true }));
    }
    return rows;
  }

  mergedRow(c, t, pr) {
    const p = palette(c, t);
    const claude = () => startClaude(pr, { me: this.me, status: "Merged", asOf: this.mergedAt });
    const tag = (name) => h_flex().id(`ibx-tag-${pr.key}-${name}`).h(18).px(6).gap(4).flex_none().items_center().rounded(4)
      .bg(c.yellow + "1f").text_size(10.5).text_color(c.yellow)
      .child(svg("mods/kanso-chrome/icons/tag.svg").size(11).flex_none())
      .child(div().whitespace_nowrap().child(name));
    return h_flex().id(`ibx-m-${pr.key}`).px(8).py(6).gap(8).items_start().rounded(6).cursor_pointer()
      .hover((st) => st.bg(c.subtle))
      .on_hover((on, cx) => this.hover(`m:${pr.key}`, on, cx))
      .on_click((_e, cx) => this.onOpen(pr, cx))
      .child(div().mt(1).child(this.icon("merged", p.merged, 15)))
      .child(v_flex().flex_1().min_w(0).gap(3)
        .child(h_flex().gap(5).items_center().min_w(0)
          .child(div().flex_none().text_size(11).text_color(c.dim).child(`#${pr.number}`))
          .child(div().flex_1().min_w(0).truncate().text_size(12.5).text_color(c.text).child(pr.title))
          .when(this.hovered === `m:${pr.key}`, (el) => el.child(this.linkIcons(c, `m-${pr.key}`, pr.url, claude))))
        .child(div().text_size(11).text_color(c.dim).truncate().child(`${pr.author} · merged ${ago(Date.now() - pr.merged)} ago${this.mergedRepo ? "" : ` · ${pr.repo.replace(`${ORG}/`, "")}`}`))
        .child(pr.tags.length
          ? h_flex().gap(4).flex_wrap().children(pr.tags.map(tag))
          : div().text_size(10.5).text_color(c.dim).child(Date.now() - pr.merged < 3600000 ? "No tag yet" : "No tag")));
  }

  mergedRows(c, t) {
    this.wantMerged = true;
    const quick = (id, label, user) => div().id(`ibx-user-${id}`).flex_none().cursor_pointer().text_size(12)
      .text_color(this.mergedUser === user ? c.text : c.dim).hover((s) => s.text_color(c.text))
      .on_click((_e, cx) => { this.typedAt = 0; this.setUser(user, cx); })
      .child(label);
    const filter = h_flex().w_full().gap(10).items_center().pb(6)
      .child(div().h(30).flex_1().min_w(0).px(8).flex().items_center().rounded(6).border_1().border_color(c.border)
        .child(Input.new(this.userInput).flex_1().h_full().text_size(12).text_color(c.text)))
      .child(quick("me", "Me", this.me ?? ""))
      .child(quick("all", "Everyone", ""));
    // Where the list is from, and the way to the other scope.
    const toggle = (label, all) => div().id(`ibx-scope-${all ? "all" : "here"}`).flex_none().cursor_pointer().text_color(c.muted)
      .hover((s) => s.text_color(c.text)).on_click((_e, cx) => this.setAll(all, cx)).child(label);
    const fresh = this.merged !== null;
    const scope = h_flex().w_full().gap(8).items_center().pb(4).text_size(11.5).text_color(c.dim)
      .child(div().flex_1().min_w(0).truncate().child(
        !fresh ? "Reading…"
        : this.mergedRepo ? `In ${this.mergedRepo}`
        : this.mergedAll ? `All of ${ORG}`
        : `This space isn't a GitHub repository: all of ${ORG}`))
      .when(fresh && Boolean(this.mergedRepo), (el) => el.child(toggle(`All of ${ORG}`, true)))
      .when(fresh && this.mergedAll, (el) => el.child(toggle("Just this space's repository", false)));
    const rows = [filter, scope];
    const shownFor = this.mergedFor === this.mergedWant();
    if (this.mergedError && !this.merged) rows.push(this.note(c, `gh: ${this.mergedError}`, c.red));
    else if (!this.merged || (!shownFor && this.mergedBusy)) rows.push(this.note(c, "Loading merged pull requests…"));
    else if (!this.merged.length) rows.push(this.note(c, `Nothing merged in the last ${MERGED_DAYS} days${this.mergedUser ? ` by ${this.mergedUser}` : ""}${this.mergedRepo ? ` in ${this.mergedRepo}` : ""}.`));
    else rows.push(...this.merged.map((pr) => this.mergedRow(c, t, pr)));
    if (this.mergedError && this.merged) rows.splice(2, 0, this.note(c, `Last refresh failed: ${this.mergedError}`, c.yellow));
    return rows;
  }

  // The list for `tab` ("mine", "review" or "merged"), as a column the PR panel puts under its header.
  render(c, t, tab) {
    return v_flex().w_full().gap(1)
      .children(tab === "review" ? this.reviewRows(c, t) : tab === "merged" ? this.mergedRows(c, t) : this.mineRows(c, t))
      .child(div().pt(14).text_size(10.5).text_color(c.dim)
        .child(`Read from GitHub with gh${this.updated ? ` · updated ${((a) => (a === "now" ? "just now" : `${a} ago`))(ago(Date.now() - this.updated))}` : ""}. It rereads every minute while shown.`));
  }
}
