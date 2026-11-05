// Seamless ctrl+h/j/k/l between Neovim splits and Herdr panes, like vim-tmux-navigator.
// Keys bind to `vim-nav.<direction>`. In a pane running (n)vim, Neovim moves between its own
// splits and hands off at an edge (herdr/nav.lua): called over its RPC socket, which nav.lua
// publishes as the terminal's `herdr.nvim` label, because `hc keys` waits until the person
// seems to have stopped typing (seconds right after a :split). Anywhere else focus moves to the
// neighbouring pane; in a Kanso strip (its panes are layout blocks, which pane.go refuses) that
// is the strip's own go-<direction>. Draws nothing.

import { View, div } from "gpui-kit";
import { focused, panes, terminals, layout, run, hc, exec, nextCommand } from "herdr";

const KEYS = { left: "ctrl+h", down: "ctrl+j", up: "ctrl+k", right: "ctrl+l" };
const VIM = new Set(["nvim", "vim"]);
const NVIM = "/opt/homebrew/bin/nvim";

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
        if (terminal && VIM.has(pane?.program?.key)) await this.toVim(terminal, dir);
        else if (hasStrip(layout())) run(`kanso-strip.go-${dir}`);
        else run("pane.go", { direction: dir });
      }
    });
  }

  // Neovim's own navigation, over RPC when it published its socket; else the key itself.
  async toVim(terminal, dir) {
    const socket = terminals().find((t) => t.address === terminal)?.labels?.["herdr.nvim"];
    if (socket) {
      const r = await exec(NVIM, ["--server", socket, "--remote-send", `<Cmd>lua HerdrNav("${dir}")<CR>`]).catch(() => null);
      if (r?.code === 0) return;
    }
    await hc(["keys", terminal, KEYS[dir]]);
  }

  render() {
    return div();
  }
}
