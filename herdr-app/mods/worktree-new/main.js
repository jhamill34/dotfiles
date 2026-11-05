// Opens jhamill-worktree in "new" mode on the focused space and folder, then closes itself:
// `mod.open` can't pass props, so a key opens this instead (`mod.open:worktree-new`).

import { View, div } from "gpui-kit";
import { focused, props, openOverlay, closeOverlay } from "herdr";

export default class WorktreeNew extends View {
  init(_props, cx) {
    const overlay = props()?.overlay;
    if (!overlay) return; // Only as an overlay (`herdr-app check` loads it without one).
    const f = focused();
    closeOverlay(overlay);
    openOverlay({ mod: "jhamill-worktree", kind: "dialog", width: 460, height: 280, props: { space: f?.space, folder: f?.cwd, action: "new" } });
  }

  render() {
    return div();
  }
}
