import palette from "./base.json";

function hslToRgba(h, s, l, a) {
  // Convert H, S, L to RGB
  let r, g, b;

  // Normalize H, S, L values
  h = h % 360; // Ensure hue is within 0-360
  s = s / 100; // Saturation is a percentage
  l = l / 100; // Lightness is a percentage

  if (s === 0) {
    // Achromatic (gray)
    r = g = b = l * 255;
  } else {
    const c = (1 - Math.abs(2 * l - 1)) * s; // Chroma
    const x = c * (1 - Math.abs(((h / 60) % 2) - 1)); // Temporary variable
    const m = l - c / 2; // Match the lightness

    let r1, g1, b1;

    if (h >= 0 && h < 60) {
      r1 = c;
      g1 = x;
      b1 = 0;
    } else if (h >= 60 && h < 120) {
      r1 = x;
      g1 = c;
      b1 = 0;
    } else if (h >= 120 && h < 180) {
      r1 = 0;
      g1 = c;
      b1 = x;
    } else if (h >= 180 && h < 240) {
      r1 = 0;
      g1 = x;
      b1 = c;
    } else if (h >= 240 && h < 300) {
      r1 = x;
      g1 = 0;
      b1 = c;
    } else {
      r1 = c;
      g1 = 0;
      b1 = x;
    }

    // Convert to RGB values
    r = Math.round((r1 + m) * 255);
    g = Math.round((g1 + m) * 255);
    b = Math.round((b1 + m) * 255);
  }

  return a ? [r, g, b, a] : [r, g, b];
}

function hslToHex(h, s, l) {
  // Normalize H, S, L values
  h = h % 360; // Ensure hue is within 0-360
  s = s / 100; // Saturation is a percentage
  l = l / 100; // Lightness is a percentage

  let r, g, b;

  if (s === 0) {
    // Achromatic (gray)
    r = g = b = l * 255;
  } else {
    const c = (1 - Math.abs(2 * l - 1)) * s; // Chroma
    const x = c * (1 - Math.abs(((h / 60) % 2) - 1)); // Temporary variable
    const m = l - c / 2; // Match the lightness

    let r1, g1, b1;

    if (h >= 0 && h < 60) {
      r1 = c;
      g1 = x;
      b1 = 0;
    } else if (h >= 60 && h < 120) {
      r1 = x;
      g1 = c;
      b1 = 0;
    } else if (h >= 120 && h < 180) {
      r1 = 0;
      g1 = c;
      b1 = x;
    } else if (h >= 180 && h < 240) {
      r1 = 0;
      g1 = x;
      b1 = c;
    } else if (h >= 240 && h < 300) {
      r1 = x;
      g1 = 0;
      b1 = c;
    } else {
      r1 = c;
      g1 = 0;
      b1 = x;
    }

    // Convert to RGB values
    r = Math.round((r1 + m) * 255);
    g = Math.round((g1 + m) * 255);
    b = Math.round((b1 + m) * 255);
  }

  // Convert RGB to Hex
  const toHex = (x) => x.toString(16).padStart(2, "0");

  return `${toHex(r)}${toHex(g)}${toHex(b)}`;
}

const colors = Object.fromEntries(
  Object.entries(palette)
    .map(([key, value]) => {
      const hsl = value.hsl;
      const rgb = hslToRgba(hsl[0], hsl[1], hsl[2]);
      const rgba = hslToRgba(hsl[0], hsl[1], hsl[2], 1);
      const hex = hslToHex(hsl[0], hsl[1], hsl[2]);

      return [
        [`${key}-hsl`, `hsl(${hsl.join(", ")})`],
        [`${key}-hex`, `#${hex}`],
        [`${key}-rgb`, `rgb(${rgb.join(", ")})`],
        [`${key}-rgbhex`, `rgb(${hex})`],
        [`${key}-rgba`, `rgba(${rgba.join(", ")})`],
      ];
    })
    .flat(),
);

await Bun.write("./palette.json", JSON.stringify(colors));
