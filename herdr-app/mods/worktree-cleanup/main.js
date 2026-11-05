// Asks whether to delete a worktree checkout whose space just closed. Opened by jhamill-spaces
// with { top, main, branch, dirty }. Delete runs `git worktree remove` (forced only after
// "Delete anyway": uncommitted changes, or git refused); the branch stays. Keep does nothing.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { theme, props, closeOverlay, exec, notify, home } from "herdr";

const tilde = (path) => (path.startsWith(home()) ? `~${path.slice(home().length)}` : path);

export default class WorktreeCleanup extends View {
  init(_props, cx) {
    this.force = Boolean(props()?.dirty);
    this.busy = false;
    this.error = "";
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(50, () => this.handle.focus());
  }

  close() {
    closeOverlay(props().overlay);
  }

  remove(cx) {
    if (this.busy) return;
    const { top, main, branch } = props();
    this.busy = true;
    this.error = "";
    cx.notify();
    cx.spawn(async (cx) => {
      const r = await exec("git", ["worktree", "remove", ...(this.force ? ["--force"] : []), top], { cwd: main })
        .catch((e) => ({ code: 1, stderr: String(e?.message ?? e) }));
      this.busy = false;
      if (r.code === 0) {
        notify({ title: "Worktree deleted", body: `${branch ?? tilde(top)} · the branch stays`, level: "success", timeout: 4000 });
        return this.close();
      }
      this.error = r.stderr.trim().split("\n").pop() || "git worktree remove failed.";
      this.force = true;
      cx.notify();
    });
  }

  key(e, cx) {
    if (e.key === "escape" || e.key === "n") return this.close();
    // Enter deletes only what can be deleted safely; forcing takes a click.
    if ((e.key === "enter" || e.key === "y") && !this.force) this.remove(cx);
    cx.stop_propagation();
  }

  button(t, id, label, primary, danger, onClick) {
    return h_flex().id(id).h(28).px(12).items_center().rounded(6).border_1().cursor_pointer().text_size(12.5)
      .border_color(danger ? t.blocked : primary ? t.input : t.border)
      .bg(primary ? t.raised : t.surface)
      .text_color(danger ? t.blocked : primary ? t.foreground : t.muted)
      .hover((s) => s.bg(t.hover).text_color(danger ? t.blocked : t.foreground))
      .on_click((_e, cx) => onClick(cx))
      .child(label);
  }

  render() {
    const t = theme();
    const { top, branch, dirty } = props() ?? {};
    if (!top) return div();
    return v_flex().id("worktree-cleanup").track_focus(this.handle).on_key_down((e, cx) => this.key(e, cx))
      .size_full().p(16).gap(10).bg(t.popover).text_size(13)
      .child(div().font_semibold().text_color(t.foreground).child(`Delete worktree ${branch ?? ""}?`))
      .child(div().text_color(t.muted).child(`Its space closed. Deletes ${tilde(top)}; the branch stays.`))
      .when(Boolean(dirty), (el) => el.child(div().text_color(t.blocked).child("It has uncommitted changes: they will be lost.")))
      .when(Boolean(this.error), (el) => el.child(div().text_color(t.blocked).child(this.error)))
      .child(div().flex_1())
      .child(h_flex().gap(8).justify_end().items_center()
        .child(div().flex_1().text_size(11).text_color(t.dim).child(this.busy ? "deleting…" : this.force ? "esc keep" : "↵ delete · esc keep"))
        .child(this.button(t, "wc-keep", "Keep", false, false, () => this.close()))
        .child(this.button(t, "wc-delete", this.force ? "Delete anyway" : "Delete", true, this.force, (cx) => this.remove(cx))));
  }
}
