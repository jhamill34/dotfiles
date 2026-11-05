// A small popup for moving between spaces from the keyboard, like the TUI's workspace list:
// j/k (or down/up) show the next/previous space as you go, 1-9 jump to one, Enter or Esc
// closes. Opened by `mod.open:space-nav` (prefix+w in keys.json).

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { spaces, theme, run, props, closeOverlay } from "herdr";

export default class SpaceNav extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(50, () => this.handle.focus());
  }

  close() {
    closeOverlay(props().overlay);
  }

  key(e, cx) {
    const k = e.key;
    if (k === "j" || k === "down") run("space.next");
    else if (k === "k" || k === "up") run("space.prev");
    else if (/^[1-9]$/.test(k) && Number(k) <= spaces().length) run("space.select", { index: Number(k) });
    else if (k === "enter" || k === "escape" || k === "q") return this.close();
    else return;
    cx.stop_propagation();
    cx.notify();
  }

  render() {
    const t = theme();
    const glyph = (s) => (s.status === "blocked" || s.status === "done" ? "●" : s.status === "working" ? "◌" : "");
    return v_flex().id("space-nav").track_focus(this.handle).on_key_down((e, cx) => this.key(e, cx))
      .w_full().p(10).gap(2).bg(t.popover).text_size(13)
      .child(div().px(8).pb(6).text_size(11).text_color(t.dim).child("Spaces"))
      .children(spaces().map((s, i) => h_flex().id(`sn-${s.id}`).h(28).px(8).gap(10).items_center().rounded(7).cursor_pointer()
        .when(s.active, (el) => el.bg(t.selected))
        .hover((st) => st.bg(t.hover))
        .on_click(() => { run("space.select", { id: s.id }); this.close(); })
        .child(div().w(14).text_size(11).text_color(t.dim).child(i < 9 ? String(i + 1) : ""))
        .child(div().flex_1().truncate().text_color(s.active ? t.foreground : t.muted).when(s.active, (el) => el.font_semibold()).child(s.name))
        .child(div().text_color(t[s.status] ?? t.dim).child(glyph(s)))))
      .child(div().px(8).pt(6).text_size(10.5).text_color(t.dim).child("j/k move · 1–9 jump · enter close"));
  }
}
