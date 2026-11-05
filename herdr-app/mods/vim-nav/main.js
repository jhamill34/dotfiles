// Seamless ctrl+h/j/k/l between Neovim splits and Herdr panes, like vim-tmux-navigator.
// Keys bind to `vim-nav.<direction>`: in a pane running (n)vim the key goes to the program,
// whose herdr/nav.lua moves between its own splits and hands off at an edge; anywhere else
// focus moves to the neighbouring pane. In a Kanso strip (its panes are layout blocks, which
// pane.go refuses) that is the strip's own go-<direction>. Draws nothing.

import { View, div } from "gpui-kit";
import { focused, panes, layout, run, hc, nextCommand, exec, appHome, writeTextFile } from "herdr";

const KEYS = { left: "ctrl+h", down: "ctrl+j", up: "ctrl+k", right: "ctrl+l" };
const VIM = new Set(["nvim", "vim"]);

const hasStrip = (n) => n?.id === "strip-map" || (n?.children ?? []).some(hasStrip);

export default class VimNav extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      for (;;) {
        const dir = await nextCommand();
        if (!KEYS[dir]) continue;
        const f = focused();
        const pane = panes().find((p) => (f?.pane ? p.pane === f.pane : p.terminal === f?.terminal));
        const terminal = pane?.terminal ?? f?.terminal;
        // DEBUG: what the last command saw.
        try {
          const dir = `${appHome()}/data/vim-nav`;
          await exec("mkdir", ["-p", dir]); await exec("rm", ["-f", `${dir}/last.json`]);
          await writeTextFile(`${dir}/last.json`, JSON.stringify({ dir, at: new Date().toISOString(), f, pane: pane && { pane: pane.pane, terminal: pane.terminal, program: pane.program }, strip: hasStrip(layout()) }, null, 1), null);
        } catch {}
        if (terminal && VIM.has(pane?.program?.key)) await hc(["keys", terminal, KEYS[dir]]);
        else if (hasStrip(layout())) run(`kanso-strip.go-${dir}`);
        else run("pane.go", { direction: dir });
      }
    });
  }

  render() {
    return div();
  }
}
