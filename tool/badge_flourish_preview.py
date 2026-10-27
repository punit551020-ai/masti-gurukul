"""Preview the emblem flourish over the real badge artwork.

Usage: python3 tool_badge_check.py <top> <out>
"""
import math
import sys

from PIL import Image, ImageDraw

SRC = "assets/brand/logo_full.jpeg"
SIZE = 400

# Measured on the 1070x1082 artwork, then converted to the square the widget
# shows (BoxFit.cover crops 6px off the top and bottom).
CX, CY = 537.5 / 1070, (535.5 - 6) / 1070
RX, RY = 492 / 1070, 508 / 1070
TOP = (814 - 6) / 1070

CREAM = (254, 254, 254)
CREAM_END = (250, 245, 236)
SAFFRON = (255, 140, 0)
SAFFRON_BRIGHT = (255, 170, 60)
NAVY = (20, 33, 90)


def star(cx, cy, inner, outer):
    return [
        (
            cx + (outer if i % 2 == 0 else inner) * math.cos(-math.pi / 2 + i * math.pi / 5),
            cy + (outer if i % 2 == 0 else inner) * math.sin(-math.pi / 2 + i * math.pi / 5),
        )
        for i in range(10)
    ]


def build(top, path):
    img = Image.open(SRC).convert("RGB")
    scale = SIZE / img.width
    img = img.resize((SIZE, round(img.height * scale)))
    oy = (img.height - SIZE) // 2
    canvas = img.crop((0, oy, SIZE, oy + SIZE)).copy()
    draw = ImageDraw.Draw(canvas)

    cx, cy, rx, ry = CX * SIZE, CY * SIZE, RX * SIZE, RY * SIZE
    cover_top = top * SIZE

    for y in range(int(cover_top), int(cy + ry) + 1):
        t = (y - cy) / ry
        if abs(t) > 1:
            continue
        half = rx * math.sqrt(1 - t * t)
        x0, x1 = max(0.0, cx - half), min(SIZE - 1.0, cx + half)
        if x1 <= x0:
            continue
        f = (y - cover_top) / max(1.0, (cy + ry) - cover_top)
        col = tuple(round(a + (b - a) * f) for a, b in zip(CREAM, CREAM_END))
        draw.line([(x0, y), (x1, y)], fill=col)

    band_cy = cover_top + (cy + ry - cover_top) * 0.55
    s = SIZE * 0.030
    left, right = cx - s * 6.2, cx + s * 6.2
    draw.line([(left, band_cy), (cx - s * 2.4, band_cy)], fill=SAFFRON, width=3)
    draw.line([(cx + s * 2.4, band_cy), (right, band_cy)], fill=SAFFRON, width=3)
    draw.polygon(star(cx, band_cy, s * 0.45, s), fill=NAVY)
    draw.polygon(star(left, band_cy, s * 0.19, s * 0.3), fill=SAFFRON_BRIGHT)
    draw.polygon(star(right, band_cy, s * 0.19, s * 0.3), fill=SAFFRON_BRIGHT)
    canvas.save(path)
    print("wrote", path)


if __name__ == "__main__":
    build(float(sys.argv[1]) if len(sys.argv) > 1 else TOP,
          sys.argv[2] if len(sys.argv) > 2 else "/tmp/mg_badge_composite.png")
