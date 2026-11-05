// Seamless ctrl+h/j/k/l between Neovim splits and Herdr panes, like vim-tmux-navigator.
// Keys bind to `vim-nav.<direction>`: in a pane running (n)vim the key goes to the program,
// whose herdr/nav.lua moves between its own splits and calls `herdr-app do pane.go` at an
// edge; anywhere else focus moves to the neighbouring pane. Draws nothing.

import { View, div } from "gpui-kit";
import { focused, panes, run, hc, nextCommand } from "herdr";

const KEYS = { left: "ctrl+h", down: "ctrl+j", up: "ctrl+k", right: "ctrl+l" };
const VIM = new Set(["nvim", "vim"]);

export default class VimNav extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      for (;;) {
        const dir = await nextCommand();
        if (!KEYS[dir]) continue;
        const pane = panes().find((p) => p.pane === focused()?.pane);
        if (pane?.terminal && VIM.has(pane.program?.key)) await hc(["keys", pane.terminal, KEYS[dir]]);
        else run("pane.go", { direction: dir });
      }
    });
  }

  render() {
    return div();
  }
}
