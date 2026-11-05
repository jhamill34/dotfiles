// 8x8 pixel sprites for space avatars. Drawn for Herdr, not taken from any game.
// "." clear, "x" the space's color, "o" white, "k" near-black, and Everforest accents:
// "y" gold, "m" pink, "b" blue.
// jhamill-spaces and jhamill-picker each carry this file (a mod can't import from another
// mod's folder): change both copies together.

export const SPRITES = {
  slime: [
    "........",
    "...xx...",
    "..xxxx..",
    ".xxxxxx.",
    ".xokxok.",
    "xxxxxxxx",
    "xxxxxxxx",
    ".xxxxxx.",
  ],
  ghost: [
    "..xxxx..",
    ".xxxxxx.",
    "xxxxxxxx",
    "xokxxokx",
    "xxxxxxxx",
    "xxxxxxxx",
    "xxxxxxxx",
    "xx.xx.xx",
  ],
  cat: [
    ".x....x.",
    ".xx..xx.",
    ".xxxxxx.",
    "xxoxxoxx",
    "xxxxxxxx",
    "xxxkkxxx",
    ".xxxxxx.",
    "..xxxx..",
  ],
  robot: [
    "...xx...",
    ".xxxxxx.",
    ".xoxxox.",
    ".xxxxxx.",
    ".xkkkkx.",
    ".xxxxxx.",
    "..x..x..",
    ".xx..xx.",
  ],
  mushroom: [
    "..xxxx..",
    ".xoxxox.",
    "xxxxxxxx",
    "xoxxxxox",
    "xxxxxxxx",
    ".oooooo.",
    ".okooko.",
    "..oooo..",
  ],
  octopus: [
    "..xxxx..",
    ".xxxxxx.",
    "xxxxxxxx",
    "xokxxokx",
    "xxxxxxxx",
    ".xxxxxx.",
    "x.x..x.x",
    ".x.xx.x.",
  ],
  skull: [
    ".xxxxxx.",
    "xxxxxxxx",
    "xkkxxkkx",
    "xkkxxkkx",
    "xxxkkxxx",
    ".xxxxxx.",
    ".x.xx.x.",
    ".xxxxxx.",
  ],
  heart: [
    "........",
    ".xx..xx.",
    "xoxxxxxx",
    "xxxxxxxx",
    "xxxxxxxx",
    ".xxxxxx.",
    "..xxxx..",
    "...xx...",
  ],
  potion: [
    "...oo...",
    "...xx...",
    "...xx...",
    "..xxxx..",
    ".xxxxxx.",
    ".xoxxxx.",
    ".xxxxxx.",
    "..xxxx..",
  ],
  frog: [
    ".xx..xx.",
    "xokxxokx",
    "xxxxxxxx",
    "xkxxxxkx",
    "xxkkkkxx",
    "xxxxxxxx",
    ".xxxxxx.",
    "xx....xx",
  ],
  rocket: [
    "...xx...",
    "..xxxx..",
    "..xoox..",
    "..xxxx..",
    ".xxxxxx.",
    "xxxxxxxx",
    "x.xxxx.x",
    "...oo...",
  ],
  terminal: [
    "xxxxxxxx",
    "xkkkkkkx",
    "xokkkkkx",
    "xkokkkkx",
    "xokkookx",
    "xkkkkkkx",
    "xxxxxxxx",
    "..xxxx..",
  ],
  coffee: [
    ".o..o...",
    "..o..o..",
    "xxxxxx..",
    "xxxxxxxx",
    "xxxxxx.x",
    "xxxxxxxx",
    "xxxxxx..",
    ".xxxx...",
  ],
  bomb: [
    "......o.",
    ".....x..",
    "..xxxx..",
    ".xxxxxx.",
    "xoxxxxxx",
    "xxxxxxxx",
    ".xxxxxx.",
    "..xxxx..",
  ],
  star: [
    "...xx...",
    "...xx...",
    "xxxxxxxx",
    ".xxxxxx.",
    "..xxxx..",
    ".xxxxxx.",
    ".xx..xx.",
    ".x....x.",
  ],
  // jhamill: the magical set. New spaces get one of these.
  "wizard": [
    ".....x..",
    "....xx..",
    "...xxx..",
    "...xyxx.",
    "..xxxxx.",
    "..xxxyxx",
    "yyyyyyyy",
    "........",
  ],
  "crystal-ball": [
    "..xxxx..",
    ".xoxxxx.",
    "xoxxxxxx",
    "xxxxxxxx",
    "xxxxxxxx",
    ".xxxxxx.",
    "..yyyy..",
    ".yyyyyy.",
  ],
  "wand": [
    "....y.y.",
    ".....y..",
    "....yoy.",
    "....xy..",
    "...x..y.",
    "..x.....",
    ".x......",
    "x.......",
  ],
  "dragon": [
    "x..x....",
    "xxxxx...",
    ".xkxxx..",
    "xxxxxxyy",
    "..xxxx..",
    "x.xxxxx.",
    "xx.x..x.",
    "........",
  ],
  "unicorn": [
    "y.......",
    ".y..m...",
    "..xxmm..",
    "..xkxmm.",
    ".xxxxxmm",
    "xxxxxxxm",
    "xx..xxxm",
    "....xxx.",
  ],
  "moon": [
    "..xxx...",
    ".xxx....",
    "xxx.....",
    "xxx...y.",
    "xxx.....",
    "xxxx....",
    ".xxxxx..",
    "..xxx...",
  ],
  "spellbook": [
    "xxxxxxx.",
    "xoooooxk",
    "xoxyxoxk",
    "xoyyyoxk",
    "xoxyxoxk",
    "xoooooxk",
    "xxxxxxxk",
    ".kkkkkkk",
  ],
  "owl": [
    "x......x",
    "xx....xx",
    "xxxxxxxx",
    "xokxxokx",
    "xxxyyxxx",
    "xxxxxxxx",
    ".xxxxxx.",
    "..y..y..",
  ],
  "cauldron": [
    "..o.o...",
    ".o...o..",
    "xmmmmmmx",
    "xxxxxxxx",
    "xxxxxxxx",
    "xxxxxxxx",
    ".xxxxxx.",
    ".x....x.",
  ],
  "candle": [
    "....y...",
    "...yy...",
    "...yo...",
    "...xx...",
    "...xx...",
    "...xx...",
    "..xxxx..",
    ".yyyyyy.",
  ],
  "gem": [
    "..xxxx..",
    ".xoxxxx.",
    "xoxxxxxx",
    "xxxxxxxx",
    ".xxxxxx.",
    "..xxxx..",
    "...xx...",
    "........",
  ],
  "sparkle": [
    "...x...y",
    "...x....",
    "..xox...",
    "xxoooxx.",
    "..xox...",
    "...x....",
    "...x..y.",
    "........",
  ],
  "key": [
    "..xxx...",
    ".x...x..",
    ".x...x..",
    "..xxx...",
    "...x....",
    "...xx...",
    "...x....",
    "...xx...",
  ],
  "comet": [
    "......xx",
    ".....xox",
    "....xxx.",
    "...yy...",
    "..y.....",
    ".y......",
    "y.......",
    "........",
  ],
  "fairy": [
    "m.....m.",
    "mm.xx.mm",
    "mmxoxxmm",
    ".mxxxxm.",
    "..xxxx..",
    "...xx...",
    "..x..x..",
    "........",
  ],
  "frog-prince": [
    "y.y..y.y",
    "yyyyyyyy",
    ".xx..xx.",
    "xokxxokx",
    "xxxxxxxx",
    "xkxxxxkx",
    "xxkkkkxx",
    ".xxxxxx.",
  ],
};

