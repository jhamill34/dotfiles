// Notices when a local worktree space closes while its checkout is still there, and opens
// worktree-cleanup to ask whether to delete it. Draws nothing: it sits in the layout as an
// empty floating block so it runs whatever the sidebar is.

import { View, div } from "gpui-kit";
import { spaces, panes, exec, openOverlay } from "herdr";

// Where a space is now: its first terminal's live folder, else where it was made.
function place(s, ps) {
  const tabs = new Set((s.tabs ?? []).map((c) => c.id));
  return ps.find((p) => tabs.has(p.tab) && p.cwd)?.cwd || s.folder;
}

export default class WorktreeWatch extends View {
  init(_props, cx) {
    this.git = {}; // folder -> { top, main, branch, linked } | null (not a repo), while looked up: undefined
    this.trees = {}; // space -> its worktree checkout, while it shows
    cx.timer.every(1000, (cx) => this.tick(cx));
  }

  tick(cx) {
    const sp = spaces();
    if (!sp.length) return; // Nothing to go by (as under `herdr-app check`).
    const ps = panes();
    const ids = new Set(sp.map((s) => s.id));
    for (const [id, tree] of Object.entries(this.trees)) {
      if (ids.has(id)) continue;
      delete this.trees[id];
      // Remove worktree deletes it right after closing the space: look again in a moment.
      cx.timer.after(2000, (cx) => this.askCleanup(tree, cx));
    }
    for (const s of sp) {
      if (s.machine) continue;
      const at = place(s, ps);
      if (!at) continue;
      if (!(at in this.git)) this.lookUp(at, cx);
      const g = this.git[at];
      if (g?.linked) this.trees[s.id] = g;
    }
  }

  lookUp(folder, cx) {
    this.git[folder] = undefined;
    cx.spawn(async () => {
      try {
        const r = await exec("git", ["rev-parse", "--show-toplevel", "--path-format=absolute", "--git-common-dir", "--abbrev-ref", "HEAD"], { cwd: folder });
        if (r.code !== 0) { this.git[folder] = null; return; }
        const [top, common, branch] = r.stdout.trim().split("\n");
        const main = common.endsWith("/.git") ? common.slice(0, -5) : common;
        this.git[folder] = { top, main, branch: branch === "HEAD" ? null : branch, linked: common !== `${top}/.git` };
      } catch {
        delete this.git[folder]; // Ask again next time.
      }
    });
  }

  askCleanup(tree, cx) {
    cx.spawn(async () => {
      // Another space still on the checkout keeps it.
      if (Object.values(this.trees).some((t) => t.top === tree.top)) return;
      const list = await exec("git", ["worktree", "list", "--porcelain"], { cwd: tree.main }).catch(() => null);
      if (!list || list.code !== 0 || !list.stdout.split("\n").includes(`worktree ${tree.top}`)) return;
      const status = await exec("git", ["--no-optional-locks", "status", "--porcelain"], { cwd: tree.top }).catch(() => null);
      openOverlay({ mod: "worktree-cleanup", kind: "dialog", width: 460, height: 230,
        props: { top: tree.top, main: tree.main, branch: tree.branch, dirty: Boolean(status?.stdout.trim()) } });
    });
  }

  render() {
    return div();
  }
}