export const NAMES = Object.keys(SPRITES);
export const MAGIC = NAMES.slice(NAMES.indexOf("wizard"));

// Each run of one color in a row is one rectangle: [char, length].
function runs(row) {
  const out = [];
  for (let i = 0; i < row.length; ) {
    let j = i;
    while (j < row.length && row[j] === row[i]) j++;
    out.push([row[i], j - i]);
    i = j;
  }
  return out;
}

// The sprite as GPUI rectangles, `px` pixels per sprite pixel.
export function sprite(name, fill, { div, v_flex, h_flex }, px = 2) {
  const rows = SPRITES[name] ?? SPRITES.slime;
  const ink = { x: fill, o: "#ffffff", k: "#17181c", y: "#dbbc7f", m: "#d699b6", b: "#7fbbb3" };
  return v_flex().flex_none().w(px * 8).h(px * rows.length).children(
    rows.map((row) => h_flex().flex_none().h(px).children(
      runs(row).map(([c, n]) => {
        const cell = div().flex_none().w(px * n).h(px);
        return c === "." ? cell : cell.bg(ink[c]);
      }),
    )),
  );
}

// A sprite for each space: kept once picked, new spaces get the least used one.
export function assign(spaces, kept, pool = NAMES) {
  const out = { ...kept };
  let changed = false;
  for (const s of spaces) {
    if (out[s.id] && NAMES.includes(out[s.id])) continue;
    const uses = (n) => Object.values(out).filter((v) => v === n).length;
    const least = Math.min(...pool.map(uses));
    const free = pool.filter((n) => uses(n) === least);
    let h = 0;
    for (const ch of s.name ?? s.id) h = (h * 31 + ch.charCodeAt(0)) >>> 0;
    out[s.id] = free[h % free.length];
    changed = true;
  }
  return { out, changed };
}
